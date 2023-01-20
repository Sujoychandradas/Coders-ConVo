
import 'package:coders_combo_chatapp/constanst/Constants.dart';
import 'package:flutter/material.dart';

class SingleMessage extends StatelessWidget {
  final String message;

  final bool isMe;
  SingleMessage({
    required this.message,
    required this.isMe,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        Container(
          // padding: EdgeInsets.all(16),
          padding: EdgeInsets.symmetric(vertical: 14, horizontal: 14),
          margin: EdgeInsets.all(3),
          constraints: BoxConstraints(maxWidth: 200),
          decoration: BoxDecoration(
              color: isMe ? AppColor_Blue : AppColor_Gray,
              borderRadius: BorderRadius.all(Radius.circular(12))),
          child: Text(
            message,
            style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w400,
                fontFamily: 'Roboto'),
          ),
        )
      ],
    );
  }
}
