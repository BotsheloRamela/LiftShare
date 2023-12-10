
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:liftshare/ui/screens/chats/messaging_screen.dart';
import 'package:provider/provider.dart';

import '../../../data/models/app_user.dart';
import '../../../providers/user_provider.dart';
import '../../../services/chat_service.dart';
import '../../../utils/constants.dart';

class ChatsScreen extends StatefulWidget {
  const ChatsScreen({super.key});

  @override
  State<ChatsScreen> createState() => _ChatsScreenState();
}

class _ChatsScreenState extends State<ChatsScreen> {
  late AppUser _user;
  late ChatService _chatService;

  @override
  void initState() {
    super.initState();
    _getUser();
    setState(() {});
  }

  Future<void> _getUser() async {
    UserProvider userProvider = Provider.of<UserProvider>(context, listen: false);
    setState(() {
      _user = (userProvider.user)!;
      _chatService = ChatService(_user.uid!);
    });
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
          title: const Text(
            'Chats',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.normal,
            ),
          ),
        ),
        // body must be a list view because we need to wait for the chats to be retrieved from the database, separate the chats  with dividers, and display the other user's name and profile picture
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: FutureBuilder(
            future: _chatService.getChats(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done || snapshot.hasData || _chatService.chatUsers.isNotEmpty) {
                return ListView.separated(
                  itemCount: _chatService.chatUsers.length,
                  separatorBuilder: (context, index) => const Divider(),
                  itemBuilder: (context, index) {
                    AppUser chatUser = _chatService.chatUsers[index];
                    return ListTile(
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MessagingScreen(chatUser.uid!),
                        ),
                      ),
                      leading: CircleAvatar(
                        radius: 25,
                        backgroundImage: NetworkImage(chatUser.photoURL!),
                      ),
                      title: Text(
                        chatUser.displayName!,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    );
                  },
                );
              } else if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else {
                return const Center(
                  child: Text(
                    'No chats',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.normal,
                    ),
                  )
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
