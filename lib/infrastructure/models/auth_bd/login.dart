class AuthLoginMdl {
  final String id;
  final String provider;
  final String email;
  final String fullName;
  final String token;

  AuthLoginMdl({
    required this.id,
    required this.provider,
    required this.email,
    required this.fullName,
    required this.token,
  });

  factory AuthLoginMdl.fromJson(Map<String, dynamic> json) => AuthLoginMdl(
    id: json["id"],
    provider: json["provider"],
    email: json["email"],
    fullName: json["fullName"],
    token: json["token"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "provider": provider,
    "email": email,
    "fullName": fullName,
    "token": token,
  };
}
