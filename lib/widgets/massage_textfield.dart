import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coders_combo_chatapp/constanst/Constants.dart';
import 'package:flutter/material.dart';

class MassageTextField extends StatefulWidget {
  final String currentId; //by defult nullable
  final String friendId;
  MassageTextField(this.currentId, this.friendId);

  @override
  State<MassageTextField> createState() => _MassageTextFieldState();
}

class _MassageTextFieldState extends State<MassageTextField> {
  TextEditingController _controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: EdgeInsetsDirectional.all(8),
      child: Row(
        children: [
          Expanded(
            child: Material(
              borderRadius: BorderRadius.circular(50),
              color: Colors.white,
              elevation: 5,
              child: Padding(
                padding: const EdgeInsets.only(left: 8.0, top: 2, bottom: 2),
                child: TextField(
                  // decoration: InputDecoration(
                  //     enabledBorder: const OutlineInputBorder(
                  //       borderSide: BorderSide(color: Colors.white),
                  //     ),
                  //     focusedBorder: OutlineInputBorder(
                  //       borderSide: BorderSide(color: Colors.grey.shade400),
                  //     ),
                  //     filled: true,
                  //     fillColor: Colors.grey.shade200,
                  //     hintText: 'Type Your Message',
                  //     hintStyle: TextStyle(
                  //         color: Colors.black45,
                  //         fontSize: 16,
                  //         fontWeight: FontWeight.w400,
                  //         fontFamily: 'Roboto'),
                  //         ),

                  decoration: InputDecoration(
                    border: InputBorder.none, contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                    hintText: 'Type your message here...',
                    hintStyle: TextStyle(fontFamily: 'Poppins', fontSize: 14),

                    // border: OutlineInputBorder(
                    //     borderRadius: BorderRadius.circular(50)),
                  ),
                  controller: _controller,
                  style: TextStyle(color: Colors.black54),
                ),
              ),
            ),

            //     child: TextField(
            //   controller: _controller,
            //   decoration: InputDecoration(
            //     labelText: "Type you Message",
            //     fillColor: Colors.grey[100],
            //     filled: true,
            //     border: OutlineInputBorder(
            //         borderSide: BorderSide(width: 0),
            //         gapPadding: 10,
            //         borderRadius: BorderRadius.circular(25)),
            //   ),
            // ),
          ),
          SizedBox(
            width: 20,
          ),
          GestureDetector(
            onTap: () async {
              String message = _controller.text;
              _controller.clear();
              await FirebaseFirestore.instance
                  .collection('users')
                  .doc(widget.currentId)
                  .collection('messages')
                  .doc(widget.friendId)
                  .collection('chats')
                  .add({
                "senderId": widget.currentId,
                "reciverId": widget.friendId,
                "message": message,
                "type": "text",
                "date": DateTime.now()
              }).then((value) {
                FirebaseFirestore.instance
                    .collection('users')
                    .doc(widget.currentId)
                    .collection('messages')
                    .doc(widget.friendId)
                    .set({
                  'last_msg': message,
                });
              });
              await FirebaseFirestore.instance
                  .collection('users')
                  .doc(widget.friendId)
                  .collection('messages')
                  .doc(widget.currentId)
                  .collection("chats")
                  .add({
                "senderId": widget.currentId,
                "receiverId": widget.friendId,
                "message": message,
                "type": "text",
                "date": DateTime.now()
              }).then((value) {
                FirebaseFirestore.instance
                    .collection('users')
                    .doc(widget.friendId)
                    .collection('messages')
                    .doc(widget.currentId)
                    .set({"last_msg": message});
              });
            },
            child: Container(
              padding: EdgeInsets.all(10.0),
              decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.blue),
              child: Icon(
                Icons.send,
                color: Colors.white,
              ),
            ),
          )
        ],
      ),
    );
  }
}
