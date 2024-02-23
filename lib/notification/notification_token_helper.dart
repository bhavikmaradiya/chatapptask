import 'dart:async';

import 'package:chatapp/config/firestore_config.dart';
import 'package:chatapp/config/preference_config.dart';
import 'package:chatapp/views/auth/model/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationTokenHelper {
  static String? _fcmToken = '';

  static Future<void> uploadFcmToken() async {
    final fcmToken = await FirebaseMessaging.instance.getToken();
    if (fcmToken != null) {
      unawaited(
        _updateFcmTokenToFirebase(
          oldToken: _fcmToken,
          newToken: fcmToken,
        ),
      );
    }
  }

  static void observeNotificationChange() {
    FirebaseMessaging.instance.onTokenRefresh.listen((token) async {
      unawaited(
        _updateFcmTokenToFirebase(
          oldToken: _fcmToken,
          newToken: token,
        ),
      );
    });
  }

  static Future<void> _updateFcmTokenToFirebase({
    required String newToken,
    String? oldToken,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final firebaseUserId = prefs.getString(PreferenceConfig.userIdPref);
    if (firebaseUserId != null) {
      final profileInfo = await _fetchProfileInfoFromFirebase(firebaseUserId);
      if (profileInfo != null) {
        unawaited(_updateFcmToken(
          profileInfo,
          oldToken: oldToken,
          newToken: newToken,
        ));
      }
    }
  }

  static Future<User?> _fetchProfileInfoFromFirebase(
    String firebaseUserId,
  ) async {
    final user = await FirebaseFirestore.instance
        .collection(FireStoreConfig.userCollection)
        .doc(firebaseUserId)
        .get();
    User? profileInfo;
    try {
      profileInfo = User.fromSnapshot(user);
    } on Exception catch (_) {}
    return profileInfo;
  }

  static Future<void> removeTokenOnLogout(String? firebaseUserId) async {
    if (firebaseUserId != null && _fcmToken?.trim().isNotEmpty == true) {
      await FirebaseFirestore.instance
          .collection(FireStoreConfig.userCollection)
          .doc(firebaseUserId)
          .update({
        FireStoreConfig.userFcmTokenField: FieldValue.arrayRemove([_fcmToken]),
      });
    }
  }

  static Future<void> _updateFcmToken(
    User profileInfo, {
    required String newToken,
    String? oldToken,
  }) async {
    final data = <String, dynamic>{};
    var tokens = profileInfo.fcmTokens;
    tokens ??= [];
    if (oldToken != null &&
        oldToken.trim().isNotEmpty &&
        tokens.contains(oldToken)) {
      tokens.remove(oldToken);
    }
    if (!tokens.contains(newToken)) {
      tokens.add(newToken);
      data[FireStoreConfig.userFcmTokenField] = tokens;
      data[FireStoreConfig.updatedAtField] =
          DateTime.now().millisecondsSinceEpoch;
      await FirebaseFirestore.instance
          .collection(FireStoreConfig.userCollection)
          .doc(profileInfo.userId)
          .update(data);
    }
    _fcmToken = newToken;
  }
}
