
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:liftshare/data/models/chat_message.dart';
import 'package:liftshare/services/chat_service.dart';
import 'package:liftshare/utils/constants.dart';
import 'package:liftshare/utils/firebase_utils.dart';
import 'package:provider/provider.dart';

import '../../../data/models/app_user.dart';
import '../../../providers/user_provider.dart';

class MessagingScreen extends StatefulWidget {
  final String receiverId;

  const MessagingScreen(this.receiverId, {super.key});

  @override
  State<MessagingScreen> createState() => _MessagingScreenState();
}

class _MessagingScreenState extends State<MessagingScreen> {
  late AppUser _user;
  late ChatService _chatService;
  final TextEditingController _messageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _getUser();
    _chatService = ChatService(_user.uid!);
    setState(() {});
  }

  Future<void> _getUser() async {
    UserProvider userProvider = Provider.of<UserProvider>(context, listen: false);
    setState(() {
      _user = (userProvider.user)!;
    });
  }

  void sendMessage() async {
    String message = _messageController.text;
    if (message.isNotEmpty) {
      await _chatService.sendMessage(message, widget.receiverId);
      _messageController.clear();
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.backgroundColor,
        appBar: AppBar(
          backgroundColor: AppColors.buttonColor,
          elevation: 0,
          leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          ),
          title: Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundImage: NetworkImage(_user.photoURL!),
              ),
              const SizedBox(width: 10),
              Text(
                _user.displayName!,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontFamily: "Aeonik",
                ),
              ),
            ],
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Expanded(child: _buildMessageList()),
              _buildMessageInput(),
            ],
          ),
        )
      ),
    );
  }

  Widget _buildMessageList() {
    return FutureBuilder<List<ChatMessage>>(
      future: _chatService.getMessages(widget.receiverId),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<ChatMessage> messages = snapshot.data!;
          return ListView.builder(
            itemCount: messages.length,
            itemBuilder: (context, index) {
              ChatMessage message = messages[index];
              bool isSentByUser = message.senderId == _user.uid;
              Alignment alignment = isSentByUser ? Alignment.centerRight : Alignment.centerLeft;
              return Align(
                alignment: alignment,
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  decoration: BoxDecoration(
                    color: isSentByUser ? AppColors.buttonColor : Colors.white12,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        message.messageContent,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontFamily: "Aeonik",
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        formatFirebaseTimestamp(message.timestamp),
                        style: const TextStyle(
                          color: AppColors.highlightColor,
                          fontSize: 12,
                          fontFamily: "Aeonik",
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  Widget _buildMessageInput() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: TextField(
            controller: _messageController,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontFamily: "Aeonik",
            ),
            decoration: InputDecoration(
              hintText: 'Type a message',
              hintStyle: const TextStyle(
                color: AppColors.highlightColor,
                fontSize: 16,
                fontFamily: "Aeonik",
              ),
              border: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(50)),
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: AppColors.enabledBorderColor),
                borderRadius: const BorderRadius.all(Radius.circular(50)),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: AppColors.enabledBorderColor),
                borderRadius: const BorderRadius.all(Radius.circular(50)),
              ),
            ),
          ),
        ),
        const SizedBox(width: 10),
        IconButton(
          onPressed: sendMessage,
          icon: const Icon(Icons.send, size: 40, color: Colors.white,),
        ),
      ],
    );
  }
}
