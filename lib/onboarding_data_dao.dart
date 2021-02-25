import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';

const String _defaultBoxName = 'onboarding_data_box';

class OnboardingDataDao {
  static OnboardingDataDao _instance;

  Box<bool> _onboardingDataBox;

  OnboardingDataDao._();
  factory OnboardingDataDao() => _instance ??= OnboardingDataDao._();

  Future<void> init({Box<bool> customBox}) async {
    assert(
      _instance._onboardingDataBox == null,
      'repeated init of onboarding data box',
    );

    _instance._onboardingDataBox =
        customBox ?? await Hive.openBox(_defaultBoxName);
  }

  bool getStep({@required int step}) {
    return _onboardingDataBox.get(step, defaultValue: false);
  }

  Future<void> setStep({@required int step, bool value = true}) async {
    await _onboardingDataBox.put(step, value);
  }

  Map<int, bool> getFlagsMap() {
    return Map<int, bool>.from(_onboardingDataBox.toMap());
  }

  Future<void> setFlagsMap(Map<int, bool> map) async {
    await _onboardingDataBox.putAll(map);
  }
}
