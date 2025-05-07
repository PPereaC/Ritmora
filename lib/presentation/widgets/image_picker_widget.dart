import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'package:uuid/uuid.dart';

import '../../config/helpers/permissions_helper.dart';

class ImagePickerWidget {
  static Future<String?> pickImage(BuildContext context) async {
    bool isGranted = await PermissionsHelper.storagePermission();
    if (!isGranted) return null;

    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );
      
    if (image == null) return null;

    try {
      // 1. Obtener directorio de la aplicación
      final appDir = await getApplicationCacheDirectory();
      final imagesDir = Directory('${appDir.path}/playlist_images');
      
      // 2. Crear directorio si no existe
      if (!await imagesDir.exists()) {
        await imagesDir.create(recursive: true);
      }
      
      // 3. Generar nombre único para el archivo
      final extension = path.extension(image.path); // .jpg, .png, etc.
      final uniqueName = '${const Uuid().v4()}$extension';
      final newPath = '${imagesDir.path}/$uniqueName';
      
      // 4. Copiar la imagen al directorio de la aplicación
      await File(image.path).copy(newPath);
      
      // 5. Devolver la ruta del archivo guardado
      return newPath;
    } catch (e) {
      debugPrint('Error al guardar la imagen: $e');
      return null;
    }
  }
}