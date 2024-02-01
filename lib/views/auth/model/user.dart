import 'package:chatapp/config/firestore_config.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  String? userId;
  String? name;
  String? email;
  String? photo;
  List<String>? fcmTokens;
  int? createdAt;
  int? updatedAt;

  User({
    this.userId,
    this.name,
    this.photo,
    this.email,
    this.fcmTokens,
    this.createdAt,
    this.updatedAt,
  });

  factory User.fromSnapshot(DocumentSnapshot document) {
    final data = document.data();
    if (data == null || data is! Map<String, dynamic>) {
      throw Exception();
    }
    final fcmToken = <String>[];
    final tokens = data[FireStoreConfig.userFcmTokenField];
    if (tokens != null && tokens is List<dynamic>) {
      for (var i = 0; i < tokens.length; i++) {
        final tokenId = tokens[i];
        if (tokenId != null &&
            tokenId is String &&
            !fcmToken.contains(tokenId)) {
          fcmToken.add(tokens[i] as String);
        }
      }
    }

    return User(
      userId: data[FireStoreConfig.userIdField] as String?,
      name: data[FireStoreConfig.userNameField] as String?,
      email: data[FireStoreConfig.userEmailField] as String?,
      photo: data[FireStoreConfig.userPhotoField] as String?,
      fcmTokens: fcmToken,
      createdAt: data[FireStoreConfig.createdAtField] as int?,
      updatedAt: data[FireStoreConfig.updatedAtField] as int?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      FireStoreConfig.userIdField: userId,
      FireStoreConfig.userNameField: name,
      FireStoreConfig.userEmailField: email,
      FireStoreConfig.userPhotoField: photo,
      FireStoreConfig.userFcmTokenField: fcmTokens,
      FireStoreConfig.createdAtField: createdAt,
      FireStoreConfig.updatedAtField: updatedAt,
    };
  }
}
