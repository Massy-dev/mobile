// ignore_for_file: deprecated_member_use

import 'dart:io';
import 'dart:math';
import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:scomv1/screens/authenticate/register.dart';
import 'package:scomv1/screens/chat/chat.dart';
import 'package:scomv1/screens/pages/detailAnonce.dart';
import 'package:scomv1/screens/pages/sousRubrique.dart';
//import 'package:provider/provider.dart';

class Anonces extends StatefulWidget {
  @override
  ListAnonce createState() => ListAnonce();
}

class ListAnonce extends State<Anonces> {
  String userId = "";
  String nom = "";
  bool isLoading = false;

  final FirebaseAuth auth = FirebaseAuth.instance;
  User? user = FirebaseAuth.instance.currentUser;

  Future<void> onSearch() async {
    FirebaseFirestore _firestore = FirebaseFirestore.instance;
    Text("wellcom");
    setState(() {
      isLoading = true;
    });

    setState(() {
      userId = user!.uid;

      isLoading = false;
    });
  }

  Future<QuerySnapshot> anonces =
      FirebaseFirestore.instance.collection('Anonces').get();

  String chatRoomId(String user1, String user2) {
    if (user1[0].toLowerCase().codeUnits[0] >
        user2.toLowerCase().codeUnits[0]) {
      return "$user1$user2";
    } else {
      return "$user2$user1";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
             
              child: StreamBuilder<QuerySnapshot>(builder:
                  (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  print(snapshot.error);
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Text("data");
                }
                return FutureBuilder<QuerySnapshot>(
                    future: anonces,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        final List<DocumentSnapshot> documents =
                            snapshot.data!.docs;
                        return ListView(
                            shrinkWrap: true,
                            children: documents
                                .map((doc) => GestureDetector(
                                    onTap: () => {
                                          debugPrint('Navigation en cour.'),
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  SingleAnonce(
                                                      anonceId: doc.id),
                                            ),
                                          )
                                        },
                                    child: Card(
                                      margin: const EdgeInsets.all(20.0),
                                      clipBehavior: Clip.antiAlias,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(30),
                                      ),
                                      elevation: 5,
                                      child: Container(
                                        child: Column(
                                          children: [
                                            Container(
                                              height: 200,
                                              width: double.infinity,
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          15.0),
                                                  image: DecorationImage(
                                                      fit: BoxFit.cover,
                                                      image: NetworkImage(
                                                          doc['photos'][0]))),
                                            ),
                                            ListTile(
                                              leading: Icon(
                                                  Icons.arrow_drop_down_circle),
                                              title: Text(doc['libelle']),
                                              subtitle: Text(
                                                doc["description"],
                                                style: TextStyle(
                                                    color: Colors.black
                                                        .withOpacity(0.6)),
                                              ),
                                            ),
                                            
                                            ButtonBar(
                                              alignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                FlatButton(
                                                  textColor:
                                                      const Color(0xFF6200EE),
                                                  onPressed: () {
                                                    String roomId = chatRoomId(
                                                        doc["libelle"], doc.id);
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) =>
                                                            ChatRoom(
                                                          chatRoomId: roomId,
                                                          userId: doc["annonceurId"],
                                                        ),
                                                      ),
                                                    );
                                                    print(userId);
                                                  },
                                                  child: const Text('Laisser un message'),
                                                ),
                                                FlatButton(
                                                  textColor:
                                                      const Color(0xFF6200EE),
                                                  onPressed: () {
                                                    // Perform some action
                                                  },
                                                  child: const Text('ACTION 2'),
                                                ),
                                              ],
                                            ),

                                            //Image.asset('assets/card-sample-image-2.jpg'),
                                          ],
                                        ),
                                      ),
                                    )))
                                .toList());
                      } else if (snapshot.hasError) {
                        return Text("faux");
                      }
                      return CircularProgressIndicator();
                    });
              }));
          
      
  }
}
