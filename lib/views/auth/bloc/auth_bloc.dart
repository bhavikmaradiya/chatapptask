import 'package:chatapp/config/firestore_config.dart';
import 'package:chatapp/config/preference_config.dart';
import 'package:chatapp/utils/app_utils.dart';
import 'package:chatapp/views/auth/model/profile_info.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'auth_event.dart';

part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final _firebaseAuthInstance = FirebaseAuth.instance;

  AuthBloc() : super(AuthInitialState()) {
    on<EmailFieldTextChangeEvent>(_onEmailIdFieldTextChange);
    on<PasswordFieldTextChangeEvent>(_onPasswordFieldTextChange);
    on<VisiblePasswordFieldEvent>(_onVisiblePasswordField);
    on<InVisiblePasswordFieldEvent>(_onInVisiblePasswordField);
    on<VerifyCredentialEvent>(_signInWithEmailPassword);
    on<CreateFirebaseUserEvent>(_createUserWithEmailPassword);
    on<GoogleSignInEvent>(_signInWithGoogle);
  }

  Future<void> _signInWithGoogle(
    GoogleSignInEvent event,
    Emitter<AuthState> emit,
  ) async {
    final googleSignIn = GoogleSignIn();
    final googleSignInAccount = await googleSignIn.signIn();
    if (googleSignInAccount != null) {
      final googleSignInAuthentication =
          await googleSignInAccount.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );
      try {
        final userCredential =
            await _firebaseAuthInstance.signInWithCredential(credential);
        await _fetchFirebaseProfileInfo(emit, userCredential);
      } on FirebaseAuthException catch (e) {
        emit(FirebaseLoginFailedState(e.message));
      } catch (e) {
        emit(FirebaseLoginFailedState(null));
      }
    }
  }

  Future<void> _signInWithEmailPassword(
    VerifyCredentialEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoadingState());
    try {
      final email = event.email;
      final userCredentials =
          await _firebaseAuthInstance.signInWithEmailAndPassword(
        email: email,
        password: event.password,
      );
      await _fetchFirebaseProfileInfo(emit, userCredentials);
    } on FirebaseAuthException catch (ex) {
      if (ex.code == 'user-not-found' || ex.code == 'invalid-credential') {
        emit(FirebaseLoginInvalidUserState());
      } else if (ex.code == 'wrong-password') {
        emit(FirebaseLoginInvalidPasswordState());
      } else {
        emit(FirebaseLoginFailedState(ex.message));
      }
    }
  }

  Future<void> _createUserWithEmailPassword(
    CreateFirebaseUserEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoadingState());
    try {
      final userCredentials =
          await _firebaseAuthInstance.createUserWithEmailAndPassword(
        email: event.email,
        password: event.password,
      );
      await _fetchFirebaseProfileInfo(emit, userCredentials);
    } on FirebaseAuthException catch (ex) {
      emit(FirebaseLoginFailedState(ex.message));
    }
  }

  Future<void> _fetchFirebaseProfileInfo(
    Emitter<AuthState> emit,
    UserCredential userCredentials,
  ) async {
    if (userCredentials.user != null) {
      final firebaseUserId = userCredentials.user!.uid;
      final email = userCredentials.user!.email;
      final profileInfo = await _fetchProfileInfoFromFirebase(firebaseUserId);
      if (profileInfo != null) {
        await _saveProfileInfo(profileInfo);
        emit(FirebaseLoginSuccessHomeState());
      } else {
        await _saveProfileInfo(
          ProfileInfo(
            userId: firebaseUserId,
            email: email,
          ),
        );
        emit(FirebaseLoginSuccessProfileState());
      }
    } else {
      emit(FirebaseLoginFailedState(null));
    }
  }

  Future<ProfileInfo?> _fetchProfileInfoFromFirebase(
    String firebaseUserId,
  ) async {
    final user = await FirebaseFirestore.instance
        .collection(FireStoreConfig.userCollection)
        .doc(firebaseUserId)
        .get();
    ProfileInfo? profileInfo;
    try {
      profileInfo = ProfileInfo.fromSnapshot(user);
    } on Exception catch (_) {}
    return profileInfo;
  }

  void _onEmailIdFieldTextChange(
    EmailFieldTextChangeEvent event,
    Emitter<AuthState> emit,
  ) {
    emit(
      AuthEmailFieldValidationState(
        AppUtils.isValidEmail(event.email.trim()),
      ),
    );
  }

  void _onPasswordFieldTextChange(
    PasswordFieldTextChangeEvent event,
    Emitter<AuthState> emit,
  ) {
    emit(
      AuthPasswordFieldValidationState(
        AppUtils.isValidPasswordToRegister(event.password),
      ),
    );
  }

  void _onVisiblePasswordField(
    VisiblePasswordFieldEvent event,
    Emitter<AuthState> emit,
  ) {
    emit(VisiblePasswordFieldState());
  }

  void _onInVisiblePasswordField(
    InVisiblePasswordFieldEvent event,
    Emitter<AuthState> emit,
  ) {
    emit(InVisiblePasswordFieldState());
  }

  Future<void> _saveProfileInfo(ProfileInfo profileInfo) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      PreferenceConfig.userIdPref,
      profileInfo.userId ?? '',
    );
    await prefs.setString(
      PreferenceConfig.userNamePref,
      profileInfo.name ?? '',
    );
    await prefs.setString(
      PreferenceConfig.userEmailPref,
      profileInfo.email ?? '',
    );
  }
}
