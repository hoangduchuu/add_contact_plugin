import 'package:add_contact_ios/contact_model.dart';

import 'add_contact_ios_platform_interface.dart';

class AddContactIos {
  Future<bool?> addContact({required Contact contact}) {
    return AddContactIosPlatform.instance.addContact(contact);
  }
}
