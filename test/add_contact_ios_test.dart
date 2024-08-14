import 'package:add_contact_ios/contact_model.dart';
import 'package:add_contact_ios/enum.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:add_contact_ios/add_contact_ios.dart';
import 'package:add_contact_ios/add_contact_ios_platform_interface.dart';
import 'package:add_contact_ios/add_contact_ios_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockAddContactIosPlatform
    with MockPlatformInterfaceMixin
    implements AddContactIosPlatform {
  @override
  Future<ContactOperationResult> addContact(Contact contact) {
    return Future.value(ContactOperationResult.saved);
  }

  @override
  Future<ContactOperationResult> openVCard(Contact vCardData) {
    // TODO: implement openVCard
    throw UnimplementedError();
  }
}

void main() {
  final AddContactIosPlatform initialPlatform = AddContactIosPlatform.instance;

  test('$MethodChannelAddContactIos is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelAddContactIos>());
  });

  test('addContact', () async {
    AddContactIos addContactIosPlugin = AddContactIos();
    MockAddContactIosPlatform fakePlatform = MockAddContactIosPlatform();
    AddContactIosPlatform.instance = fakePlatform;
    expect(await addContactIosPlugin.addContact(contact: Contact()),
        ContactOperationResult.saved);
  });
}
