// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class SessionModel {
  String? id;
  String? userId;
  String? counsellorId;
  String? counsellorName;
  String? counsellorImage;
  String? userName;
  String? userImage;
  int? createdAt;
  SessionModel({
    this.id,
    this.userId,
    this.counsellorId,
    this.counsellorName,
    this.counsellorImage,
    this.userName,
    this.userImage,
    this.createdAt,
  });

  SessionModel copyWith({
    String? id,
    String? userId,
    String? counsellorId,
    String? counsellorName,
    String? counsellorImage,
    String? userName,
    String? userImage,
    int? createdAt,
  }) {
    return SessionModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      counsellorId: counsellorId ?? this.counsellorId,
      counsellorName: counsellorName ?? this.counsellorName,
      counsellorImage: counsellorImage ?? this.counsellorImage,
      userName: userName ?? this.userName,
      userImage: userImage ?? this.userImage,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'userId': userId,
      'counsellorId': counsellorId,
      'counsellorName': counsellorName,
      'counsellorImage': counsellorImage,
      'userName': userName,
      'userImage': userImage,
      'createdAt': createdAt,
    };
  }

  factory SessionModel.fromMap(Map<String, dynamic> map) {
    return SessionModel(
      id: map['id'] != null ? map['id'] as String : null,
      userId: map['userId'] != null ? map['userId'] as String : null,
      counsellorId:
          map['counsellorId'] != null ? map['counsellorId'] as String : null,
      counsellorName: map['counsellorName'] != null
          ? map['counsellorName'] as String
          : null,
      counsellorImage: map['counsellorImage'] != null
          ? map['counsellorImage'] as String
          : null,
      userName: map['userName'] != null ? map['userName'] as String : null,
      userImage: map['userImage'] != null ? map['userImage'] as String : null,
      createdAt: map['createdAt'] != null ? map['createdAt'] as int : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory SessionModel.fromJson(String source) =>
      SessionModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'SessionModel(id: $id, userId: $userId, counsellorId: $counsellorId, counsellorName: $counsellorName, counsellorImage: $counsellorImage, userName: $userName, userImage: $userImage, createdAt: $createdAt)';
  }

  @override
  bool operator ==(covariant SessionModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.userId == userId &&
        other.counsellorId == counsellorId &&
        other.counsellorName == counsellorName &&
        other.counsellorImage == counsellorImage &&
        other.userName == userName &&
        other.userImage == userImage &&
        other.createdAt == createdAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        userId.hashCode ^
        counsellorId.hashCode ^
        counsellorName.hashCode ^
        counsellorImage.hashCode ^
        userName.hashCode ^
        userImage.hashCode ^
        createdAt.hashCode;
  }
}
