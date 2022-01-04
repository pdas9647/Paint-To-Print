import 'package:shared_preferences/shared_preferences.dart';

class FirstTimeOpen {
  static const FIRST_TIME_OPEN = 'FIRST_TIME_OPEN';

  setFirstTimeOpenValue(bool value) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setBool(FIRST_TIME_OPEN, value);
  }

  Future<bool> getFirstTimeOpenValue() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getBool(FIRST_TIME_OPEN) ?? true;
  }
}
