// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

class SessionModel {
  String id;
  String userId;
  List<String> ids;
  String counsellorId;
  String counsellorName;
  String counsellorImage;
  String userName;
  String userImage;
  String status;
  int endedAt;
  int createdAt;
  String topic;
  SessionModel({
    required this.id,
    required this.userId,
    required this.ids,
    required this.counsellorId,
    required this.counsellorName,
    required this.counsellorImage,
    required this.userName,
    required this.userImage,
    required this.status,
    required this.endedAt,
    required this.createdAt,
    required this.topic,
  });
  
  static SessionModel defualt(){
    return SessionModel(
      id: '',
      userId: '',
      ids: [],
      counsellorId: '',
      counsellorName: '',
      counsellorImage: '',
      userName: '',
      userImage: '',
      status: '',
      endedAt: 0,
      createdAt: 0,
      topic: '',
    );
  }
  SessionModel copyWith({
    String? id,
    String? userId,
    List<String>? ids,
    String? counsellorId,
    String? counsellorName,
    String? counsellorImage,
    String? userName,
    String? userImage,
    String? status,
    int? endedAt,
    int? createdAt,
    String? topic,
  }) {
    return SessionModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      ids: ids ?? this.ids,
      counsellorId: counsellorId ?? this.counsellorId,
      counsellorName: counsellorName ?? this.counsellorName,
      counsellorImage: counsellorImage ?? this.counsellorImage,
      userName: userName ?? this.userName,
      userImage: userImage ?? this.userImage,
      status: status ?? this.status,
      endedAt: endedAt ?? this.endedAt,
      createdAt: createdAt ?? this.createdAt,
      topic: topic ?? this.topic,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};
  
    result.addAll({'id': id});
    result.addAll({'userId': userId});
    result.addAll({'ids': ids});
    result.addAll({'counsellorId': counsellorId});
    result.addAll({'counsellorName': counsellorName});
    result.addAll({'counsellorImage': counsellorImage});
    result.addAll({'userName': userName});
    result.addAll({'userImage': userImage});
    result.addAll({'status': status});
    result.addAll({'endedAt': endedAt});
    result.addAll({'createdAt': createdAt});
    result.addAll({'topic': topic});
  
    return result;
  }

  factory SessionModel.fromMap(Map<String, dynamic> map) {
    return SessionModel(
      id: map['id'] ?? '',
      userId: map['userId'] ?? '',
      ids: List<String>.from(map['ids']),
      counsellorId: map['counsellorId'] ?? '',
      counsellorName: map['counsellorName'] ?? '',
      counsellorImage: map['counsellorImage'] ?? '',
      userName: map['userName'] ?? '',
      userImage: map['userImage'] ?? '',
      status: map['status'] ?? '',
      endedAt: map['endedAt']?.toInt() ?? 0,
      createdAt: map['createdAt']?.toInt() ?? 0,
      topic: map['topic'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory SessionModel.fromJson(String source) => SessionModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'SessionModel(id: $id, userId: $userId, ids: $ids, counsellorId: $counsellorId, counsellorName: $counsellorName, counsellorImage: $counsellorImage, userName: $userName, userImage: $userImage, status: $status, endedAt: $endedAt, createdAt: $createdAt, topic: $topic)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is SessionModel &&
      other.id == id &&
      other.userId == userId &&
      listEquals(other.ids, ids) &&
      other.counsellorId == counsellorId &&
      other.counsellorName == counsellorName &&
      other.counsellorImage == counsellorImage &&
      other.userName == userName &&
      other.userImage == userImage &&
      other.status == status &&
      other.endedAt == endedAt &&
      other.createdAt == createdAt &&
      other.topic == topic;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        userId.hashCode ^
        ids.hashCode ^
        counsellorId.hashCode ^
        counsellorName.hashCode ^
        counsellorImage.hashCode ^
        userName.hashCode ^
        userImage.hashCode ^
        status.hashCode ^
        endedAt.hashCode ^
        createdAt.hashCode ^
        topic.hashCode;
  }
}
