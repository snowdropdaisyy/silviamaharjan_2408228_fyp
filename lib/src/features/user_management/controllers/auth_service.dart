import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_database/firebase_database.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final DatabaseReference _db = FirebaseDatabase.instance.ref();

  // --- 1. EMAIL SIGN UP (Always goes to Onboarding) ---
  Future<void> signUpWithEmail({required String email, required String password}) async {
    try {
      // Create account
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password
      );

      // Save initial profile
      if (result.user != null) {
        await _db.child('users/${result.user!.uid}/profile').set({
          'email': email,
          'provider': 'email',
          'onboardingComplete': false, // Mark as incomplete
        });
      }
    } on FirebaseAuthException catch (e) {
      throw Exception(_mapError(e.code));
    }
  }

  // --- 2. EMAIL LOGIN (Checks if registered) ---
  Future<void> loginWithEmail({required String email, required String password}) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);

      // Check if this user actually has a profile in our DB
      final user = _auth.currentUser;
      final snapshot = await _db.child('users/${user?.uid}/profile').get();

      if (!snapshot.exists) {
        await _auth.signOut(); // Kick them out if no record exists
        throw Exception("This email is not registered. Please sign up first.");
      }
    } on FirebaseAuthException catch (e) {
      throw Exception(_mapError(e.code));
    }
  }

  // --- 3. GOOGLE SIGN UP (Forces Onboarding / Checks if exists) ---
  Future<void> signUpWithGoogle() async {
    try {
      final googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) return;

      final googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      UserCredential userCredential = await _auth.signInWithCredential(credential);
      final user = userCredential.user;

      // CHECK: Does this Google user already exist in our DB?
      final snapshot = await _db.child('users/${user?.uid}/profile').get();

      if (snapshot.exists) {
        // User already has an account, they should be logging in, not signing up
        await _auth.signOut();
        await GoogleSignIn().signOut();
        throw Exception("This Google account is already registered. Please Login instead.");
      }

      // New user: Save profile and they will proceed to onboarding
      await _db.child('users/${user?.uid}/profile').set({
        'email': user?.email,
        'name': user?.displayName,
        'provider': 'google',
        'onboardingComplete': false,
      });

    } catch (e) {
      throw Exception(e.toString());
    }
  }

  // --- 4. GOOGLE LOGIN (Checks if registered) ---
  Future<void> loginWithGoogle() async {
    try {
      final googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) return;

      final googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      UserCredential userCredential = await _auth.signInWithCredential(credential);
      final user = userCredential.user;

      // CHECK: Does this user exist in our DB?
      final snapshot = await _db.child('users/${user?.uid}/profile').get();

      if (!snapshot.exists) {
        // Not registered: Sign them out and show error
        await _auth.signOut();
        await GoogleSignIn().signOut();
        throw Exception("No account found with this Google email. Please Sign Up first.");
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  // ================= HELPER LOGIC =================

  // Save survey data and mark onboarding as true
  Future<void> saveOnboardingData(Map<String, dynamic> data) async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return;

    await _db.child('users/$uid/onboarding').set(data);
    await _db.child('users/$uid/profile').update({'onboardingComplete': true});
  }

  // Check if onboarding is done
  Future<bool> isOnboardingDone() async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return false;

    final snapshot = await _db.child('users/$uid/profile/onboardingComplete').get();
    return snapshot.value == true;
  }

  String _mapError(String code) {
    switch (code) {
      case 'user-not-found':
        return 'No account found with this email';
      case 'wrong-password':
        return 'Incorrect password';
      case 'invalid-credential':
      case 'invalid-login-credentials':
        return 'Invalid email or password';
      case 'email-already-in-use':
        return 'Email already registered';
      case 'invalid-email':
        return 'Please enter a valid email address';
      case 'weak-password':
        return 'Password must be at least 6 characters';
      default:
        return 'Authentication failed. Please try again.';
    }
  }

}