class UserModel {
  String uid;
  String name;
  String email;
  String imageUrl;
  String provider;

  UserModel({
    required this.uid,
    required this.name,
    required this.email,
    required this.imageUrl,
    required this.provider,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        uid: json['uid'],
        name: json['name'],
        email: json['email'],
        imageUrl: json['image_url'],
        provider: json['provider'],
      );

 
}
