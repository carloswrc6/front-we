// Registro de usuario
class AuthRegisterInput {
  final String email;
  final String password;
  final String fullName;

  AuthRegisterInput({
    required this.email,
    required this.password,
    required this.fullName,
  });
}

class AuthRegisterOutput {
  final String email;
  final String fullName;
  final String id;
  final String token;
  final List<String> roles;

  AuthRegisterOutput({
    required this.email,
    required this.fullName,
    required this.id,
    required this.token,
    required this.roles,
  });
}

// Login local
class AuthLoginInput {
  final String email;
  final String password;
  AuthLoginInput({required this.email, required this.password});
}

class AuthLoginOutput {
  final String id;
  final String provider;
  final String email;
  final String token;
  AuthLoginOutput({
    required this.id,
    required this.provider,
    required this.email,
    required this.token,
  });
}

//  no implementado
class LoginGoogleApple {
  final String idToken;

  LoginGoogleApple({required this.idToken});
}
