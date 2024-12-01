import 'package:device_info_plus/device_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionsHelper {
  
  static Future<bool> storagePermission() async {
    final DeviceInfoPlugin info = DeviceInfoPlugin();
    final AndroidDeviceInfo androidInfo = await info.androidInfo;
    final int androidVersion = int.parse(androidInfo.version.release);
    bool havePermission = false;

    // Pedir los permisos de las fotos/imágenes
    if (androidVersion >= 13) {
      final request = await [
        Permission.photos,
      ].request();

      havePermission = request.values.every((status) => status == PermissionStatus.granted);
    } else {
      final status = await Permission.storage.request();
      havePermission = status.isGranted;
    }

    if (!havePermission) {
      // Si no se concedió el permiso, abrir la configuración de la aplicación 
      // para que el usuario lo conceda manualmente
      await openAppSettings();
    }

    return havePermission;
  }

}