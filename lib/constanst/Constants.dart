import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

const Color AppColor_Blue = Color.fromARGB(255, 89, 180, 255);
const Color AppColor_Black = Colors.black;
const Color AppColor_Gray = Colors.grey;
const Color AppColor_White = Colors.white;

final firestore = FirebaseFirestore.instance;
final usersRef = FirebaseFirestore.instance.collection('users');
final msgRef = FirebaseFirestore.instance.collection('messages');
final chatRef = FirebaseFirestore.instance.collection('chats');

// final signoutRef = FirebaseAuth.instance.signOut();
