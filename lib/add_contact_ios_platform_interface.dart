import 'package:add_contact_ios/contact_model.dart';
import 'package:add_contact_ios/enum.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'add_contact_ios_method_channel.dart';

abstract class AddContactIosPlatform extends PlatformInterface {
  AddContactIosPlatform() : super(token: _token);

  static final Object _token = Object();

  static AddContactIosPlatform _instance = MethodChannelAddContactIos();

  static AddContactIosPlatform get instance => _instance;

  static set instance(AddContactIosPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<ContactOperationResult> addContact(Contact contact) {
    throw UnimplementedError('addContact() has not been implemented.');
  }

  Future<ContactOperationResult> openVCard(Contact contact) {
    throw UnimplementedError('openVCard() has not been implemented.');
  }
}
