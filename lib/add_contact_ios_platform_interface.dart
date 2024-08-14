import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'add_contact_ios_method_channel.dart';

abstract class AddContactIosPlatform extends PlatformInterface {
  /// Constructs a AddContactIosPlatform.
  AddContactIosPlatform() : super(token: _token);

  static final Object _token = Object();

  static AddContactIosPlatform _instance = MethodChannelAddContactIos();

  /// The default instance of [AddContactIosPlatform] to use.
  ///
  /// Defaults to [MethodChannelAddContactIos].
  static AddContactIosPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [AddContactIosPlatform] when
  /// they register themselves.
  static set instance(AddContactIosPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
