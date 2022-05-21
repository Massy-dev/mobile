import 'dart:io';
import 'dart:math';
import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hidable/hidable.dart';
import 'package:scomv1/screens/authenticate/register.dart';
import 'package:scomv1/screens/pages/aSupprimer/demande.dart';
import 'package:scomv1/screens/pages/listeElement/listeDemande.dart';
import 'package:scomv1/screens/pages/listeElement/listePrestation.dart';
import 'package:scomv1/screens/pages/aSupprimer/prestation.dart';

class SousRubriques extends StatefulWidget {
  final String documentId;

  SousRubriques({required this.documentId});

  @override
  State<SousRubriques> createState() => _SousRubriquesState();
}

class _SousRubriquesState extends State<SousRubriques> {
  int index = 0;
  final ScrollController scrollController = ScrollController();

  final FirebaseAuth auth = FirebaseAuth.instance;
  signOut() async {
    await auth.signOut();
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => Register()));
  }

  @override
  Widget build(BuildContext context) {
    Future<QuerySnapshot<Map<String, dynamic>>> rubriques = FirebaseFirestore
        .instance
        .collection('Rubriques')
        .doc(widget.documentId.toString())
        .collection("sous-rubriques")
        .get();

    print("rubrique" +widget.documentId);

    return DefaultTabController(
        length: 6,
        child: Scaffold(
            resizeToAvoidBottomInset: false,
            appBar: AppBar(
              toolbarHeight: 110,

              centerTitle: true,
              //leading: Icon(Icons.person_outline),

              title: Text(
                'Services',
                style: TextStyle(fontSize: 24.0),
              ),
              bottom: PreferredSize(
                  child: Container(
                    /*decoration: const BoxDecoration(
                      color: Color.fromARGB(255, 22, 70, 228),
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(50),
                          bottomRight: Radius.circular(50))),*/

                    child: TabBar(
                        isScrollable: true,
                        unselectedLabelColor: Colors.white.withOpacity(0.3),
                        indicatorColor: Colors.white,
                        tabs: [
                          Tab(
                            child: Text('Tab 1'),
                          ),
                          Tab(
                            child: Text('Investment'),
                          ),
                          Tab(
                            child: Text('Your Earning'),
                          ),
                          Tab(
                            child: Text('Current Balance'),
                          ),
                          Tab(
                            child: Text('Tab 5'),
                          ),
                          Tab(
                            child: Text('Tab 6'),
                          )
                        ]),
                  ),
                  preferredSize: Size.fromHeight(30.0)),
              actions: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(right: 16.0),
                ),
                new IconButton(
                  icon: Icon(Icons.logout),
                  onPressed: () {
                    signOut();
                  },
                )
              ],
            ),
            body: Container(
              padding: EdgeInsets.only(
                  left: 15.0, top: 15.0, right: 15.0, bottom: 10.0),
              child: StreamBuilder<QuerySnapshot>(builder:
                  (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
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
                        final List<DocumentSnapshot> documents =
                            snapshot.data!.docs;
                        return ListView(
                            controller: scrollController,
                            children: documents
                                .map((doc) => GestureDetector(
                                      onTap: () => {
                                        showDialog<String>(
                                          // barrierColor: Colors.transparent,
                                          context: context,
                                          builder: (BuildContext context) =>
                                              AlertDialog(
                                            //title: contextst Text('AlertDialog Title'),
                                            //content: const Text('AlertDialog description'),

                                            actions: [
                                              SizedBox(
                                                  width: MediaQuery.of(context)
                                                      .size
                                                      .width,
                                                  child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        ButtonTheme(
                                                          minWidth: 30.0,
                                                          height: 60.0,
                                                          child: ElevatedButton
                                                              .icon(
                                                            style:
                                                                ElevatedButton
                                                                    .styleFrom(
                                                              primary:
                                                                  Colors.white,
                                                              fixedSize:
                                                                  const Size(
                                                                      300, 50),
                                                              shape:
                                                                  RoundedRectangleBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            30.0),
                                                              ),
                                                            ),
                                                            onPressed: () => {
                                                              Navigator.push(
                                                                context,
                                                                MaterialPageRoute(
                                                                    builder: (context) =>
                                                                        ListePrestation(
                                                                            detailId:
                                                                                doc.id)),
                                                              ),
                                                            },
                                                            icon: const Icon(
                                                              Icons
                                                                  .info_outline_rounded,
                                                              color:
                                                                  Colors.blue,
                                                            ), //icon data for elevated button
                                                            label: Text(
                                                              "Demander un service",
                                                              style: TextStyle(
                                                                color:
                                                                    Colors.blue,
                                                                fontSize: 20,
                                                              ),
                                                            ), //label text
                                                          ),
                                                        ),
                                                        SizedBox(height: 30),
                                                        ButtonTheme(
                                                          minWidth: 30.0,
                                                          height: 60.0,
                                                          child: ElevatedButton
                                                              .icon(
                                                            style:
                                                                ElevatedButton
                                                                    .styleFrom(
                                                              primary:
                                                                  Colors.white,
                                                              //padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                                                              fixedSize:
                                                                  const Size(
                                                                      300, 50),
                                                              shape:
                                                                  RoundedRectangleBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            30.0),
                                                              ),
                                                            ),
                                                            onPressed: () {
                                                              Navigator.push(
                                                                context,
                                                                MaterialPageRoute(
                                                                    builder: (context) =>
                                                                        ListeDemande(
                                                                            detailId:
                                                                                doc.id)),
                                                              );
                                                            },
                                                            icon: const Icon(
                                                              Icons
                                                                  .business_center_rounded,
                                                              color:
                                                                  Colors.blue,
                                                            ), //icon data for elevated button
                                                            label: Text(
                                                              "Proposer un service",
                                                              style: TextStyle(
                                                                color:
                                                                    Colors.blue,
                                                                fontSize: 20,
                                                              ),
                                                            ), //label text
                                                          ),
                                                        )
                                                      ]))
                                            ],
                                            backgroundColor:
                                                Color.fromARGB(0, 255, 82, 82),
                                          ),
                                        )
                                      },
                                      child: Card(
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(30),
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
                                                    image: NetworkImage(
                                                        doc['image']))),
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
                                                      alignment:
                                                          Alignment.center,
                                                    ),
                                                  ))
                                                ]),
                                            clipBehavior: Clip.antiAlias,
                                          )),
                                    ))
                                .toList());
                      } else if (snapshot.hasError) {
                        return Text("faux");
                      }
                      return CircularProgressIndicator();
                    });
              }),
            ),
            bottomNavigationBar: Hidable(
              controller: scrollController,
              wOpacity: true, // As default it's true
              size: kBottomNavigationBarHeight, // As default it's same.
              child: BottomNavigationBar(
                currentIndex: index,
                onTap: (i) => setState(() => index = i),
                items: bottomBarItems(),
              ),
            )));
  }

  List<BottomNavigationBarItem> bottomBarItems() {
    return [
      BottomNavigationBarItem(
        label: 'Home',
        icon: const Icon(Icons.home, color: Color.fromARGB(255, 12, 109, 219)),
      ),
      BottomNavigationBarItem(
        label: 'Favorites',
        icon: const Icon(Icons.favorite,
            color: Color.fromARGB(255, 12, 109, 219)),
      ),
      BottomNavigationBarItem(
        label: 'Profile',
        icon:
            const Icon(Icons.person, color: Color.fromARGB(255, 12, 109, 219)),
      ),
      BottomNavigationBarItem(
        label: 'Settings',
        icon: const Icon(Icons.settings,
            color: Color.fromARGB(255, 12, 109, 219)),
      ),
    ];
  }
}
