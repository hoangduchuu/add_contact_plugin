import 'package:add_contact_ios/contact_model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'add_contact_ios_platform_interface.dart';

/// An implementation of [AddContactIosPlatform] that uses method channels.
class MethodChannelAddContactIos extends AddContactIosPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('add_contact_ios');

  @override
  Future<bool> addContact(Contact contact) async {
    return await methodChannel.invokeMethod<bool>('addContact', {'contact': contact.toMap()}) ?? false;
  }
}
