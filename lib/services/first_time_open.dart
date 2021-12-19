import 'package:shared_preferences/shared_preferences.dart';

class FirstTimeOpen {
  static const FIRST_TIME_OPEN = 'FIRST_TIME_OPEN';

  setFirstTimeOpenValue(bool value) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setBool(FIRST_TIME_OPEN, value);
    print('9. FIRST_TIME_OPEN is set to: $value');
  }

  Future<bool> getFirstTimeOpenValue() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    print('14. FIRST_TIME_OPEN: ${sharedPreferences.getBool(FIRST_TIME_OPEN)}');
    return sharedPreferences.getBool(FIRST_TIME_OPEN) ?? true;
  }
}
