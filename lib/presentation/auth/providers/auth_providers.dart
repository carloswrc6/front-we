import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontwe/presentation/auth/providers/auth_repository_provider.dart';
import 'package:frontwe/presentation/auth/state/auth_state.dart';
import 'package:frontwe/presentation/auth/providers/auth_notifier.dart';

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier(authRepository: ref.read(authRepositoryProvider));
});
