import 'package:add_contact_ios/contact_model.dart';
import 'package:add_contact_ios/enum.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'add_contact_ios_platform_interface.dart';

class MethodChannelAddContactIos extends AddContactIosPlatform {
  @visibleForTesting
  final methodChannel = const MethodChannel('add_contact_ios');

  @override
  Future<ContactOperationResult> addContact(Contact contact) async {
    final result = await methodChannel
        .invokeMethod<String>('addContact', {'contact': contact.toMap()});
    return _parseResult(result);
  }

  @override
  Future<ContactOperationResult> openVCard(Contact contact) async {
    final result = await methodChannel
        .invokeMethod<String>('openVCard', {'vCard': contact.toMap()});
    return _parseResult(result);
  }

  ContactOperationResult _parseResult(String? result) {
    switch (result) {
      case 'saved':
        return ContactOperationResult.saved;
      case 'cancelled':
        return ContactOperationResult.cancelled;
      default:
        return ContactOperationResult.error;
    }
  }
}
