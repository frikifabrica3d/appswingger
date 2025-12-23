import 'package:firebase_auth/firebase_auth.dart';
import '../../domain/entities/user_profile.dart';
import '../../domain/failures/auth_failure.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remoteDataSource;

  AuthRepositoryImpl({AuthRemoteDataSource? remoteDataSource})
    : _remoteDataSource = remoteDataSource ?? AuthRemoteDataSource();

  @override
  Future<UserProfile> signIn(String email, String password) async {
    try {
      return await _remoteDataSource.signIn(email, password);
    } on FirebaseAuthException catch (e) {
      throw _handleFirebaseAuthException(e);
    } catch (e) {
      throw AuthFailure('Ocurrió un error inesperado: $e');
    }
  }

  @override
  Future<UserProfile> signUp({
    required String email,
    required String password,
    required String name,
    required String username,
    required DateTime birthDate,
  }) async {
    try {
      return await _remoteDataSource.signUp(
        email: email,
        password: password,
        name: name,
        username: username,
        birthDate: birthDate,
      );
    } on FirebaseAuthException catch (e) {
      throw _handleFirebaseAuthException(e);
    } catch (e) {
      throw AuthFailure('Ocurrió un error inesperado al registrarse: $e');
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await _remoteDataSource.signOut();
    } catch (e) {
      throw AuthFailure('Error al cerrar sesión');
    }
  }

  AuthFailure _handleFirebaseAuthException(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return AuthFailure('No existe usuario con este email.');
      case 'wrong-password':
        return AuthFailure('Contraseña incorrecta.');
      case 'email-already-in-use':
        return AuthFailure('El email ya está registrado.');
      case 'invalid-email':
        return AuthFailure('El formato del email no es válido.');
      case 'weak-password':
        return AuthFailure('La contraseña es muy débil.');
      case 'network-request-failed':
        return AuthFailure('Error de conexión. Verifica tu internet.');
      default:
        return AuthFailure(e.message ?? 'Error de autenticación.');
    }
  }
}
