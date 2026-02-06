import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  // ================= GOOGLE SIGN IN / SIGN UP =================
  Future<User?> signInWithGoogle({required bool isSignUp}) async {
    try {
      // 1. Force the account picker to show every time
      await _googleSignIn.signOut();

      // 2. Trigger Google Sign-In popup
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return null; // User closed the popup

      // 3. Check Firestore for this email BEFORE doing anything with Firebase Auth
      final userQuery = await _firestore
          .collection('users')
          .where('email', isEqualTo: googleUser.email)
          .get();

      final bool userExists = userQuery.docs.isNotEmpty;

      // --- LOGIC GATE ---
      if (isSignUp) {
        // If signing up but email exists -> STOP
        if (userExists) {
          await _googleSignIn.signOut();
          throw Exception("This Google account is already registered. Please login.");
        }
      } else {
        // If logging in but email NOT found -> STOP (No auto-creation)
        if (!userExists) {
          await _googleSignIn.signOut();
          throw Exception("No account found with this Gmail. Please sign up first.");
        }
      }

      // 4. Only if the gate passes, get tokens and talk to Firebase Auth
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential result = await _auth.signInWithCredential(credential);
      final User? user = result.user;

      // 5. Create Firestore Document ONLY if it's a valid Sign Up
      if (isSignUp && user != null) {
        await _firestore.collection('users').doc(user.uid).set({
          'uid': user.uid,
          'email': user.email,
          'name': user.displayName,
          'onboardingComplete': false,
          'provider': 'google',
          'createdAt': FieldValue.serverTimestamp(),
        });
      }

      return user;
    } catch (e) {
      // Return clean error messages for your SnackBar
      throw Exception(e.toString().replaceAll("Exception: ", ""));
    }
  }

  // ================= EMAIL SIGN UP =================
  Future<User?> signUpWithEmail({required String email, required String password}) async {
    try {
      final existing = await _firestore.collection('users').where('email', isEqualTo: email).get();
      if (existing.docs.isNotEmpty) {
        throw Exception("An account with this email already exists.");
      }

      final result = await _auth.createUserWithEmailAndPassword(email: email, password: password);

      if (result.user != null) {
        await _firestore.collection('users').doc(result.user!.uid).set({
          'uid': result.user!.uid,
          'email': email,
          'onboardingComplete': false,
          'provider': 'email',
          'createdAt': FieldValue.serverTimestamp(),
        });
      }
      return result.user;
    } on FirebaseAuthException catch (e) {
      throw Exception(_mapError(e.code));
    }
  }

  // ================= EMAIL LOGIN =================
  Future<User?> loginWithEmail({required String email, required String password}) async {
    try {
      final query = await _firestore.collection('users').where('email', isEqualTo: email).get();
      if (query.docs.isEmpty) {
        throw Exception("No account found. Please sign up first.");
      }

      final result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      return result.user;
    } on FirebaseAuthException catch (e) {
      throw Exception(_mapError(e.code));
    }
  }

  // ================= HELPERS =================
  Future<bool> isOnboardingDone() async {
    final user = _auth.currentUser;
    if (user == null) return false;
    final doc = await _firestore.collection('users').doc(user.uid).get();
    return doc.data()?['onboardingComplete'] ?? false;
  }

  Future<void> signOut() async {
    await _googleSignIn.signOut();
    await _auth.signOut();
  }

  String _mapError(String code) {
    switch (code) {
      case 'user-not-found':
        return "No account found.";
      case 'wrong-password':
        return "Incorrect password.";
      case 'invalid-credential':
        return "Invalid login details.";
      case 'email-already-in-use':
        return "Email already registered.";
      default: return "An error occurred ($code).";
    }
  }
}