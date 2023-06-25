// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'dart:convert';

class UserModel {
  String? id;
  String? email;
  String? password;
  String? name;
  String? profile;
  String? phone;
  String? address;
  String? city;
  String? region;
  bool? isOnline;
  String? about;
  String? gender;
  String? userType;
  String? maritalStatus;
  String? employmentStatus;
  String? educationLevel;
  String? counsellorType;
  String? religion;
  String? dob;
  int? createdAt;
  UserModel({
    this.id,
    this.email,
    this.password,
    this.name,
    this.profile,
    this.phone,
    this.address,
    this.city,
    this.region,
    this.isOnline,
    this.about,
    this.gender,
    this.userType,
    this.maritalStatus,
    this.employmentStatus,
    this.educationLevel,
    this.counsellorType,
    this.religion,
    this.dob,
    this.createdAt,
  });

  UserModel copyWith({
    String? id,
    String? email,
    String? password,
    String? name,
    String? profile,
    String? phone,
    String? address,
    String? city,
    String? region,
    bool? isOnline,
    String? about,
    String? gender,
    String? userType,
    String? maritalStatus,
    String? employmentStatus,
    String? educationLevel,
    String? counsellorType,
    String? religion,
    String? dob,
    int? createdAt,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      password: password ?? this.password,
      name: name ?? this.name,
      profile: profile ?? this.profile,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      city: city ?? this.city,
      region: region ?? this.region,
      isOnline: isOnline ?? this.isOnline,
      about: about ?? this.about,
      gender: gender ?? this.gender,
      userType: userType ?? this.userType,
      maritalStatus: maritalStatus ?? this.maritalStatus,
      employmentStatus: employmentStatus ?? this.employmentStatus,
      educationLevel: educationLevel ?? this.educationLevel,
      counsellorType: counsellorType ?? this.counsellorType,
      religion: religion ?? this.religion,
      dob: dob ?? this.dob,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'email': email,
      'password': password,
      'name': name,
      'profile': profile,
      'phone': phone,
      'address': address,
      'city': city,
      'region': region,
      'isOnline': isOnline,
      'about': about,
      'gender': gender,
      'userType': userType,
      'maritalStatus': maritalStatus,
      'employmentStatus': employmentStatus,
      'educationLevel': educationLevel,
      'counsellorType': counsellorType,
      'religion': religion,
      'dob': dob,
      'createdAt': createdAt,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] != null ? map['id'] as String : null,
      email: map['email'] != null ? map['email'] as String : null,
      password: map['password'] != null ? map['password'] as String : null,
      name: map['name'] != null ? map['name'] as String : null,
      profile: map['profile'] != null ? map['profile'] as String : null,
      phone: map['phone'] != null ? map['phone'] as String : null,
      address: map['address'] != null ? map['address'] as String : null,
      city: map['city'] != null ? map['city'] as String : null,
      region: map['region'] != null ? map['region'] as String : null,
      isOnline: map['isOnline'] != null ? map['isOnline'] as bool : null,
      about: map['about'] != null ? map['about'] as String : null,
      gender: map['gender'] != null ? map['gender'] as String : null,
      userType: map['userType'] != null ? map['userType'] as String : null,
      maritalStatus:
          map['maritalStatus'] != null ? map['maritalStatus'] as String : null,
      employmentStatus: map['employmentStatus'] != null
          ? map['employmentStatus'] as String
          : null,
      educationLevel: map['educationLevel'] != null
          ? map['educationLevel'] as String
          : null,
      counsellorType: map['counsellorType'] != null
          ? map['counsellorType'] as String
          : null,
      religion: map['religion'] != null ? map['religion'] as String : null,
      dob: map['dob'] != null ? map['dob'] as String : null,
      createdAt: map['createdAt'] != null ? map['createdAt'] as int : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'UserModel(id: $id, email: $email, password: $password, name: $name, profile: $profile, phone: $phone, address: $address, city: $city, region: $region, isOnline: $isOnline, about: $about, gender: $gender, userType: $userType, maritalStatus: $maritalStatus, employmentStatus: $employmentStatus, educationLevel: $educationLevel, counsellorType: $counsellorType, religion: $religion, dob: $dob, createdAt: $createdAt)';
  }

  @override
  bool operator ==(covariant UserModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.email == email &&
        other.password == password &&
        other.name == name &&
        other.profile == profile &&
        other.phone == phone &&
        other.address == address &&
        other.city == city &&
        other.region == region &&
        other.isOnline == isOnline &&
        other.about == about &&
        other.gender == gender &&
        other.userType == userType &&
        other.maritalStatus == maritalStatus &&
        other.employmentStatus == employmentStatus &&
        other.educationLevel == educationLevel &&
        other.counsellorType == counsellorType &&
        other.religion == religion &&
        other.dob == dob &&
        other.createdAt == createdAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        email.hashCode ^
        password.hashCode ^
        name.hashCode ^
        profile.hashCode ^
        phone.hashCode ^
        address.hashCode ^
        city.hashCode ^
        region.hashCode ^
        isOnline.hashCode ^
        about.hashCode ^
        gender.hashCode ^
        userType.hashCode ^
        maritalStatus.hashCode ^
        employmentStatus.hashCode ^
        educationLevel.hashCode ^
        counsellorType.hashCode ^
        religion.hashCode ^
        dob.hashCode ^
        createdAt.hashCode;
  }
}
