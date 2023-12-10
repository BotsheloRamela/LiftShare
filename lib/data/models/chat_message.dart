
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatMessage {
  String messageContent;
  String senderId;
  final Timestamp timestamp;

  ChatMessage({required this.messageContent, required this.senderId, required this.timestamp});

  factory ChatMessage.fromMap(Map<String, dynamic> data) {
    return ChatMessage(
      messageContent: data['messageContent'],
      senderId: data['senderId'],
      timestamp: data['timestamp'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'messageContent': messageContent,
      'senderId': senderId,
      'timestamp': timestamp,
    };
  }
}