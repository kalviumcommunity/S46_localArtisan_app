import 'package:firebase_auth/firebase_auth.dart';
import 'firestore_service.dart';
import '../models/user_model.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirestoreService _firestoreService = FirestoreService();

  // Stream of auth changes
  Stream<User?> get userStream => _auth.authStateChanges();

  // Sign up with email and password
  Future<UserCredential> signUp({
    required String email,
    required String password,
    required String fullName,
    UserRole? role,
  }) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Create profile in Firestore only if role is provided
      if (result.user != null && role != null) {
        AppUser newUser = AppUser(
          uid: result.user!.uid,
          email: email,
          fullName: fullName,
          role: role,
          createdAt: DateTime.now(),
        );
        await _firestoreService.createUserProfile(newUser);
      } else if (result.user != null) {
        // Create a minimal profile with no role yet, 
        // to be updated in RoleSelectionScreen
        // Note: AppUser model requires a role currently, so we might need to 
        // either update the model or just let RoleSelectionScreen create it later.
        // For now, let's just NOT create the profile here if role is null.
        // AuthWrapper will see profiling is missing and show selection.
      }

      return result;
    } on FirebaseAuthException {
      rethrow;
    } catch (e) {
      rethrow;
    }
  }

  // Login with email and password
  Future<UserCredential> login(String email, String password) async {
    try {
      return await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException {
      rethrow;
    } catch (e) {
      rethrow;
    }
  }

  // Logout
  Future<void> logout() async {
    await _auth.signOut();
  }

  // Reset Password
  Future<void> resetPassword(String email) async {
    await _auth.sendPasswordResetEmail(email: email);
  }

  // Get current session
  User? get currentUser => _auth.currentUser;
}
