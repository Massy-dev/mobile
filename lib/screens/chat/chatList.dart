import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/components/avatar/gf_avatar.dart';
import 'package:getwidget/components/card/gf_card.dart';
import 'package:getwidget/components/list_tile/gf_list_tile.dart';
import 'package:getwidget/position/gf_position.dart';
import 'package:scomv1/screens/chat/chat.dart';

class ChatListe extends StatefulWidget {
  const ChatListe({Key? key}) : super(key: key);

  @override
  State<ChatListe> createState() => _ChatListeState();
}

class _ChatListeState extends State<ChatListe> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String contenu = "";
  List<String> myList = [];
  var userListe = [];

  @override
  void initState() {
    super.initState();
    contenu = "chat";
    getDocs();
  }

  getDocs() async {
    final QuerySnapshot result =
        await FirebaseFirestore.instance.collection('chatroom').get();
    final List<DocumentSnapshot> documents = result.docs;

    for (var data in documents) {
      //print(_auth.currentUser!.uid);

      if (data["emetteur"] == _auth.currentUser!.uid) {
        setState(() {
          myList.add(data["recepteur"].toString());
        });
      } else if (data["recepteur"] == _auth.currentUser!.uid) {
        setState(() {
          myList.add(data["emetteur"].toString());
        });
      }
    }
    //print("ma liste$myList");

    final QuerySnapshot users =
        await FirebaseFirestore.instance.collection('Utilisateurs').get();
    final List<DocumentSnapshot> utilisateurs = users.docs;

    for (var element in utilisateurs) {
      for (int i = 0; i < myList.length; i++) {
        if (element["id"].toString() == myList[i].toString()) {
          setState(() {
            userListe.add(element["id"]);
          });
        }
      }
    }
    print(userListe);
  }

  String chatRoomId(String user1, String user2) {
    var chat1 = 0;
    var chat2 = 0;

    for (var i = 0; i < user1.toLowerCase().codeUnits.length; i++) {
      chat1 += user1.toLowerCase().codeUnits[i];
    }

    for (var i = 0; i < user2.toLowerCase().codeUnits.length; i++) {
      chat2 += user2.toLowerCase().codeUnits[i];
    }

    if (chat1 > chat2) {
      return "$user1$user2";
    } else {
      return "$user2$user1";
    }
  }

  Future<QuerySnapshot> users =
      FirebaseFirestore.instance.collection('Utilisateurs').get();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: Container(child: StreamBuilder<QuerySnapshot>(builder:
            (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            print(snapshot.error);
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Text("Loading");
          }
          return FutureBuilder<QuerySnapshot>(
              future: users,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final List<DocumentSnapshot> documents = snapshot.data!.docs;
                  String roomId;
                  return ListView(
                      children: documents
                          .map((doc) => GestureDetector(
                                onTap: () => {
                                  roomId = chatRoomId(
                                      _auth.currentUser!.uid, doc["id"]),
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ChatRoom(
                                        chatRoomId: roomId,
                                        userId: doc["id"],
                                      ),
                                    ),
                                  ),
                                },
                                child: Column(
                                  children: <Widget>[
                                    for (int i = 0; i < userListe.length; i++)
                                      if (userListe[i] == doc["id"])
                                        Card(
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              ListTile(
                                                leading: CircleAvatar(
                                                  radius: 30,
                                                  backgroundImage: NetworkImage(
                                                      doc["photo"]),
                                                ),
                                                title: Text(doc["nom"]),
                                                subtitle: Text(doc["prenom"]),
                                              ),
                                            ],
                                          ),
                                        ),
                                  ],
                                ),
                              ))
                          .toList());
                }
                return const CircularProgressIndicator();
              });
        })));
  }
}
