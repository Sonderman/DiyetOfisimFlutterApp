import 'dart:async';

import 'package:diyet_ofisim/Models/Appointment.dart';
import 'package:diyet_ofisim/Services/Repository.dart';
import 'package:diyet_ofisim/locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_core/flutter_chat_core.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:uuid/uuid.dart';

class NewMessage extends StatefulWidget {
  final String otherUserID;
  final String otherUserName;
  final Appointment? aModel;

  const NewMessage({
    super.key,
    required this.otherUserID,
    required this.otherUserName,
    this.aModel,
  });

  @override
  State<NewMessage> createState() => _NewMessageState();
}

class _NewMessageState extends State<NewMessage> {
  final UserService _userService = locator<UserService>();
  final MessagingService _messageService = locator<MessagingService>();
  final _chatController = InMemoryChatController();
  StreamSubscription? _messageStream;
  String _chatID = "temp";

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    final chatID = await _messageService.checkConversation(
      _userService.userModel.id,
      widget.otherUserID,
    );
    if (chatID != "bos") {
      _chatID = chatID;
      _messageStream = _messageService.getChatPoolMessagesSnapshot(chatID).listen((snapshot) {
        final messages = snapshot.docs.map((doc) {
          final data = doc.data() as Map<String, dynamic>;
          return Message.fromJson(data);
        }).toList();
        for (var message in messages) {
          _chatController.insertMessage(message);
        }
      });
    }
  }

  @override
  void dispose() {
    _chatController.dispose();
    _messageStream?.cancel();
    super.dispose();
  }

  Future<User> _resolveUser(String id) async {
    if (id == _userService.userModel.id) {
      return User(
        id: _userService.userModel.id,
        //firstName: _userService.userModel.name,
        //imageUrl: _userService.userModel.profilePhotoUrl
      );
    } else {
      // In a real app, you would fetch the other user's data from a service
      return User(
        id: widget.otherUserID,
        //firstName: widget.otherUserName,
        //imageUrl: 'https://placehold.co/100x100'
      );
    }
  }

  void _onMessageSend(String text) {
    final message = TextMessage(
      id: const Uuid().v4(),
      authorId: _userService.userModel.id,
      createdAt: DateTime.now().toUtc(),
      text: text,
    );
    _chatController.insertMessage(message);

    // Persist the message to Firestore
    _messageService
        .sendMessage(_chatID, message.toJson(), _userService.userModel.id, widget.otherUserID)
        .then((id) {
          if (_chatID == "temp") {
            setState(() {
              _chatID = id;
            });
          }
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.otherUserName)),
      body: Chat(
        chatController: _chatController,
        currentUserId: _userService.userModel.id,
        onMessageSend: _onMessageSend,
        resolveUser: _resolveUser,
      ),
    );
  }
}
