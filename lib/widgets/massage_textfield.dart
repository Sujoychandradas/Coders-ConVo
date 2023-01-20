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
            child: TextField(
              decoration: InputDecoration(
                  enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey.shade400),
                  ),
                  filled: true,
                  fillColor: Colors.grey.shade200,
                  hintText: 'Type Your Message',
                  hintStyle: TextStyle(
                      color: Colors.black45,
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      fontFamily: 'Roboto')),
              controller: _controller,
              style: TextStyle(color: Colors.black),
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
              padding: EdgeInsets.all(8),
              decoration:
                  BoxDecoration(shape: BoxShape.circle, color: AppColor_Blue),
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
