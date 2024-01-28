import 'package:file_picker/file_picker.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';

/// Enum representing different types of intellectual property file types.
enum IPtype { image, audio, video, media, any }

/// Enum representing different error types that can occur during file processing.
enum Errors { largeFile, missingRef, noPickedFile, cantCompress }

/// A class designed to process files, potentially uploading them to Firebase Cloud Functions,
/// with optional compression and support for error-handling callbacks.
class FileProcessor {
  /// The root URL for Firebase Cloud Functions.
  final String? firebaseCloudFunctionsRootUrl;

  /// The maximum size allowed for a file in megabytes (MB).
  /// if not given
  /// ```dart
  /// maxSizeAsMB = 1;
  /// ```
  final double maxSizeAsMB;

  /// Indicates if the class should attempt to compress the file.
  final bool compress;

  /// The quality percentage to use when compressing the file.
  /// if not given
  /// ```dart
  /// compressQuality = 75;
  /// ```
  final int? compressQuality;

  /// The name to assign the processed photo.
  final String photoName;

  /// An optional callback function that gets triggered when processing starts.
  final Function? onStarted;

  /// An optional callback function that provides the URL of the processed file once completed.
  final Function(String url)? onEnded;

  /// The type of file being processed, as defined by [IPtype].
  final IPtype fileType;

  /// An optional callback function that gets triggered in case of an error, providing error code.
  final Function(Errors errorCode)? onError;

  /// Constructs a [FileProcessor] with the given parameters.
  ///
  /// The [photoName] is required, while the rest of the parameters have default values or are optional.
  FileProcessor({
    this.firebaseCloudFunctionsRootUrl,
    this.maxSizeAsMB = 1,
    this.compress = false,
    this.compressQuality = 75,
    required this.photoName,
    this.onStarted,
    this.fileType = IPtype.image,
    this.onError,
    this.onEnded,
  });

  /// Picks a single file from the device storage with optional file type filtering
  /// and file size limitation, providing error reporting through a callback.
  ///
  /// [fileType] specifies the type of file to pick, defaulting to [IPtype.image].
  /// [maxSizeAsMB] specifies the maximum acceptable file size in megabytes (MB),
  /// defaulting to 5 MB.
  /// [onError] is an optional callback to handle error reporting, it receives an [Errors] code.
  ///
  /// Returns a [File] object representing the picked file, or throws an exception if an error occurs.
  static Future<File> getFile({
    IPtype fileType = IPtype.image,
    int maxSizeAsMB = 1,
    Function(Errors errorCode)? onError,
  }) async {
    // Attempt to pick a file while allowing only specific types based on [fileType].
    final result = await FilePicker.platform.pickFiles(
      allowMultiple: false,
      type: _getFileType(fileType),
    );

    // If no file is picked, invoke the error callback and throw a specific error.
    if (result == null) {
      if (onError != null) onError(Errors.noPickedFile);

      throw NoPickedFile("User didn't picked any file");
    }

    // Retrieve the picked file's path and return the file.
    final path = result.files.single.path;
    if (path == null) throw Exception("Unable to retrieve the file path.");

    // Optionally perform a file size check and handle errors here, if required.

    return File(path);
  }

  /// Picks multiple files from device storage with optional file type filtering
  /// and file size limitation, providing error reporting through a callback.
  ///
  /// [fileType] specifies the types of files to pick, defaulting to [IPtype.image].
  /// [maxSizeAsMB] specifies the maximum acceptable file size in megabytes (MB),
  /// defaulting to 1 MB.
  /// [onError] is an optional callback to handle error reporting, it receives [Errors] code.
  ///
  /// Returns a [List<File>] objects representing the picked files.
  /// Throws an exception if no files are picked or if any other error occurs.
  static Future<List<File>> getMultipleFiles({
    IPtype fileType = IPtype.image,
    int maxSizeAsMB = 1,
    Function(Errors errorCode)? onError,
  }) async {
    // Attempt to pick multiple files while allowing only specific types based on [fileType].
    final result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: _getFileType(fileType),
    );

    // If no files are picked, invoke the error callback and throw a specific error.
    if (result == null) {
      if (onError != null) onError(Errors.noPickedFile);
      throw NoPickedFile("User didn't picked any file!", errorCode: 333);
    }

    // Retrieve paths of the picked files, ensuring no null paths are included.
    final paths = result.files
        .map((file) => file.path)
        .where((path) => path != null)
        .toList();

    // Optionally perform a file size check and handle errors here, if required.

    // Convert and return the paths to [File] objects.
    return paths.map((path) => File(path!)).toList();
  }

  /// Uploads a file to Firebase Storage and provides the download URL upon completion.
  ///
  /// [file] is the file to be uploaded. If null, an empty string is returned.
  /// The method checks if [firebaseCloudFunctionsRootUrl] is set, otherwise it throws an exception.
  /// If the [onStarted] callback is provided, it's called at the beginning of the process.
  /// The file will be compressed if the [compress] property is true.
  ///
  /// Returns the download URL as a string.
  Future<String> uploadFiletoFirebaseNew(File? file) async {
    // Throw an error if the Firebase Cloud Functions URL is not set.
    if (firebaseCloudFunctionsRootUrl == null ||
        firebaseCloudFunctionsRootUrl!.isEmpty) {
      throw MissingRefURL();
    }

    // Invoke the onStarted callback, if provided.
    if (onStarted != null) onStarted!();

    if (file != null) {
      var theFile = file;

      // Compress the file if the 'compress' flag is true.
      if (this.compress) {
        theFile = await _compressFile(
            file, this.compressQuality ?? 25, IPtype.image, maxSizeAsMB);
      }

      try {
        // Begin the upload process to Firebase Storage.
        final ref = FirebaseStorage.instance
            .refFromURL(firebaseCloudFunctionsRootUrl!)
            .child(photoName);

        // Upload the file and obtain the task snapshot.
        final taskSnapshot = await ref.putFile(theFile);

        // Retrieve and return the download URL.
        final url = await taskSnapshot.ref.getDownloadURL();
        if (onEnded != null) onEnded!(url);
        return url;
      } on FirebaseException {
        if (onError != null) onError!(Errors.cantCompress);

        rethrow; // Optional: rethrow to allow further upstream handling.
      }
    } else {
      if (onError != null) onError!(Errors.noPickedFile);
      return ""; // Consider throwing an exception instead.
    }
  }

  /// **DEPRECATED**
  /// Uploads a file to Firebase Storage and provides the download URL upon completion.
  ///
  /// [file] is the file to be uploaded. If null, an empty string is returned.
  /// The method checks if [firebaseCloudFunctionsRootUrl] is set, otherwise it throws an exception.
  /// If the [onStarted] callback is provided, it's called at the beginning of the process.
  /// The file will be compressed if the [compress] property is true.
  ///
  /// Returns the download URL as a string.
  Future<UploadedFile?> uploadFiletoFirebase(File? file) async {
    // Throw an error if the Firebase Cloud Functions URL is not set.
    if (firebaseCloudFunctionsRootUrl == null ||
        firebaseCloudFunctionsRootUrl!.isEmpty) {
      throw MissingRefURL();
    }

    // Invoke the onStarted callback, if provided.
    if (onStarted != null) onStarted!();

    if (file != null) {
      var theFile = file;

      // Compress the file if the 'compress' flag is true.
      if (this.compress) {
        theFile = await _compressFile(
            file, this.compressQuality ?? 25, IPtype.image, maxSizeAsMB);
      }

      try {
        // Begin the upload process to Firebase Storage.
        final ref = FirebaseStorage.instance
            .refFromURL(firebaseCloudFunctionsRootUrl!)
            .child(photoName);

        // Upload the file and obtain the task snapshot.
        final taskSnapshot = await ref.putFile(theFile);

        // Retrieve and return the download URL.
        final url = await taskSnapshot.ref.getDownloadURL();
        if (onEnded != null) onEnded!(url);
        return UploadedFile(url: url, path: photoName);
      } on FirebaseException {
        if (onError != null) onError!(Errors.cantCompress);

        rethrow; // Optional: rethrow to allow further upstream handling.
      }
    } else {
      if (onError != null) onError!(Errors.noPickedFile);
      return null;
    }
  }

  Future<String> uploadVideotoFirebase(File? file) async {
    if (firebaseCloudFunctionsRootUrl == null ||
        firebaseCloudFunctionsRootUrl!.isEmpty) {
      throw MissingRefURL();
    }
    if (onStarted != null) {
      onStarted!();
    }
    if (file != null) {
      File theFile = file;
      if (this.compress) {
        theFile = await _compressFile(
            file, this.compressQuality ?? 25, IPtype.video, maxSizeAsMB);
      }
      return await FirebaseStorage.instance
          .refFromURL(firebaseCloudFunctionsRootUrl!)
          .child(photoName)
          .putFile(theFile, SettableMetadata(contentType: 'video/mp4'))
          .then((p0) async {
        return await _downloadUrl(photoName).then((url) {
          //url burda dönüyor
          if (onEnded != null) {
            onEnded!(url);
          }
          return url;
        });
      });
    } else {
      return "";
    }
  }

  static Future<double> getFileSize(String filepath) async {
    var file = File(filepath);
    int bytes = await file.length();
    if (bytes <= 0) return 0;

    return bytes / (1024 * 1024);
  }

  static Future<void> deleteFromStorage(String refFromUrl, String path) async {
    try {
      await FirebaseStorage.instance
          .refFromURL(refFromUrl)
          .child(path)
          .delete();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> cancel() async {
    if (this.firebaseCloudFunctionsRootUrl == null ||
        this.firebaseCloudFunctionsRootUrl!.isEmpty) {
      if (onError != null) onError!(Errors.missingRef);

      throw MissingRefURL();
    }
    await FirebaseStorage.instance
        .refFromURL(firebaseCloudFunctionsRootUrl!)
        .child(photoName)
        .delete();
  }

  /// Helper method to convert [IPtype] to [FileType], which is required by the FilePicker package.
  static FileType _getFileType(IPtype fileType) {
    switch (fileType) {
      case IPtype.any:
        return FileType.any;
      case IPtype.audio:
        return FileType.audio;
      case IPtype.image:
        return FileType.image;
      case IPtype.media:
        return FileType.media;
      case IPtype.video:
        return FileType.video;
      default:
        return FileType.any;
    }
  }

  Future<String> _downloadUrl(path) async {
    if (this.firebaseCloudFunctionsRootUrl == null ||
        this.firebaseCloudFunctionsRootUrl!.isEmpty) {
      if (onError != null) onError!(Errors.missingRef);

      throw MissingRefURL();
    }
    return await FirebaseStorage.instance
        .refFromURL(this.firebaseCloudFunctionsRootUrl!)
        .child(path)
        .getDownloadURL();
  }

  /// Compresses an image file to a target size if the file exceeds 500 KB while
  /// respecting the specified quality and file type.
  ///
  /// [file] - the file to be compressed.
  /// [quality] - the initial quality percentage to start compression with.
  /// [fileType] - the type of file to be compressed; currently, only images are supported.
  /// [targetSizeInMB] - the target size for the compressed file in megabytes (MB).
  ///
  /// Returns a [File] object of the compressed image. If the file is already smaller than 500 KB
  /// or the file type is not an image, the method returns the original file.
  Future<File> _compressFile(
      File file, int quality, IPtype fileType, double targetSizeInMB) async {
    const int fileSizeThreshold = 500 * 1024; // 500 KB

    // Check if the file size is already less than 500 KB.
    if (file.lengthSync() <= fileSizeThreshold) {
      // No need to compress, return the original file.
      return file;
    }

    // Compressions only applied to images.
    if (fileType == IPtype.image) {
      // Initialize a compressed file by compressing the original image file.
      File compressedFile = await FlutterImageCompress.compressAndGetFile(
        file.path,
        file.path,
        quality: quality,
      ).then((value) => File((value?.path ?? file.path)));

      // Continue to compress in a loop until the file size is under the threshold
      // or the file size meets the target size.
      while (compressedFile.lengthSync() > fileSizeThreshold &&
          compressedFile.lengthSync() > targetSizeInMB * 1024 * 1024) {
        // Reduce the quality incrementally for further compression.
        quality = (quality - 10)
            .clamp(0, 100); // Ensure the quality doesn't go below 0
        // Compress the image again with the new quality.
        compressedFile = await FlutterImageCompress.compressAndGetFile(
          file.path,
          file.path,
          quality: quality,
        ).then((value) => File((value?.path ?? file.path)));
      }

      // Return the final compressed image file.
      return compressedFile;
    } else {
      // If the file is not an image, compression is not applied.
      return file;
    }
  }
}

class MissingRefURL implements Exception {
  final String message;
  final int errorCode; // Add an error code field

  MissingRefURL({
    this.errorCode = 302,
    this.message =
        "Object Configuration Failed! Please consider to define [firebaseCloudFunctionsRootUrl] correctly!",
  });

  @override
  String toString() {
    return 'MissingRefURL (Code $errorCode): $message';
  }
}

class NoPickedFile implements Exception {
  final String message;
  final int errorCode; // Add an error code field

  NoPickedFile(this.message, {this.errorCode = 0});

  @override
  String toString() {
    return 'NoPickedFile (Code $errorCode): $message';
  }
}

class CantCompress implements Exception {
  final String message;
  final int errorCode; // Add an error code field

  CantCompress(this.message, {this.errorCode = 0});

  @override
  String toString() {
    return 'CantCompress (Code $errorCode): $message';
  }
}

enum SizeOptions { kb, mb, gb }

class UploadedFile {
  final String url;
  final String path;

  UploadedFile({required this.url, required this.path});
}
