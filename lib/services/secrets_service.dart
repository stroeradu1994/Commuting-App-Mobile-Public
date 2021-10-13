import 'package:firebase_remote_config/firebase_remote_config.dart';

class SecretsService {
  String? googleKeySecret;

  SecretsService() {
    retrieveSecrets();
  }

  void retrieveSecrets() async {
    await retrieveGoogleKey();
  }

  Future<void> retrieveGoogleKey() async {
    RemoteConfig remoteConfig = await RemoteConfig.instance;
    await remoteConfig.setConfigSettings(RemoteConfigSettings(
      fetchTimeout: const Duration(seconds: 10),
      minimumFetchInterval: const Duration(hours: 1),
    ));

    await remoteConfig.fetchAndActivate();
    googleKeySecret = remoteConfig.getValue('GOOGLE_KEY').asString();
  }
}
