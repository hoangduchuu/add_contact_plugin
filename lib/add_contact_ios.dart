
import 'add_contact_ios_platform_interface.dart';

class AddContactIos {
  Future<String?> getPlatformVersion() {
    return AddContactIosPlatform.instance.getPlatformVersion();
  }
}
