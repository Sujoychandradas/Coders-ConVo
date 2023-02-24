// import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coders_combo_chatapp/constanst/Constants.dart';
import 'package:coders_combo_chatapp/model/user_model.dart';
import 'package:coders_combo_chatapp/widgets/massage_textfield.dart';
import 'package:coders_combo_chatapp/widgets/single_message.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ChatScreen extends StatelessWidget {
  //first we have to know the current user and reciver

  final UserModel currentUser;
  final String friendId;
  final String friendName;
  final String friendImage;

  const ChatScreen(
      {required this.currentUser, required this.friendId, required this.friendName, required this.friendImage});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor_Blue,
        // title: Row(
        //   children: [
        //     ClipRRect(
        //       borderRadius: BorderRadius.circular(88),
        //       child: CachedNetworkImage(
        //         imageUrl: friendImage,
        //         placeholder: ((context, url) => CircularProgressIndicator()),
        //         errorWidget: ((context, url, error) => Icon(Icons.error)),
        //         height: 40,
        //       ),
        //     ),
        //     SizedBox(
        //       width: 5,
        //     ),
        //     Text(friendName, style: TextStyle(fontSize: 20))
        //   ],
        // ),
        title: StreamBuilder<DocumentSnapshot>(
            stream: usersRef.doc(friendId).snapshots(),
            builder: (context, snapshot) {
              if (snapshot.data != null) {
                return Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(88),
                      child: CachedNetworkImage(
                        imageUrl: friendImage,
                        placeholder: ((context, url) => CircularProgressIndicator()),
                        errorWidget: ((context, url, error) => Icon(Icons.error)),
                        height: 40,
                      ),
                    ),
                    SizedBox(width: 5),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(friendName, style: TextStyle(fontSize: 20)),
                        Text(snapshot.data!['status'], style: TextStyle(fontSize: 15)),
                      ],
                    ),
                  ],
                );
              } else {
                return Container();
              }
            }),
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              padding: EdgeInsets.all(10), //wexpended wiget will took all the space
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(25), topRight: Radius.circular(25))),
              child: StreamBuilder(
                stream: usersRef
                    .doc(currentUser.uid)
                    .collection('messages')
                    .doc(friendId)
                    .collection('chats')
                    .orderBy('date', descending: true)
                    .snapshots(),
                builder: (context, AsyncSnapshot snapshot) {
                  // if (snapshot.hasData) {
                  //   if (snapshot.data.docs.length < 1) {
                  //     return Center(
                  //       child: Text("Say Hi"),
                  //     );
                  //   }
                  //   // return ListView.builder(
                  //   //     itemCount: snapshot.data.docs.length,
                  //   //     reverse: true,
                  //   //     physics: BouncingScrollPhysics(),
                  //   //     itemBuilder: ((context, index) {
                  //   //       bool isMe = snapshot.data.docs[index]['senderId'] ==
                  //   //           currentUser.uid;
                  //   //       return SingleMessage(
                  //   //           message: snapshot.data.docs[index]['message'],
                  //   //           isMe: isMe);
                  //   //     }));
                  // }

                  if (snapshot.hasData) {
                    if (snapshot.data.docs.length < 1) {
                      return Center(
                        child: Text("Say Hi..."),
                      );
                    }

                    return ListView.builder(
                      itemBuilder: (context, index) {
                        bool isMe = snapshot.data.docs[index]['senderId'] == currentUser.uid;
                        final data = snapshot.data!.docs[index];
                        return Dismissible(
                          key: UniqueKey(),
                          onDismissed: (direction) async {
                            await FirebaseFirestore.instance
                                .collection("users")
                                .doc(currentUser.uid)
                                .collection('messages')
                                .doc(friendId)
                                .collection('chats')
                                .doc(data.id)
                                .delete();
                            await FirebaseFirestore.instance
                                .collection("users")
                                .doc(friendId)
                                .collection('messages')
                                .doc(currentUser.uid)
                                .collection('chats')
                                .doc(data.id)
                                .delete()
                                .then((value) => Fluttertoast.showToast(
                                      msg: "message deleted successfully!",
                                    ));
                          },
                          child: SingleMessage(
                              message: snapshot.data.docs[index]['message'], //******************* */
                              isMe: isMe),
                        );
                      },
                      itemCount: snapshot.data.docs.length,
                      reverse: true,
                      physics: BouncingScrollPhysics(),
                    );

                    //   return SingleMessage(
                    //       message: snapshot.data.docs[index]['message'],
                    //       isMe: isMe);
                    // },
                    //   itemCount: snapshot.data.docs.length,
                    //   reverse: true,
                    //   physics: BouncingScrollPhysics(),
                    // );
                  }

                  return Center(
                    child: CircularProgressIndicator(),
                  );
                },
              ),
            ),
          ),
          MassageTextField(currentUser.uid, friendId)
        ],
      ),
    );
  }
}
