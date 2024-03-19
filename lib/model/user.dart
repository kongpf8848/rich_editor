class User {
  String avatar = "";
  String nickname = "";
  String uid = "";
  String letter = "";

  User.fromJson(Map<String, dynamic> jsonMap) {
    avatar = jsonMap["avatar"] ?? "";
    nickname = jsonMap["nickname"] ?? "";
    uid = jsonMap["uid"] ?? "";
    letter = jsonMap["letter"] ?? "";
  }

  @override
  bool operator ==(other) {
    if (identical(this, other)) {
      return true;
    }

    return other is User &&
        runtimeType == other.runtimeType &&
        uid == other.uid;
  }

  @override
  int get hashCode => uid.hashCode;
}
