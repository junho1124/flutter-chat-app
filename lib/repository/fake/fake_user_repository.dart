import 'dart:async';

import 'package:chat_app/model/chat_user.dart';
import 'package:chat_app/model/result.dart';
import 'package:chat_app/repository/user_repository.dart';

class FakeUserRepository extends UserRepository {
  StreamController<ChatUser?> _authStateStreamController = StreamController();


  StreamController<ChatUser?> get authStateStreamController =>
      _authStateStreamController;

  @override
  void login() async {
    await Future.delayed(Duration(seconds: 1));
    _authStateStreamController.add(ChatUser('bbb@aaa.com', '', '오준석'));
  }

  @override
  void logout() async {
    _authStateStreamController.add(null);
  }

  @override
  Stream<Result<ChatUser>> authStateChanges() {
    return _authStateStreamController.stream.map((ChatUser? user) {
      if (user != null) {
        return Result.success(user);
      }
      return Result.error(Exception('로그인 실패'));
    });
  }
}
