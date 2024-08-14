import 'package:add_contact_ios/contact_model.dart';
import 'package:add_contact_ios/enum.dart';
import 'add_contact_ios_platform_interface.dart';

class AddContactIos {
  Future<ContactOperationResult> addContact({required Contact contact}) {
    return AddContactIosPlatform.instance.addContact(contact);
  }

  Future<ContactOperationResult> openVCard({required Contact contact}) {
    return AddContactIosPlatform.instance.openVCard(contact);
  }
}
