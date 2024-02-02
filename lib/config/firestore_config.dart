class FireStoreConfig {
  // user collection
  static const userCollection = 'users';
  static const userIdField = 'userId';
  static const userNameField = 'name';
  static const userEmailField = 'email';
  static const userPhotoField = 'photo';
  static const userRoleField = 'role';
  static const userFcmTokenField = 'fcmToken';

  //room collection
  static const roomCollection = 'rooms';
  static const roomIdField = 'roomId';
  static const roomNameField = 'name';
  static const roomTypeField = 'type';
  static const roomImageField = 'image';
  static const roomMembersField = 'members';
  static const roomMemberIdsField = 'memberIds';

  //member
  static const memberIdField = 'memberId';
  static const memberStatusField = 'status';
  static const memberAdminField = 'isAdmin';
  static const memberJoinedAtField = 'joinedAt';

  // General
  static const createdAtField = 'createdAt';
  static const updatedAtField = 'updatedAt';
}
