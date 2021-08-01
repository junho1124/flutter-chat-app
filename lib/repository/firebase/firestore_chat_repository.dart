import 'package:chat_app/model/chat.dart';
import 'package:chat_app/repository/repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreChatRepository extends Repository<Chat> {
  final CollectionReference<Chat> _chatRef;

  FirestoreChatRepository({FirebaseFirestore? instance})
      : _chatRef = (instance ?? FirebaseFirestore.instance)
      .collection('messages').withConverter(
            fromFirestore: (snapshot, _) => Chat.fromJson(snapshot.data()!),
            toFirestore: (chat, _) => chat.toJson(),
          );

  @override
  Future<void> add(Chat item) async {
    await _chatRef.add(item);
  }

  @override
  Future<List<Chat>> getAll() async {
    final chats = await _chatRef.get();
    return chats.docs.map((e) => e.data()).toList();
  }
}
