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
    return
        // return Row(
        //   mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        //   children: [
        //     Container(
        //       // padding: EdgeInsets.all(16),
        //       padding: EdgeInsets.symmetric(vertical: 14, horizontal: 14),
        //       margin: EdgeInsets.all(3),
        //       constraints: BoxConstraints(maxWidth: 200),
        //       decoration: BoxDecoration(
        //           color: isMe ? AppColor_Blue : AppColor_Gray,
        //           borderRadius: BorderRadius.all(Radius.circular(12))),
        //       child: Text(
        //         message,
        //         style: TextStyle(
        //             color: Colors.white,
        //             fontSize: 16,
        //             fontWeight: FontWeight.w400,
        //             fontFamily: 'Roboto'),
        //       ),
        //     )
        //   ],
        // );

        Padding(
      padding: const EdgeInsets.all(9.0),
      child: Column(
        crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10),
            // child: Text(
            //   message,
            //   style: TextStyle(
            //       fontSize: 13, fontFamily: 'Poppins', color: Colors.black87),
            // ),
          ),
          Material(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(50),
              topLeft: isMe ? Radius.circular(50) : Radius.circular(0),
              bottomRight: Radius.circular(50),
              topRight: isMe ? Radius.circular(0) : Radius.circular(50),
            ),
            color: isMe ? Colors.blue : Colors.white,
            elevation: 5,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: Text(
                message,
                style: TextStyle(
                  color: isMe ? Colors.white : Colors.blue,
                  fontFamily: 'Poppins',
                  fontSize: 15,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
