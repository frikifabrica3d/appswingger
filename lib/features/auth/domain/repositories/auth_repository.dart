import '../entities/user_profile.dart';

abstract class AuthRepository {
  Future<UserProfile> signIn(String email, String password);
  Future<UserProfile> signUp({
    required String email,
    required String password,
    required String name,
    required String username,
    required DateTime birthDate,
  });
  Future<void> signOut();
}
