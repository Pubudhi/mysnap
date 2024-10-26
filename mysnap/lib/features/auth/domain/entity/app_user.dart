class AppUser {
  final String uid;
  final String email;
  final String name;

  AppUser({
    required this.uid, 
    required this.email, 
    required this.name
  });


  // app_user -> json
  Map<String, dynamic> toJason(){
    return {
      'uid': uid,
      'email': email,
      'name': name
    };
  }

  // json -> app_ser
  factory AppUser.fromJson(Map<String, dynamic> jsonUser){
    return AppUser(
      uid: jsonUser['uid'], 
      email: jsonUser['email'], 
      name: jsonUser['name']
    );
  }
}
