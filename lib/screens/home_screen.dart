import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coders_combo_chatapp/model/user_model.dart';
import 'package:coders_combo_chatapp/screens/auth_screen.dart';
import 'package:coders_combo_chatapp/screens/chat_screen.dart';
import 'package:coders_combo_chatapp/screens/search_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class HomeScreen extends StatefulWidget {
  UserModel user;
  HomeScreen(this.user);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addObserver(this); //To intilize widget binding observer
    setStatus("online");
  }

  void setStatus(String status) async {
    await FirebaseFirestore.instance.collection('users').doc(widget.user.uid).update({'status': status});
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state ==
        AppLifecycleState
            .resumed) //resumed means background theke abar open hoile online dekaibo
    {
      setStatus(
        'online',
      ); //online
    } else {
      //offline
      setStatus('offline');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("HOME"),
        centerTitle: true,
        backgroundColor: Colors.teal,
        actions: [
          IconButton(
              onPressed: () async {
                await GoogleSignIn()
                    .signOut(); //without it we can't use diffrent account all the time i have to use same account
                await FirebaseAuth.instance.signOut();
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => AuthScreen()),
                    (route) => false);
              },
              icon: Icon(Icons.logout))
        ],
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(widget.user.uid)
            .collection('messages')
            .snapshots(),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data.docs.length < 1) //null
            {
              return Center(
                child: Text("No Chats Available"),
              );
            }
            return ListView.builder(
                itemCount: snapshot.data.docs.length,
                itemBuilder: ((context, index) {
                  var friendId = snapshot.data.docs[index].id;
                  var lastMsg = snapshot.data.docs[index]['last_msg'];

                  return FutureBuilder(
                      future: FirebaseFirestore.instance
                          .collection('users')
                          .doc(friendId)
                          .get(),
                      builder: (context, AsyncSnapshot asyncSnapshot) {
                        if (asyncSnapshot.hasData) {
                          var friend = asyncSnapshot.data;
                          return ListTile(
                            leading: ClipRect(
                              // child: Image.network(friend['Image']),
                              child: CachedNetworkImage(
                                imageUrl: (friend['Image']),
                                placeholder: ((context, url) =>
                                    CircularProgressIndicator()),
                                errorWidget: ((context, url, error) =>
                                    Icon(Icons.error)),
                                height: 50,
                              ),
                            ),
                            title: Text(friend['name']),
                            subtitle: Container(
                              child: Text(
                                "$lastMsg",
                                style: TextStyle(
                                    color: Color.fromARGB(255, 160, 160, 160)),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ChatScreen(
                                          currentUser: widget.user,
                                          friendId: friend['uid'],
                                          friendName: friend['name'],
                                          friendImage: friend['Image'])));
                            },
                          );
                        }
                        return LinearProgressIndicator();
                      });
                  return ListTile();
                }));
          }
          return Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.search),
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => SearchScreen(widget.user)));
        },
      ),
    );
  }
}
