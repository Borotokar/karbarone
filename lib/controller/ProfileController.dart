import 'package:borotokar/Congit.dart';
import 'package:borotokar/controller/AuthController.dart';
import 'package:borotokar/controller/DataBaseController.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:path/path.dart' as p;

class ProfileController extends GetxController {
  var selectedImagePath = ''.obs;
  final ImagePicker _picker = ImagePicker();
  final DatabaseController dbController = Get.find<DatabaseController>();
  AuthController authController = Get.find();

  Future<void> pickImage(ImageSource source, context) async {
    final pickedFile = await _picker.pickImage(source: source);

    if (pickedFile != null) {
      var croppedFile = await ImageCropper().cropImage(
        sourcePath: pickedFile.path,
        // aspectRatioPresets: [
        //   CropAspectRatioPreset.square,
        //   CropAspectRatioPreset.ratio3x2,
        //   CropAspectRatioPreset.original,
        //   CropAspectRatioPreset.ratio4x3,
        //   CropAspectRatioPreset.ratio16x9
        // ],
        // aspectRatio: CropAspectRatio(ratioX: 200, ratioY: 200),
        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: 'ویرایش عکس',
            toolbarColor: Colors.lightGreen,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: true,
            cropStyle: CropStyle.rectangle,
          ),
          IOSUiSettings(title: 'ویرایش عکس'),
          WebUiSettings(context: context),
        ],
      );
      selectedImagePath.value = pickedFile.path;
      uploadImage(File(croppedFile!.path));
    } else {
      Get.snackbar('خطا', 'خطا در انتخاب عکس');
    }
  }

  Future<XFile?> PCompressAndGetFile(File file) async {
    final CompressFormat format = CompressFormat.jpeg;
    final String targetPath = p.join(
      Directory.systemTemp.path,
      'temp.${format.name}',
    );
    var result = await FlutterImageCompress.compressAndGetFile(
      file.absolute.path,
      targetPath,
      // rotate: 180,
      quality: 50, // تنظیم کیفیت فشرده‌سازی
      minWidth: 600, // تنظیم حداقل عرض
      minHeight: 600,
    );

    print(file.lengthSync());

    return result;
  }

  Future<void> uploadImage(File image) async {
    final tokenEntity = await dbController.tokendao.findTokenById(1);
    if (tokenEntity != null) {
      final headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${tokenEntity.token}',
      };

      var request = http.MultipartRequest(
        'POST',
        Uri.parse('$API_URL/user/editprofileimage'),
      );
      final myimage = await PCompressAndGetFile(image);
      request.files.add(
        await http.MultipartFile.fromPath('image', myimage!.path),
      );
      request.headers.addAll(headers);
      var response = await request.send();
      // Get.snackbar('Success', image.path);
      if (response.statusCode == 200) {
        Get.snackbar('موفقیت', 'عکس با موفقیت آپلود شد');
        authController.fetchAndSetUserData();
      } else {
        Get.snackbar(
          'خطا',
          'در ارسال عکس شما خطایی رخ داد لطفا سایز عکس خود را چک کرده و دوباره اقدام کنید.',
        );
      }
    }
  }
}
