
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:liftshare/data/models/chat_message.dart';

import '../data/models/app_user.dart';

class ChatService extends ChangeNotifier {
  final String _userID;
  ChatService(this._userID);

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  List<AppUser> _chatUsers = [];
  List<AppUser> get chatUsers => _chatUsers;

  Future<void> sendMessage(String message, String receiverId) async {

    try {
      ChatMessage newMessage = ChatMessage(
        messageContent: message,
        senderId: _userID,
        timestamp: Timestamp.now(),
      );

      final chatsQuerySnapshot = await _firestore.collection('chats').get();

      for (var doc in chatsQuerySnapshot.docs) {
        String docId = doc.id;
        List<String> userIds = docId.split('_');
        if (userIds.contains(_userID) && userIds.contains(receiverId)) {
          await _firestore
              .collection('chats')
              .doc(docId)
              .set({
            'messages': FieldValue.arrayUnion([newMessage.toMap()])
          }, SetOptions(merge: true));
          return;
        }
      }

      await _firestore
          .collection('chats')
          .doc('${_userID}_$receiverId')
          .set({
        'messages': FieldValue.arrayUnion([newMessage.toMap()])
      }, SetOptions(merge: true));

    } catch (e) {
      print("Error sending message: $e");
      rethrow;
    }

  }

  Future<List<ChatMessage>> getMessages(String receiverId) async {
    List<ChatMessage> messages = [];
    try {
      final chatsQuerySnapshot = await _firestore.collection('chats').get();

      for (var doc in chatsQuerySnapshot.docs) {
        String docId = doc.id;
        List<String> userIds = docId.split('_');

        if (userIds.contains(_userID) && userIds.contains(receiverId)) {
          List<dynamic> messagesData = doc.data()['messages'];
          messages = messagesData.map((e) => ChatMessage.fromMap(e)).toList();
          messages.sort((a, b) => a.timestamp.compareTo(b.timestamp));
        }
      }

      return messages;
    } catch (e) {
      print("Error getting messages: $e");
      rethrow;
    }
  }

  Future<void> getChats() async {
    List<AppUser> chatUsers = [];

    try {
      final chatsQuerySnapshot = await _firestore.collection('chats').get();

      for (var doc in chatsQuerySnapshot.docs) {
        String docId = doc.id;

        List<String> userIds = docId.split('_');

        if (userIds.contains(_userID)) {
          String otherUserId = userIds.firstWhere((element) => element != _userID);
          final usersQuerySnapshot = await _firestore.collection('users').get();

          for (var doc in usersQuerySnapshot.docs) {
            if (doc.id == otherUserId) {
              AppUser otherUser = AppUser.fromDocument(doc);
              chatUsers.add(otherUser);
            }
          }
        }
      }

      _chatUsers = chatUsers;
    } catch (e) {
      print("Error getting chats: $e");
      rethrow;
    }
  }
}