
import 'package:chat_app/model/chat.dart';
import 'package:chat_app/repository/repository.dart';
import 'package:firebase_database/firebase_database.dart';

class FirebaseChatRepository extends Repository<Chat> {
  final DatabaseReference _messagesRef;

  FirebaseChatRepository({FirebaseDatabase? instance})
      : _messagesRef = (instance ?? FirebaseDatabase.instance).reference().child('messages2');

  @override
  Future add(Chat item) async {
    await _messagesRef.push().set({
      'name': item.name,
      'profileUrl': item.profileUrl,
      'message': item.message,
      'time': item.time,
      'email': item.email
    });
  }

  @override
  Future<List<Chat>> getAll() async {
    final snapshot = await _messagesRef.get();

    if (snapshot == null) {
      return [];
    }

    Map<String, dynamic> items = Map.from(snapshot.value);
    List<Chat> result = items.entries.map((e) {
      final value = e.value;
      return Chat(value['name'], value['profileUrl'], value['message'],
          value['time'], value['email']);
    }).toList();

    result.sort((a, b) {
      if (a.time! > b.time!) {
        return 1;
      } else if (a.time! < b.time!) {
        return -1;
      }
      return 0;
    });

    return result;
  }
}
