import 'package:flutter/foundation.dart';

class ProfileSetupProvider with ChangeNotifier {
  bool _hasCompletedProfileSetup = true;

  bool get hasCompletedProfileSetup => _hasCompletedProfileSetup;

  void setProfileSetup(bool value) {
    _hasCompletedProfileSetup = value;
    notifyListeners();
  }
}
