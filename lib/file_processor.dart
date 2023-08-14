import 'package:file_picker/file_picker.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_native_image/flutter_native_image.dart';

enum IPtype { image, audio, video, media, any }

enum Errors { largeFile, missingRef, noPickedFile, cantCompress }

class FileProccessor {
  final String retFromUrl;
  final double maxSizeAsMB;
  final bool compress;
  final String photoName;
  final int? compressQuality;
  final Function? started;
  final Function(String url)? ended;
  final IPtype fileType;
  final Function(Errors errorCode)? onError;
  FileProccessor(
      {this.retFromUrl = "",
      this.maxSizeAsMB = 1,
      this.compress = false,
      this.compressQuality,
      required this.photoName,
      this.started,
      this.fileType = IPtype.image,
      this.onError,
      this.ended});

  //desteklnen formatlarda dosyayı alıp döndürüyor
  static Future<File> getFile(
      {IPtype fileType = IPtype.image,
      int maxSizeAsMB = 5,
      Function(Errors errorCode)? onError}) async {
    //Dosya alan metod
    final result = await FilePicker.platform.pickFiles(
      allowMultiple: false,
      type: fileType == IPtype.any
          ? FileType.any
          : fileType == IPtype.audio
              ? FileType.audio
              : fileType == IPtype.image
                  ? FileType.image
                  : fileType == IPtype.media
                      ? FileType.media
                      : FileType.video,
    );
    if (result == null) {
      if (onError != null) onError(Errors.noPickedFile);

      throw NoPickedFile.error();
    }
    final path = result.files.single.path;
    return File(path!);
  }

  static Future<List<File>> getMultipleFiles(
      {IPtype fileType = IPtype.image,
      int maxSizeAsMB = 5,
      Function(Errors errorCode)? onError}) async {
    //Dosya alan metod
    final result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: fileType == IPtype.any
          ? FileType.any
          : fileType == IPtype.audio
              ? FileType.audio
              : fileType == IPtype.image
                  ? FileType.image
                  : fileType == IPtype.media
                      ? FileType.media
                      : FileType.video,
    );
    if (result == null) {
      if (onError != null) onError(Errors.noPickedFile);

      throw NoPickedFile.error();
    }
    final path =
        List.generate(result.files.length, (index) => result.files[index].path);
    return List.generate(path.length, (index) => File(path[index]!));
  }

  Future<String> _downloadUrl(path) async {
    return await FirebaseStorage.instance
        .refFromURL(this.retFromUrl)
        .child(path)
        .getDownloadURL();
  }

  Future<File> _compressFile(
      File file, int quality, IPtype fileType, double targetSizeInMB) async {
    if (fileType == IPtype.image) {
      File compressedFile = await FlutterNativeImage.compressImage(
        file.path,
        quality: quality,
      );

      while (compressedFile.lengthSync() > targetSizeInMB * 1024 * 1024) {
        quality -= 10;
        compressedFile = await FlutterNativeImage.compressImage(
          file.path,
          quality: quality,
        );
      }

      return compressedFile;
    } else {
      return file;
    }
  }

  Future<String> uploadFiletoFirebase(
      File? file, double maxSizeAsMegabyte) async {
    if (this.retFromUrl.isEmpty) {
      throw MissingRefURL.error();
    }
    if (started != null) {
      started!();
    }
    if (file != null) {
      File theFile = file;
      if (this.compress) {
        theFile = await _compressFile(
            file, this.compressQuality ?? 25, IPtype.image, maxSizeAsMegabyte);
      }
      return await FirebaseStorage.instance
          .refFromURL(this.retFromUrl)
          .child(photoName)
          .putFile(theFile)
          .then((p0) async {
        return await _downloadUrl(photoName).then((url) {
          //url burda dönüyor

          if (ended != null) {
            ended!(url);
          }
          return url;
        });
      });
    } else {
      return "";
    }
  }

  Future<String> uploadVideotoFirebase(File? file) async {
    if (this.retFromUrl.isEmpty) {
      throw MissingRefURL.error();
    }
    if (started != null) {
      started!();
    }
    if (file != null) {
      File theFile = file;
      if (this.compress) {
        theFile = await _compressFile(
            file, this.compressQuality ?? 25, IPtype.video, maxSizeAsMB);
      }
      return await FirebaseStorage.instance
          .refFromURL(this.retFromUrl)
          .child(photoName)
          .putFile(theFile, SettableMetadata(contentType: 'video/mp4'))
          .then((p0) async {
        return await _downloadUrl(photoName).then((url) {
          //url burda dönüyor
          if (ended != null) {
            ended!(url);
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
      print("SİLİNEMEDİ!!!");
      print(e.toString());
    }
  }

  Future<void> cancel() async {
    if (this.retFromUrl == null) {
      if (onError != null) onError!(Errors.missingRef);

      throw MissingRefURL.error();
    }
    await FirebaseStorage.instance
        .refFromURL(this.retFromUrl)
        .child(photoName)
        .delete();
  }
}

class LargeFileError {
  //max boyutu aşan dosya
  static error() {
    return {"code": 301, "message": "Large file sizes!"};
  }
}

class MissingRefURL {
  //firebase ref girilmemiş
  static error() {
    return {"code": 302, "message": "Missing Firebase Storage Ref Url"};
  }
}

class NoPickedFile {
//dosya seçilmemiş
  static error() {
    return {"code": 303, "message": "There is no picked file"};
  }
}

class CantCompress {
//dosya seçilmemiş
  static error() {
    return {"code": 333, "message": "This file type is not image!"};
  }
}

enum SizeOptions { kb, mb, gb }
