import 'package:cached_network_image/cached_network_image.dart';
import 'package:coders_combo_chatapp/constanst/Constants.dart';
import 'package:coders_combo_chatapp/model/user_model.dart';
import 'package:coders_combo_chatapp/screens/auth_screen.dart';
import 'package:coders_combo_chatapp/screens/chat_screen.dart';
import 'package:coders_combo_chatapp/screens/search_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

// String username = 'User';
// String email = 'user@example.com';
// FirebaseUser loggedInUser;

// class FirebaseUser {
// }

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
    await usersRef.doc(widget.user.uid).update({'status': status});
  }

  //   void getCurrentUser() async {
  //   try {
  //     final user = await _auth.currentUser();
  //     if (user != null) {
  //       loggedInUser = user;
  //       setState(() {
  //         username = loggedInUser.displayName;
  //         email = loggedInUser.email;
  //       });
  //     }
  //   } catch (e) {
  //     EdgeAlert.show(context,
  //         title: 'Something Went Wrong',
  //         description: e.toString(),
  //         gravity: EdgeAlert.BOTTOM,
  //         icon: Icons.error,
  //         backgroundColor: Colors.deepPurple[900]);
  //   }
  // }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) //resumed means background theke abar open hoile online dekaibo
    {
      setStatus(
        'online',
      ); //online
    } else {
      //offline
      setStatus('Offline');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Chats"),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 89, 180, 255),

        actions: [
          PopupMenuButton(
            itemBuilder: (context) => [
              PopupMenuItem<int>(
                //int disi karon user jokon item re press korbe int value pass hobe
                value: 0,
                child: Text("Logout"),
              ),
            ],
            onSelected: (value) async {
              await GoogleSignIn()
                  .signOut(); //without it we can't use diffrent account all the time i have to use same account
              await FirebaseAuth.instance.signOut();
              Navigator.pushAndRemoveUntil(
                  context, MaterialPageRoute(builder: (context) => const AuthScreen()), (route) => false);
            },
            // onOpened: () async {
            // await GoogleSignIn()
            //     .signOut(); //without it we can't use diffrent account all the time i have to use same account
            // await FirebaseAuth.instance.signOut();
            // Navigator.pushAndRemoveUntil(
            //     context,
            //     MaterialPageRoute(builder: (context) => const AuthScreen()),
            //     (route) => false);
            // },
          ),
        ],

        // actions: [
        //   IconButton(
        // onPressed: () async {
        //   await GoogleSignIn()
        //       .signOut(); //without it we can't use diffrent account all the time i have to use same account
        //   await FirebaseAuth.instance.signOut();
        //   Navigator.pushAndRemoveUntil(
        //       context,
        //       MaterialPageRoute(builder: (context) => const AuthScreen()),
        //       (route) => false);
        // },
        //       icon: const Icon(Icons.logout))
        // ],
      ),
      //app drawer
      // drawer: Drawer(
      //   child: ListView(children: <Widget>[
      //     UserAccountsDrawerHeader(
      //         accountName: username, accountEmail: accountEmail)
      //   ]),
      // ),
      body: StreamBuilder(
        stream: usersRef.doc(widget.user.uid).collection('messages').snapshots(),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data.docs.length < 1) //null
            {
              return const Center(
                child: Text("No Chats Available"),
              );
            }
            return ListView.builder(
                itemCount: snapshot.data.docs.length,
                itemBuilder: ((context, index) {
                  var friendId = snapshot.data.docs[index].id;
                  var lastMsg = snapshot.data.docs[index]['last_msg'];

                  return FutureBuilder(
                      future: usersRef.doc(friendId).get(),
                      builder: (context, AsyncSnapshot asyncSnapshot) {
                        if (asyncSnapshot.hasData) {
                          var friend = asyncSnapshot.data;
                          return Material(
                            color: Colors.white,
                            child: Column(
                              children: [
                                ListTile(
                                  leading: ClipRRect(
                                    borderRadius: BorderRadius.circular(300.0),

                                    // child: Image.network(friend['Image']),
                                    child: CachedNetworkImage(
                                      imageUrl: (friend['Image']),
                                      placeholder: ((context, url) => const CircularProgressIndicator()),
                                      errorWidget: ((context, url, error) => const Icon(Icons.error)),
                                      height: 50,
                                    ),
                                  ),
                                  title: Text(friend['name']),
                                  subtitle: Container(
                                    child: Text(
                                      "$lastMsg",
                                      style: const TextStyle(color: Color.fromARGB(255, 160, 160, 160)),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    // decoration: BoxDecoration(
                                    //   border: Border(
                                    //     bottom: BorderSide(color: Colors.black),
                                    //   ),
                                    // ),
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

                                  // onLongPress: () {

                                  // },

                                  // onLongPress: () => Container(
                                  //   margin: EdgeInsets.symmetric(vertical: 10),
                                  //   height: 100,
                                  //   width: 100,
                                  //   child: PopupMenuButton(
                                  //     itemBuilder: (context) {
                                  //       return <PopupMenuItem>[
                                  //         new PopupMenuItem(
                                  //             child: Text('Delete')
                                  //             ,onTap: () {

                                  //             },)
                                  //       ];
                                  //     },
                                  //   ),
                                  // ),
                                ),
                                Material(
                                  child: Divider(),
                                ),
                              ],
                            ),
                          );
                        }
                        return const LinearProgressIndicator();
                      });
                  // return ListTile();
                }));
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.search),
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => SearchScreen(widget.user)));
        },
      ),
    );
  }
}
