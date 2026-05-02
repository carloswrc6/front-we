class AuthRegisterMdl {
  final String email;
  final String fullName;
  final dynamic appleId;
  final String id;
  final String provider;
  final bool isActive;
  final List<String> roles;
  final String token;

  AuthRegisterMdl({
    required this.email,
    required this.fullName,
    required this.appleId,
    required this.id,
    required this.provider,
    required this.isActive,
    required this.roles,
    required this.token,
  });

  factory AuthRegisterMdl.fromJson(Map<String, dynamic> json) =>
      AuthRegisterMdl(
        email: json["email"],
        fullName: json["fullName"],
        appleId: json["appleId"],
        id: json["id"],
        provider: json["provider"],
        isActive: json["isActive"],
        roles: List<String>.from(json["roles"].map((x) => x)),
        token: json["token"],
      );

  Map<String, dynamic> toJson() => {
    "email": email,
    "fullName": fullName,
    "appleId": appleId,
    "id": id,
    "provider": provider,
    "isActive": isActive,
    "roles": List<dynamic>.from(roles.map((x) => x)),
    "token": token,
  };
}
