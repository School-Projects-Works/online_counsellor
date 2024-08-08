// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

class AppointmentModel {
  String id;
  String userId;
  List<String> ids;
  String counsellorId;
  int date;
  int time;
  String status;
  String counsellorName;
  String counsellorImage;
  String counsellorType;
  String userImage;
  String userName;
  bool counsellorState;
  bool userState;
  int createdAt;
  AppointmentModel({
    required this.id,
    required this.userId,
    required this.ids,
    required this.counsellorId,
    required this.date,
    required this.time,
    required this.status,
    required this.counsellorName,
    required this.counsellorImage,
    required this.counsellorType,
    required this.userImage,
    required this.userName,
    required this.counsellorState,
    required this.userState,
    required this.createdAt,
  });
  
  static AppointmentModel defualt(){
    return AppointmentModel(
      id: '',
      userId: '',
      ids: [],
      counsellorId: '',
      date: 0,
      time: 0,
      status: '',
      counsellorName: '',
      counsellorImage: '',
      counsellorType: '',
      userImage: '',
      userName: '',
      counsellorState: false,
      userState: false,
      createdAt: 0,
    );
  }
  AppointmentModel copyWith({
    String? id,
    String? userId,
    List<String>? ids,
    String? counsellorId,
    int? date,
    int? time,
    String? status,
    String? counsellorName,
    String? counsellorImage,
    String? counsellorType,
    String? userImage,
    String? userName,
    bool? counsellorState,
    bool? userState,
    int? createdAt,
  }) {
    return AppointmentModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      ids: ids ?? this.ids,
      counsellorId: counsellorId ?? this.counsellorId,
      date: date ?? this.date,
      time: time ?? this.time,
      status: status ?? this.status,
      counsellorName: counsellorName ?? this.counsellorName,
      counsellorImage: counsellorImage ?? this.counsellorImage,
      counsellorType: counsellorType ?? this.counsellorType,
      userImage: userImage ?? this.userImage,
      userName: userName ?? this.userName,
      counsellorState: counsellorState ?? this.counsellorState,
      userState: userState ?? this.userState,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};
  
    result.addAll({'id': id});
    result.addAll({'userId': userId});
    result.addAll({'ids': ids});
    result.addAll({'counsellorId': counsellorId});
    result.addAll({'date': date});
    result.addAll({'time': time});
    result.addAll({'status': status});
    result.addAll({'counsellorName': counsellorName});
    result.addAll({'counsellorImage': counsellorImage});
    result.addAll({'counsellorType': counsellorType});
    result.addAll({'userImage': userImage});
    result.addAll({'userName': userName});
    result.addAll({'counsellorState': counsellorState});
    result.addAll({'userState': userState});
    result.addAll({'createdAt': createdAt});
  
    return result;
  }

  factory AppointmentModel.fromMap(Map<String, dynamic> map) {
    return AppointmentModel(
      id: map['id'] ?? '',
      userId: map['userId'] ?? '',
      ids: List<String>.from(map['ids']),
      counsellorId: map['counsellorId'] ?? '',
      date: map['date']?.toInt() ?? 0,
      time: map['time']?.toInt() ?? 0,
      status: map['status'] ?? '',
      counsellorName: map['counsellorName'] ?? '',
      counsellorImage: map['counsellorImage'] ?? '',
      counsellorType: map['counsellorType'] ?? '',
      userImage: map['userImage'] ?? '',
      userName: map['userName'] ?? '',
      counsellorState: map['counsellorState'] ?? false,
      userState: map['userState'] ?? false,
      createdAt: map['createdAt']?.toInt() ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory AppointmentModel.fromJson(String source) => AppointmentModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'AppointmentModel(id: $id, userId: $userId, ids: $ids, counsellorId: $counsellorId, date: $date, time: $time, status: $status, counsellorName: $counsellorName, counsellorImage: $counsellorImage, counsellorType: $counsellorType, userImage: $userImage, userName: $userName, counsellorState: $counsellorState, userState: $userState, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is AppointmentModel &&
      other.id == id &&
      other.userId == userId &&
      listEquals(other.ids, ids) &&
      other.counsellorId == counsellorId &&
      other.date == date &&
      other.time == time &&
      other.status == status &&
      other.counsellorName == counsellorName &&
      other.counsellorImage == counsellorImage &&
      other.counsellorType == counsellorType &&
      other.userImage == userImage &&
      other.userName == userName &&
      other.counsellorState == counsellorState &&
      other.userState == userState &&
      other.createdAt == createdAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        userId.hashCode ^
        ids.hashCode ^
        counsellorId.hashCode ^
        date.hashCode ^
        time.hashCode ^
        status.hashCode ^
        counsellorName.hashCode ^
        counsellorImage.hashCode ^
        counsellorType.hashCode ^
        userImage.hashCode ^
        userName.hashCode ^
        counsellorState.hashCode ^
        userState.hashCode ^
        createdAt.hashCode;
  }

  Map<String, dynamic> rescheduleMap() {
    return <String, dynamic>{
      'date': date,
      'time': time,
      'status': 'Pending',
    };
  }
}
