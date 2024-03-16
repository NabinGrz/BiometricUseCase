import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';

class LocalAuthUseCase {
  final LocalAuthentication auth;
  LocalAuthUseCase({required this.auth}) {
    getAllBiometrics();
  }

  List<BiometricType> allBiometrics = [];
  Future<bool> get canCheckBiometric async => await auth.canCheckBiometrics;
  Future<bool> get isDeviceSupported async => await auth.isDeviceSupported();

  Future<void> getAllBiometrics() async {
    allBiometrics = await auth.getAvailableBiometrics();
    print("ALL BIOMETRICS: $allBiometrics");
  }

  Future<void> authenticate(
      {required Function() onAuthenticated,
      required Function() onAuthenticationFailed,
      required String localizedReason}) async {
    try {
      if (await canCheckBiometric && await isDeviceSupported) {
        final authenticated = await auth.authenticate(
          localizedReason: localizedReason,
          options: const AuthenticationOptions(
            stickyAuth: true,
            biometricOnly: true,
          ),
        );
        if (authenticated) {
          onAuthenticated();
        } else {
          onAuthenticationFailed();
        }
      }
    } on PlatformException catch (e) {
      print("PlatformException: ${e.message}");
    }
  }
}
