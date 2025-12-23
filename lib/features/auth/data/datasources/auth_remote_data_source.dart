import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../domain/entities/user_profile.dart';

class AuthRemoteDataSource {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<UserProfile> signIn(String email, String password) async {
    final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    final user = userCredential.user;

    if (user == null) {
      throw Exception('User not found after sign in');
    }

    // Fetch extra data from Firestore
    final docSnapshot = await _firestore
        .collection('users')
        .doc(user.uid)
        .get();
    if (!docSnapshot.exists) {
      // Fallback if user exists in Auth but not in Firestore (legacy or error)
      // For now, return a basic profile or throw. Let's return basic.
      return UserProfile(
        uid: user.uid,
        email: user.email ?? '',
        name: 'Unknown',
        username: 'Unknown',
        birthDate: DateTime.now(),
      );
    }

    final data = docSnapshot.data()!;
    return UserProfile(
      uid: user.uid,
      email: user.email ?? '',
      name: data['name'] ?? '',
      username: data['username'] ?? '',
      birthDate: (data['birthDate'] as Timestamp).toDate(),
    );
  }

  Future<UserProfile> signUp({
    required String email,
    required String password,
    required String name,
    required String username,
    required DateTime birthDate,
  }) async {
    final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    final user = userCredential.user;

    if (user == null) {
      throw Exception('User creation failed');
    }

    // Save extra data to Firestore
    await _firestore.collection('users').doc(user.uid).set({
      'uid': user.uid,
      'email': email,
      'name': name,
      'username': username,
      'birthDate': Timestamp.fromDate(birthDate),
      'createdAt': FieldValue.serverTimestamp(),
    });

    return UserProfile(
      uid: user.uid,
      email: email,
      name: name,
      username: username,
      birthDate: birthDate,
    );
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }
}
