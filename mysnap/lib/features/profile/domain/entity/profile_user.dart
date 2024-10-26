import 'package:mysnap/features/auth/domain/entity/app_user.dart';

class ProfileUser extends AppUser {
  final String bio;
  final String profileImageUrl;
  final List<String> followers;
  final List<String> followings;

  ProfileUser({
    required super.uid,
    required super.email,
    required super.name,
    required this.bio,
    required this.profileImageUrl,
    required this.followers,
    required this.followings,
  });

  //method updte user
  ProfileUser copyWith({
    String? newBio,
    String? newProfileImageUrl,
    List<String>? newfollowers,
    List<String>? newfollowings,
  }) {
    return ProfileUser(
      uid: uid,
      email: email,
      name: name,
      bio: newBio ?? bio,
      profileImageUrl: newProfileImageUrl ?? profileImageUrl,
      followers: newfollowers ?? followers,
      followings: newfollowings ?? followings,
    );
  }

  //convert profile user -> json
  @override
  Map<String, dynamic> toJason() {
    return {
      'uid': uid,
      'email': email,
      'name': name,
      'bio': bio,
      'profileImageUrl': profileImageUrl,
      'followers': followers,
      'followings': followings,
    };
  }

  //convert json -> profile user
  factory ProfileUser.fromJson(Map<String, dynamic> jsonUser) {
    return ProfileUser(
      uid: jsonUser['uid'],
      email: jsonUser['email'],
      name: jsonUser['name'],
      bio: jsonUser['bio'] ?? '',
      profileImageUrl: jsonUser['profileImageUrl'] ?? '',
      followers: List<String>.from(jsonUser['followers'] ?? []),
      followings: List<String>.from(jsonUser['followings'] ?? []),
    );
  }
}
