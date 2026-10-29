import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Stores profile name + photo (base64) so they survive app restarts.
class ProfileStore extends ChangeNotifier {
  ProfileStore._();
  static final ProfileStore instance = ProfileStore._();

  String name = 'Sahal Muhammed';
  Uint8List? photo;

  Future<void> load() async {
    try {
      final p = await SharedPreferences.getInstance();
      name = p.getString('profile_name') ?? name;
      final b = p.getString('profile_photo');
      photo = b == null ? null : base64Decode(b);
    } catch (_) {}
    notifyListeners();
  }

  Future<void> setName(String v) async {
    name = v;
    notifyListeners();
    try {
      (await SharedPreferences.getInstance()).setString('profile_name', v);
    } catch (_) {}
  }

  Future<void> setPhoto(Uint8List? bytes) async {
    photo = bytes;
    notifyListeners();
    try {
      final p = await SharedPreferences.getInstance();
      bytes == null
          ? await p.remove('profile_photo')
          : await p.setString('profile_photo', base64Encode(bytes));
    } catch (_) {}
  }
}
