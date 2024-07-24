import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../Chat/chat.dart';
import '../Helper/helping_user.dart';
import '../models/message.dart';

class ShowUser extends StatelessWidget {
  ShowUser({super.key});

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  User? getCurrentUser() {
    return _auth.currentUser;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Chat with Registered Users"),
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.grey,
        elevation: 0,
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection("Users").snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            displayMessageToUser("Something went wrong", context);
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.data == null) {
            return const Text("No Data");
          }

          final users = snapshot.data!.docs;
          final currentUserEmail = getCurrentUser()?.email;

          return ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              final user = users[index];

              if (user['email'] != currentUserEmail) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    padding: const EdgeInsets.only(top: 10, bottom: 5),
                    decoration: const BoxDecoration(
                      color: Colors.amber,
                      borderRadius: BorderRadius.horizontal(),
                      boxShadow: <BoxShadow>[
                        BoxShadow(
                          blurRadius: 10,
                          spreadRadius: 2,
                          offset: Offset(0, 2),
                        )
                      ],
                    ),
                    child: InkWell(
                      onTap: () {
                        // Navigate to ChatPage with user data
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ChatStream(
                              user: user,
                              receiverEmail: user["email"],
                              receiverID: user['uid'],
                            ),
                          ),
                        );
                      },
                      child: ListTile(
                        title: Text(user['username']),
                        subtitle: Text(user['email']),
                        trailing: Text(user['userType']),
                      ),
                    ),
                  ),
                );
              } else {
                return Container();
              }
            },
          );
        },
      ),
    );
  }
  Future<void> sendMessage(String recieverID, message) async {
    final String currentUserID = _auth.currentUser!.uid;
    final String currentUserEmail = _auth.currentUser!.email!;
    final Timestamp timestamp = Timestamp.now();

    Message newMessage = Message(
      senderID: currentUserID,
      senderEmail: currentUserEmail,
      recieverID: recieverID,
      message: message,
      timestamp: timestamp,
    );

    List<String> ids = [currentUserID, recieverID];
    ids.sort();
    String chatroomID = ids.join('_');
    
    await _firestore
        .collection("chat_rooms")
        .doc(chatroomID)
        .collection("messages")
        .add(newMessage.toMap());
  }

  Stream<QuerySnapshot> getMessages(String userID, otheruserID) {
    List<String> ids = [userID, otheruserID];
    ids.sort();
    String chatroomID = ids.join('_');

    return _firestore
        .collection("chat_rooms")
        .doc(chatroomID)
        .collection("messages")
        .orderBy("timestamp", descending: false)
        .snapshots();
  }
}
