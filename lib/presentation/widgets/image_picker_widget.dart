import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

import '../../config/helpers/permissions_helper.dart';

class ImagePickerWidget extends StatelessWidget {
  final Function(XFile?) onImageSelected;

  const ImagePickerWidget({super.key, required this.onImageSelected});

  static Future<XFile?> pickImage(BuildContext context) async {
    bool isGranted = await PermissionsHelper.storagePermission();
    if (isGranted) {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );
      
      if (image != null) {
        final appDir = await getApplicationDocumentsDirectory();
        final fileName = path.basename(image.path);
        final savedImage = await File(image.path).copy('${appDir.path}/$fileName');
        
        return XFile(savedImage.path);
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}