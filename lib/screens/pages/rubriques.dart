import 'dart:io';
import 'dart:math';
import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hidable/hidable.dart';
import 'package:scomv1/screens/authenticate/register.dart';
import 'package:scomv1/screens/chat/chat.dart';
import 'package:scomv1/screens/pages/brouillon.dart';
import 'package:scomv1/screens/pages/editrofil.dart';
import 'package:scomv1/screens/pages/listeElement/listAnnonce.dart';
import 'package:scomv1/screens/pages/listeElement/listePrestation.dart';
import 'package:scomv1/screens/pages/sousRubrique.dart';
//import 'package:provider/provider.dart';



class ListeRubrique extends StatefulWidget {

 
  @override
  State<ListeRubrique> createState() => _ListeRubriqueState();
}

class _ListeRubriqueState extends State<ListeRubrique> {
  User? user = FirebaseAuth.instance.currentUser;

  Future<QuerySnapshot> rubriques =
      FirebaseFirestore.instance.collection('Rubriques').get();
 signIn() async {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => const Register()));
  }
  @override
  Widget build(BuildContext context) {
    final ScrollController scrollController = ScrollController();

  
    return Scaffold(
             
        body: Container(
          child: StreamBuilder<QuerySnapshot>(builder:
            (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            print(snapshot.error);
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Text("Loading");
          }

          return FutureBuilder<QuerySnapshot>(
              future: rubriques,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final List<DocumentSnapshot> documents = snapshot.data!.docs;

                  return ListView(
                    
                      controller: scrollController,
                      children: documents
                          .map((doc) => GestureDetector(
                              
                                onTap: () => {
                                  debugPrint('Navigation en cour.'),
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                        
                                          (FirebaseAuth.instance.currentUser != null)
                                          ?SousRubriques(documentId: doc.id):
                                          
                                          signIn(),
                                          
                                    )
                                    )
                                  
                      
                                },

                                child: Card(
                                  margin: const EdgeInsets.all(20.0),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                    elevation: 5,
                                    child: Container(
                                      height: 250,
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(15.0),
                                          image: DecorationImage(
                                              fit: BoxFit.cover,
                                              image:
                                                  NetworkImage(doc['image']))),
                                      child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            Expanded(
                                                child: Positioned(
                                              bottom: 0,
                                              child: Container(
                                                width: double.infinity,
                                                height: 55,
                                                color: Color.fromARGB(
                                                    179, 32, 115, 240),
                                                child: Text(
                                                  doc["nom"],
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.white,
                                                      fontSize: 24),
                                                ),
                                                alignment: Alignment.center,
                                              ),
                                            ))
                                          ]),
                                      clipBehavior: Clip.antiAlias,
                                    )),
                              )
                              )
                          .toList()
                          );
                } else if (snapshot.hasError) {
                  return Text("faux");
                }
                return CircularProgressIndicator();
              });
        })));
  }
}
