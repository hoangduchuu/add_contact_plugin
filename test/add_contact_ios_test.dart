import 'package:flutter_test/flutter_test.dart';
import 'package:add_contact_ios/add_contact_ios.dart';
import 'package:add_contact_ios/add_contact_ios_platform_interface.dart';
import 'package:add_contact_ios/add_contact_ios_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockAddContactIosPlatform
    with MockPlatformInterfaceMixin
    implements AddContactIosPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final AddContactIosPlatform initialPlatform = AddContactIosPlatform.instance;

  test('$MethodChannelAddContactIos is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelAddContactIos>());
  });

  test('getPlatformVersion', () async {
    AddContactIos addContactIosPlugin = AddContactIos();
    MockAddContactIosPlatform fakePlatform = MockAddContactIosPlatform();
    AddContactIosPlatform.instance = fakePlatform;

    expect(await addContactIosPlugin.getPlatformVersion(), '42');
  });
}
