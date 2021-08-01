// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.



import 'package:chat_app/model/chat.dart';
import 'package:chat_app/repository/fake/fake_chat_repository.dart';
import 'package:chat_app/repository/fake/fake_user_repository.dart';
import 'package:chat_app/repository/firebase/firestore_chat_repository.dart';
import 'package:chat_app/repository/firebase/test_firebase_auth.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_sign_in_mocks/google_sign_in_mocks.dart';


void main() {
  test('fireStore 채팅이 추가 되어야 한다.', () async {
    final repository = FirestoreChatRepository(instance: FakeFirebaseFirestore());

    expect((await repository.getAll()).length, 0);

    await repository.add(Chat('준호', '', 'ㄹㅇㄴㄹㅇㄴㄹㄴ', 0, 'aaa@bbb.ccc'));

    expect((await repository.getAll()).length, 1);
  });
  test('로그인이 되었는지', () async {
    // WidgetsFlutterBinding.ensureInitialized();
    // await Firebase.initializeApp();
    final googleSignIn = MockGoogleSignIn();
    final repository = TestFirebaseUserRepository(googleSignIn: googleSignIn);
    final loginUser = await repository.signInWithGoogle();
    expect(loginUser!.displayName, 'testName');
    expect(loginUser.email, 'aaa@bbb.ccc');
    expect(loginUser.photoURL, 'abc.png');

  });
  // test('firebase realtime 채팅이 추가 되어야 한다.', () async {
  //   final repository = FirebaseChatRepository(instance: FakeFirebaseFirestore());
  //
  //   expect((await repository.getAll()).length, 0);
  //
  //   await repository.add(Chat('준호', '', 'ㄹㅇㄴㄹㅇㄴㄹㄴ', 0, 'aaa@bbb.ccc'));
  //
  //   expect((await repository.getAll()).length, 1);
  // });

  test('fakeChatRepository 테스트', () async {
    final repository = FakeChatRepository();

    expect(repository.items.length, 3);

    await repository.add(Chat('11', 'weqqwe', 'qwewqe', 1, 'addfsf'));

    expect(repository.items.length, 4);
  });
  test('fakeUserRepository 테스트', () async {
    final repository = FakeUserRepository();

    repository.login();

    repository.authStateStreamController.stream.listen(
      expectAsync1(
          (event) {
            if(event != null) {
              expect(event.name, '오준석');
            }
      })
    );


  });
}
