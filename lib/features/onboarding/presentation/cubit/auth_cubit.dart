// features/auth/presentation/cubit/auth_cubit.dart
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:lens/features/onboarding/domain/models/user.dart';

part 'auth_state.dart';
part 'auth_cubit.freezed.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(const AuthState.initial());

  final auth = FirebaseAuth.instance;
  final googleSignin = GoogleSignIn();
  final firestore = FirebaseFirestore.instance;

  Future<void> checkAuthState() async {
    emit(const AuthState.loading());
    try {
      final user = auth.currentUser;
      if (user == null) {
        emit(AuthState.initial());
        return;
      }
      final doc = await firestore.collection('users').doc(user.uid).get();
      if (doc.exists) {
        final appUser = AppUser.fromJson(doc.data()!);
        emit(
          AuthState.authenticated(
            firebaseUser: user,
            appUser: appUser,
            isNewUser: false,
          ),
          
        );
      } else {
        await auth.signOut();
        await googleSignin.signOut();
        emit(const AuthState.initial());
      }
    } catch (e) {
      emit(AuthState.error(message: e.toString()));
    }
  }

  Future<void> signOut() async {
    emit(const AuthState.loading());

    await auth.signOut();
    await googleSignin.signOut();
    emit(const AuthState.initial());
  }

  Future<void> googleSignIn() async {
    emit(const AuthState.loading());
    try {
      final googleUser = await googleSignin.signIn();
      if (googleUser == null) {
        emit(const AuthState.initial());
        return;
      }

      final googleAuth = await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      final userCredential = await auth.signInWithCredential(credential);
      final firebaseUser = userCredential.user!;

      final docRef = firestore.collection('users').doc(firebaseUser.uid);
      final doc = await docRef.get();

      if (doc.exists) {
        final appUser = AppUser.fromJson(doc.data()!);
        emit(
          AuthState.authenticated(
            firebaseUser: firebaseUser,
            appUser: appUser,
            isNewUser: false,
          ),
        );
      } else {
        final newUser = AppUser(
          uid: firebaseUser.uid,
          email: firebaseUser.email ?? "",
          createdAt: DateTime.now(),
          photoUrl: firebaseUser.photoURL,
          name: firebaseUser.displayName,
        );
        await docRef.set(newUser.toJson());

        emit(
          AuthState.authenticated(
            firebaseUser: firebaseUser,
            appUser: newUser,
            isNewUser: true,
          ),
        );
        
      }
    } catch (e) {
      emit(AuthState.error(message: e.toString()));
    }
  }
}
