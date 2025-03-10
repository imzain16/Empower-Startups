import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:empower/componants/chat_bubble.dart';
import 'package:empower/componants/my_textfields.dart';
import 'package:empower/pages/Showing_user_page.dart';
import 'package:flutter/material.dart';

class ChatStream extends StatefulWidget {
  final QueryDocumentSnapshot user;
  final String receiverEmail;
  final String receiverID;

  const ChatStream({required this.user, super.key, required this.receiverEmail, required this.receiverID});

  @override
  State<ChatStream> createState() => _ChatStreamState();
}

class _ChatStreamState extends State<ChatStream> {
  final TextEditingController _messageController = TextEditingController();

  final ShowUser _chat = ShowUser();

  FocusNode myFocusNode = FocusNode();
  
  @override
  void initState(){
    super.initState();
    
    myFocusNode.addListener(() {
      if(myFocusNode.hasFocus){
       Future.delayed(
         const Duration(milliseconds: 500),
           () => scrollDown(),
       );
      }
    });

    Future.delayed(
      const Duration(milliseconds: 500),
        () => scrollDown(),
    );

  }

  @override
  void dispose(){
    myFocusNode.dispose();
    _messageController.dispose();
    super.dispose();
  }

  final ScrollController _scrollController = ScrollController();
  void scrollDown(){
    _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(seconds: 1),
        curve: Curves.fastOutSlowIn);
  }

  void sendMessage() async {
    if(_messageController.text.isNotEmpty){
      await _chat.sendMessage(widget.receiverID, _messageController.text);
      _messageController.clear();
    }
    scrollDown();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Chat with ${widget.user['username']}"),
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.grey,
      ),
      body: Column(
        children: [
          Expanded(
              child: _buildMessageList(),
          ),

          _buildUserInput(),
        ],
      )
    );
  }

  Widget _buildMessageList(){
    String senderID = _chat.getCurrentUser()!.uid;
    return StreamBuilder(stream: _chat.getMessages(widget.receiverID, senderID),
        builder: (context,snapshot) {
          if(snapshot.hasError){
            return const Text("Error");
          }

          if(snapshot.connectionState == ConnectionState.waiting){
            return const Text("Loading..");
          }

          return ListView(
            controller: _scrollController,
            children:
              snapshot.data!.docs.map((doc) => _buildMessageItem(doc)).toList(),
          );
      },
    );
  }

  Widget _buildMessageItem(DocumentSnapshot doc){
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    bool isCurrentUser = data['senderID'] == _chat.getCurrentUser()!.uid;

    var alignment = isCurrentUser ? Alignment.centerLeft : Alignment.centerRight;

    return Container(
      alignment: alignment,
        child: Column(
          crossAxisAlignment:
            isCurrentUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            ChatBubble(message: data["message"], isCurrentUser: isCurrentUser),
          ],
        ));
  }

  Widget _buildUserInput(){
    return Padding(
      padding: const EdgeInsets.only(bottom: 50.0),
      child: Row(
        children: [
            Expanded(child: MyTextField(
              controller: _messageController,
              hintText: "type a message",
              obscureText: false,
              focusNode: myFocusNode,
            ),
            ),

          Container(
            decoration: const BoxDecoration(
              color: Colors.blueAccent,
              shape: BoxShape.circle,
            ),
            margin: const EdgeInsets.only(right: 25),
            child: IconButton(onPressed: sendMessage,
              icon: const Icon(
                Icons.arrow_upward,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
