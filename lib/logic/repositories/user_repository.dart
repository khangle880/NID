// 📦 Package imports:
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_auth/email_auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

// 🌎 Project imports:
import '../utils/errors/auth_error.dart';

class UserRepository {
  final FirebaseAuth _firebaseAuth;

  UserRepository() : _firebaseAuth = FirebaseAuth.instance;

  /// sign in firebase authentication with credential (email, password)
  Future<String?> signInWithCredentials(String email, String password) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      return null;
    } on FirebaseAuthException catch (e) {
      return e.code.toString();
    } catch (e) {
      return e.toString();
    }
  }

  /// sign up firebase
  Future<UserCredential> signUp(String email, String password) async {
    //? login add new user to firestore "users" and hash
    return _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  /// send email with otp to verify email
  Future<bool> requestResetPassword(String email) async {
    EmailAuth.sessionName = "Reset Password From Aking App";
    return EmailAuth.sendOtp(receiverMail: email);
  }

  /// verify otp correct ?
  bool verify(String email, String otp) {
    return EmailAuth.validate(receiverMail: email, userOTP: otp);
  }

  /// reauthenticated with credential firebase
  /// firebase request reauth before update
  Future reauthenticated(User user, String password) async {
    final credential =
        EmailAuthProvider.credential(email: user.email!, password: password);
    return user.reauthenticateWithCredential(credential);
  }

  /// update password when authenticated
  Future<String?> updatePassword(String password, String newPassword) async {
    final user = await getUser();
    if (user == null) return ErrorCode.userNotFound;
    if (password == newPassword) return ErrorCode.passwordSameOld;
    try {
      await reauthenticated(user, password);
      await user.updatePassword(newPassword);
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .update({"password": newPassword});
    } catch (e) {
      return e.toString();
    }
    return null;
  }

  /// reset password with otp code
  Future<String?> resetPassword(
      String username, String newPassword, String resetCode) async {
    if (!verify(username, resetCode)) return ErrorCode.invalidCode;
    //Create an instance of the current user.
    final User? user = await getUser();
    if (user != null) {
      if (user.email != username) return ErrorCode.userNotLogout;
    }

    // Login as an admin
    final signInAdminError = await signInWithCredentials(
        dotenv.env['ADMINEMAIL']!, dotenv.env['ADMINPASSWORD']!);
    if (signInAdminError != null) return signInAdminError;

    // Get old password of user
    String? oldPassword;
    String? getOldPasswordError;
    await FirebaseFirestore.instance
        .collection('users')
        .where('email', isEqualTo: username)
        .get()
        .then((value) => {
              if (value.size < 1)
                getOldPasswordError = ErrorCode.userNotFound
              else
                oldPassword = value.docs[0]['password'] as String
            });

    // Sign out Admin
    await signOut();

    // Return Error not found user
    if (getOldPasswordError != null || oldPassword == null) {
      return getOldPasswordError;
    }

    // Update password
    final signInUserError = await signInWithCredentials(username, oldPassword!);
    if (signInUserError != null) return signInUserError;

    final String? updatePasswordError =
        await updatePassword(oldPassword!, newPassword);
    await signOut();

    if (updatePasswordError != null) return updatePasswordError;

    return null;
  }

  Future<void> signOut() async {
    return _firebaseAuth.signOut();
  }

  Future<bool> isSignedIn() async {
    final currentUser = _firebaseAuth.currentUser;
    return currentUser != null;
  }

  User? getUser() {
    return _firebaseAuth.currentUser;
  }
}
