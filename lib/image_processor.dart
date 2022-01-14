import 'package:file_picker/file_picker.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_native_image/flutter_native_image.dart';

class ImageProcessor {
  final String retFromUrl;
  final double maxSizeAsMB;
  final bool compress;
  final String photoName;
  final int? compressQuality;
  final Function? started;
  final Function(String url)? ended;
  ImageProcessor(
      {this.retFromUrl = "",
      this.maxSizeAsMB = 1,
      this.compress = false,
      this.compressQuality,
      required this.photoName,
      this.started,
      this.ended});

  //desteklnen formatlarda dosyayı alıp döndürüyor
  Future<File> getImage() async {
    final result = await FilePicker.platform.pickFiles(
      allowMultiple: false,
      type: FileType.image,
    );

    if (result == null) throw NoPickedFile.error();
    final path = result.files.single.path;
    File file = File(path!);
    double fileSizeMB = file.lengthSync() / (1024 * 1024);
    if (fileSizeMB > maxSizeAsMB) {
      throw LargeFileError.error();
    }
    return file;
  }

  Future<String> downloadUrl(path) async {
    return await FirebaseStorage.instance
        .refFromURL(this.retFromUrl)
        .child(path)
        .getDownloadURL();
  }

  static Future<File> compressFile(File file, int quality) async {
    File compressedFile = await FlutterNativeImage.compressImage(
      file.path,
      quality: quality,
    );
    return compressedFile;
  }

  Future<String> uploadImagetoFirebase(File? file) async {
    if (this.retFromUrl.isEmpty) {
      throw MissingRefURL.error();
    }
    if (started != null) {
      started!();
    }
    if (file != null) {
      File theFile = file;
      if (this.compress) {
        theFile = await compressFile(file, this.compressQuality ?? 25);
      }
      return await FirebaseStorage.instance
          .refFromURL(this.retFromUrl)
          .child(photoName)
          .putFile(theFile)
          .then((p0) async {
        return await downloadUrl(photoName).then((url) {
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
