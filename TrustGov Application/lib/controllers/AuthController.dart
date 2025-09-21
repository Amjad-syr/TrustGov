// ignore_for_file: file_names

import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthController extends GetxController {
  final RxnString _token = RxnString(null);

  String? get token => _token.value;

  Future<void> saveToken(String newToken) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', newToken);
    _token.value = newToken;
  }

  Future<void> loadToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    _token.value = prefs.getString('auth_token');
  }

  Future<void> removeToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
    _token.value = null;
  }
}
