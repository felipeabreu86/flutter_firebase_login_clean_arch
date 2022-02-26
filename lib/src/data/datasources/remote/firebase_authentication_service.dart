import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_delivery_app_clean_arch/src/data/models/app_user_model.dart';
import 'package:flutter_delivery_app_clean_arch/src/domain/datasources/remote/authentication_service.dart';

class FirebaseAuthenticationService implements AuthenticationService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  @override
  Future<AppUserModel> loginWithEmailPassword({
    required String email,
    required String password,
  }) async {
    AppUserModel userModel = AppUserModel.empty();
    try {
      final UserCredential credential = await _firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);

      if (credential.user?.uid.isNotEmpty ?? false) {
        final User currentUser = credential.user!;
        userModel = AppUserModel(
          userId: currentUser.uid,
          fullName: currentUser.displayName ?? '',
          email: currentUser.email ?? '',
          imageUrl: currentUser.photoURL ?? '',
          role: '',
        );
      }
    } catch (_) {}
    return userModel;
  }

  @override
  Future<AppUserModel> checkAuthentication() async {
    AppUserModel userModel = AppUserModel.empty();
    try {
      if (_firebaseAuth.currentUser != null) {
        final User currentUser = _firebaseAuth.currentUser!;
        userModel = AppUserModel(
          userId: currentUser.uid,
          fullName: currentUser.displayName ?? '',
          email: currentUser.email ?? '',
          imageUrl: currentUser.photoURL ?? '',
          role: '',
        );
      }
    } catch (_) {}
    return userModel;
  }

  @override
  Future<bool> signOut() async {
    bool userLoggedOut = false;
    try {
      await _firebaseAuth.signOut();
      if (_firebaseAuth.currentUser == null) {
        userLoggedOut = true;
      }
    } catch (_) {}
    return userLoggedOut;
  }

  @override
  Future<AppUserModel> createUserWithEmailAndPassword({
    required String email,
    required String password,
    required String fullname,
  }) async {
    AppUserModel userModel = AppUserModel.empty();
    try {
      final UserCredential credential = await _firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);

      if (credential.user?.uid.isNotEmpty ?? false) {
        final User currentUser = credential.user!;
        await currentUser.updateDisplayName(fullname);

        userModel = AppUserModel(
          userId: currentUser.uid,
          fullName: currentUser.displayName ?? '',
          email: currentUser.email ?? '',
          imageUrl: currentUser.photoURL ?? '',
          role: '',
        );
      }
    } catch (_) {}
    return userModel;
  }

  @override
  Future<void> sendPasswordResetEmail({required String email}) async {
    await _firebaseAuth.sendPasswordResetEmail(email: email);
  }
}