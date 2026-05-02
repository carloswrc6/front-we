class AuthLoginMdl {
  final String id;
  final String provider;
  final String email;
  final String token;

  AuthLoginMdl({
    required this.id,
    required this.provider,
    required this.email,
    required this.token,
  });

  factory AuthLoginMdl.fromJson(Map<String, dynamic> json) => AuthLoginMdl(
    id: json["id"],
    provider: json["provider"],
    email: json["email"],
    token: json["token"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "provider": provider,
    "email": email,
    "token": token,
  };
}
