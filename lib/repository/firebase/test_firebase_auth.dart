import 'package:chat_app/model/chat_user.dart';
import 'package:chat_app/model/result.dart';
import 'package:chat_app/repository/user_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:google_sign_in_mocks/google_sign_in_mocks.dart';

class TestFirebaseUserRepository extends UserRepository {
  final MockGoogleSignIn _mockGoogleSignIn;

  TestFirebaseUserRepository({MockGoogleSignIn? googleSignIn})
      : _mockGoogleSignIn = googleSignIn ?? MockGoogleSignIn();

  @override
  void login() async {
    await _mockGoogleSignIn.signIn();
  }

  @override
  void logout() async {
    await _mockGoogleSignIn.disconnect();

    await FirebaseAuth.instance.signOut();
  }

  Future<User?> signInWithGoogle() async {
    // Trigger the authentication flow
    final singInAccount = await MockGoogleSignIn().signIn();

    // Obtain the auth details from the request

    if (singInAccount == null) {
      return null;
    }

    final googleAuth = await singInAccount.authentication;

    final AuthCredential credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken, accessToken: googleAuth.accessToken);
    final user = MockUser(
        isAnonymous: false,
        email: 'aaa@bbb.ccc',
        photoURL: 'abc.png',
        displayName: 'testName');
    final auth = MockFirebaseAuth(mockUser: user);
    final result =  await auth.signInWithCredential(credential);
    final loginUser = result.user;
    return loginUser;
  }

  @override
  Stream<Result<ChatUser>> authStateChanges() {
    return FirebaseAuth.instance.authStateChanges().map((User? user) {
      if (user != null) {
        return Result.success(
            ChatUser(user.email, user.photoURL, user.displayName));
      }
      return Result.error(Exception('로그인 실패'));
    });
  }
}
