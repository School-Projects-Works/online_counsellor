// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

class SessionMessagesModel {
  String? id;
  String? message;
  String? senderId;
  String? receiverId;
  String? senderName;
  String? receiverName;
  String? senderImage;
  String? receiverImage;
  String? sessionId;
  int? createdAt;
  bool? isRead;
  String? type;
  List<dynamic>? mediaFiles;
  SessionMessagesModel({
    this.id,
    this.message,
    this.senderId,
    this.receiverId,
    this.senderName,
    this.receiverName,
    this.senderImage,
    this.receiverImage,
    this.sessionId,
    this.createdAt,
    this.isRead,
    this.type,
    this.mediaFiles,
  });

  SessionMessagesModel copyWith({
    String? id,
    String? message,
    String? senderId,
    String? receiverId,
    String? senderName,
    String? receiverName,
    String? senderImage,
    String? receiverImage,
    String? sessionId,
    int? createdAt,
    bool? isRead,
    String? type,
    List<dynamic>? mediaFiles,
  }) {
    return SessionMessagesModel(
      id: id ?? this.id,
      message: message ?? this.message,
      senderId: senderId ?? this.senderId,
      receiverId: receiverId ?? this.receiverId,
      senderName: senderName ?? this.senderName,
      receiverName: receiverName ?? this.receiverName,
      senderImage: senderImage ?? this.senderImage,
      receiverImage: receiverImage ?? this.receiverImage,
      sessionId: sessionId ?? this.sessionId,
      createdAt: createdAt ?? this.createdAt,
      isRead: isRead ?? this.isRead,
      type: type ?? this.type,
      mediaFiles: mediaFiles ?? this.mediaFiles,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'message': message,
      'senderId': senderId,
      'receiverId': receiverId,
      'senderName': senderName,
      'receiverName': receiverName,
      'senderImage': senderImage,
      'receiverImage': receiverImage,
      'sessionId': sessionId,
      'createdAt': createdAt,
      'isRead': isRead,
      'type': type,
      'mediaFiles': mediaFiles,
    };
  }

  factory SessionMessagesModel.fromMap(Map<String, dynamic> map) {
    return SessionMessagesModel(
      id: map['id'] != null ? map['id'] as String : null,
      message: map['message'] != null ? map['message'] as String : null,
      senderId: map['senderId'] != null ? map['senderId'] as String : null,
      receiverId:
          map['receiverId'] != null ? map['receiverId'] as String : null,
      senderName:
          map['senderName'] != null ? map['senderName'] as String : null,
      receiverName:
          map['receiverName'] != null ? map['receiverName'] as String : null,
      senderImage:
          map['senderImage'] != null ? map['senderImage'] as String : null,
      receiverImage:
          map['receiverImage'] != null ? map['receiverImage'] as String : null,
      sessionId: map['sessionId'] != null ? map['sessionId'] as String : null,
      createdAt: map['createdAt'] != null ? map['createdAt'] as int : null,
      isRead: map['isRead'] != null ? map['isRead'] as bool : null,
      type: map['type'] != null ? map['type'] as String : null,
      mediaFiles: map['mediaFiles'] != null
          ? List<dynamic>.from((map['mediaFiles'] as List<dynamic>))
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory SessionMessagesModel.fromJson(String source) =>
      SessionMessagesModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'SessionMessagesModel(id: $id, message: $message, senderId: $senderId, receiverId: $receiverId, senderName: $senderName, receiverName: $receiverName, senderImage: $senderImage, receiverImage: $receiverImage, sessionId: $sessionId, createdAt: $createdAt, isRead: $isRead, type: $type, mediaFiles: $mediaFiles)';
  }

  @override
  bool operator ==(covariant SessionMessagesModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.message == message &&
        other.senderId == senderId &&
        other.receiverId == receiverId &&
        other.senderName == senderName &&
        other.receiverName == receiverName &&
        other.senderImage == senderImage &&
        other.receiverImage == receiverImage &&
        other.sessionId == sessionId &&
        other.createdAt == createdAt &&
        other.isRead == isRead &&
        other.type == type &&
        listEquals(other.mediaFiles, mediaFiles);
  }

  @override
  int get hashCode {
    return id.hashCode ^
        message.hashCode ^
        senderId.hashCode ^
        receiverId.hashCode ^
        senderName.hashCode ^
        receiverName.hashCode ^
        senderImage.hashCode ^
        receiverImage.hashCode ^
        sessionId.hashCode ^
        createdAt.hashCode ^
        isRead.hashCode ^
        type.hashCode ^
        mediaFiles.hashCode;
  }
}
