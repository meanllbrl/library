import 'package:file_picker/file_picker.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_native_image/flutter_native_image.dart';

enum IPtype { image, audio, video, media, any }

class FileProccessor {
  final String retFromUrl;
  final double maxSizeAsMB;
  final bool compress;
  final String photoName;
  final int? compressQuality;
  final Function? started;
  final Function(String url)? ended;
  final IPtype fileType;
  final Function(int errorCode)? onError;
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
      Function(int errorCode)? onError}) async {
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
    if (onError != null) onError(303);
    if (result == null) throw NoPickedFile.error();
    final path = result.files.single.path;
    File file = File(path!);
    double fileSizeMB = file.lengthSync() / (1024 * 1024);
    if (fileSizeMB > maxSizeAsMB) {
      if (onError != null) onError(301);

      throw LargeFileError.error();
    }
    return file;
  }

  Future<String> _downloadUrl(path) async {
    return await FirebaseStorage.instance
        .refFromURL(this.retFromUrl)
        .child(path)
        .getDownloadURL();
  }

  Future<File> _compressFile(File file, int quality) async {
    if (IPtype.image == fileType) {
      File compressedFile = await FlutterNativeImage.compressImage(
        file.path,
        quality: quality,
      );
      return compressedFile;
    }
    if (onError != null) onError!(333);

    throw CantCompress();
  }

  Future<String> uploadFiletoFirebase(File? file) async {
    if (this.retFromUrl.isEmpty) {
      throw MissingRefURL.error();
    }
    if (started != null) {
      started!();
    }
    if (file != null) {
      File theFile = file;
      if (this.compress) {
        theFile = await _compressFile(file, this.compressQuality ?? 25);
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

  Future<void> cancel() async {
    if (this.retFromUrl == null) {
      if (onError != null) onError!(302);

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
