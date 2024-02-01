import 'package:chatapp/config/firestore_config.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Room {
  String? roomId;
  String? roomName;
  String? roomType;
  String? roomImage;
  List<Member>? members;
  int? createdAt;
  int? updatedAt;

  Room({
    this.roomId,
    this.roomName,
    this.roomType,
    this.roomImage,
    this.members,
    this.createdAt,
    this.updatedAt,
  });

  factory Room.fromSnapshot(DocumentSnapshot document) {
    final data = document.data();
    if (data == null || data is! Map<String, dynamic>) {
      throw Exception();
    }
    final roomMembers = <Member>[];
    final membersList = data[FireStoreConfig.roomMembersField];
    if (membersList != null &&
        membersList is List<dynamic> &&
        membersList.isNotEmpty) {
      for (var i = 0; i < membersList.length; i++) {
        final memberData = membersList[i];
        if (memberData != null &&
            memberData is Map<String, dynamic> &&
            memberData.isNotEmpty) {
          final member = Member.fromMap(memberData);
          if (member.memberId != null && !roomMembers.contains(member)) {
            roomMembers.add(member);
          }
        }
      }
    }

    return Room(
      roomId: data[FireStoreConfig.roomIdField] as String?,
      roomName: data[FireStoreConfig.roomNameField] as String?,
      roomImage: data[FireStoreConfig.roomImageField] as String?,
      roomType: data[FireStoreConfig.roomTypeField] as String?,
      members: roomMembers,
      createdAt: data[FireStoreConfig.createdAtField] as int?,
      updatedAt: data[FireStoreConfig.updatedAtField] as int?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      FireStoreConfig.roomIdField: roomId,
      FireStoreConfig.roomNameField: roomName,
      FireStoreConfig.roomImageField: roomImage,
      FireStoreConfig.roomTypeField: roomType,
      FireStoreConfig.roomMembersField: members?.map((e) => e.toMap()).toList(),
      FireStoreConfig.createdAtField: createdAt,
      FireStoreConfig.updatedAtField: updatedAt,
    };
  }
}

class Member {
  String? memberId;
  String? status;
  bool? isAdmin;
  int? joinedAt;
  int? updatedAt;

  Member({
    this.memberId,
    this.status,
    this.isAdmin,
    this.joinedAt,
    this.updatedAt,
  });

  factory Member.fromMap(Map<String, dynamic> data) {
    return Member(
      memberId: data[FireStoreConfig.memberIdField] as String?,
      status: data[FireStoreConfig.memberStatusField] as String?,
      isAdmin: data[FireStoreConfig.memberAdminField] as bool?,
      joinedAt: data[FireStoreConfig.memberJoinedAtField] as int?,
      updatedAt: data[FireStoreConfig.updatedAtField] as int?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      FireStoreConfig.memberIdField: memberId,
      FireStoreConfig.memberStatusField: status,
      FireStoreConfig.memberAdminField: isAdmin,
      FireStoreConfig.memberJoinedAtField: joinedAt,
      FireStoreConfig.updatedAtField: updatedAt,
    };
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Member &&
          runtimeType == other.runtimeType &&
          memberId == other.memberId;

  @override
  int get hashCode => memberId.hashCode;
}
