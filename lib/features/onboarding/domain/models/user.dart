import 'package:cloud_firestore/cloud_firestore.dart';

class AppUser {
  final String uid;
  final String email;
  final String? name;
  final String? photoUrl;

  final List<String> interests;
  final String? country;

  final bool completedProfile;
  final DateTime createdAt;

  AppUser({
    required this.uid,
    required this.email,
    required this.name,
    required this.photoUrl,
    this.interests = const [],
    this.country,
    this.completedProfile = false,
    required this.createdAt,
  });


  factory AppUser.fromJson(Map<String, dynamic> json) {
    return AppUser(
      uid: json["uid"],
      email: json["email"],
      name: json["name"],
      photoUrl: json["photoUrl"],
      interests: List<String>.from(json["interests"] ?? []),
      country: json["country"],
      completedProfile: json["completedProfile"] ?? false,
      createdAt: (json["createdAt"] as Timestamp).toDate(),
    );
  }


  Map<String, dynamic> toJson() {
    return {
      "uid": uid,
      "email": email,
      "name": name,
      "photoUrl": photoUrl,
      "interests": interests,
      "country": country,
      "completedProfile": completedProfile,
      "createdAt": createdAt,
    };
  }


  AppUser copyWith({
    String? name,
    String? photoUrl,
    List<String>? interests,
    String? country,
    bool? completedProfile,
  }) {
    return AppUser(
      uid: uid,
      email: email,
      name: name ?? this.name,
      photoUrl: photoUrl ?? this.photoUrl,
      interests: interests ?? this.interests,
      country: country ?? this.country,
      completedProfile: completedProfile ?? this.completedProfile,
      createdAt: createdAt,
    );
  }
}
