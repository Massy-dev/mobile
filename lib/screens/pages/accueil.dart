// ignore_for_file: unrelated_type_equality_checks

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:scomv1/screens/authenticate/register.dart';
import 'package:scomv1/screens/chat/chat.dart';
import 'package:scomv1/screens/chat/chatList.dart';
import 'package:scomv1/screens/pages/create_profil.dart';
import 'package:scomv1/screens/pages/listeElement/listAnnonce.dart';
import 'package:scomv1/screens/pages/rubriques.dart';
import 'package:scomv1/screens/pages/sousRubTab.dart';
import 'package:scomv1/screens/pages/sousRubrique.dart';

const String page1 = "Accueil";
const String page2 = "Anonces";
const String page3 = "Profile";
const String page4 = "Messages";
const String title = "Demo";

final listeTitle = <String>["Accueil", "Anonces", "Profil", "Messages"];

String pageTitre = "Accueil";

class MyHomePage extends StatefulWidget {
  //const MyHomePage({Key? key, required this.title}) : super(key: key);
  //final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  final FirebaseAuth auth = FirebaseAuth.instance;
  TabController? _tabController;
  //User? user = FirebaseAuth.instance.currentUser;
  //signout function
  signOut() async {
    await auth.signOut();
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => MyHomePage()));
  }

  signIn() async {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => const Register()));
  }

  sousRub(a) async {
    String result = a.replaceAll(' ', '');

    Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (context) => SousRubriques(documentId: result)));
  }

  int declencheur = 1;

  void actualise(a) async {
    setState(() {
      declencheur = a;
    });
  }

  late List<Widget> _pages;
  late Widget _page1;
  late Widget _page2;
  late Widget _page3;
  late Widget _page4;

  late int _currentIndex;
  late Widget _currentPage;
  String users = "";

  @override
  void initState() {
    super.initState();
    //_tabController = TabController(length:2, vsync: this);
    _page1 = ListeRubrique();
    _page2 = Anonces();

    if ( auth.currentUser!.uid != null) {
      _page3 = CreateProfil(
        userId: auth.currentUser!.uid,
      );
    } else {
      _page3 = const Text("Veuillez vous inscrire");
    }

    _page4 = const ChatListe();

    //_page3 = Page3(changePage: _changeTab);
    _pages = [_page1, _page2, _page3, _page4];

    _currentIndex = 0;
    _currentPage = _page1;
    getRub();
  }

  List<String> userListe = [];
  List<Tab> tabs = <Tab>[
    const Tab(text: 'Accueil'),
    /*const Tab(text: 'Véhicule'),
    const Tab(text: 'Import Export'),
    const Tab(text: 'Audit Gestion Comptable'),
    const Tab(text: 'Assistance juridique'),*/
  ];

  var eleme = "";
  void getRub() async {
    final QuerySnapshot users =
        await FirebaseFirestore.instance.collection('Rubriques').get();
    final List<DocumentSnapshot> utilisateurs = users.docs;
    tabs.clear();
    for (var element in utilisateurs) {
      setState(() {
        userListe.add(
          element["nom"],
        );

        var keys;
        tabs.add(Tab(
          text: element["nom"] + '@' + element["id"],
        ));
        //eleme =  userListe.map((city) => city["nom"]).toList();
      });
    }

    // tabs = userListe.cast<Tab>();
    _tabController = TabController(length: tabs.length, vsync: this);
    print(tabs.length);
  }

  List<String> tabTextList = [];

  void _changeTab(int index) {
    setState(() {
      _currentIndex = index;
      _currentPage = _pages[index];
    });
  }

  //late final
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: tabs.length,
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            toolbarHeight: 100,

            centerTitle: true,
            //leading: Icon(Icons.person_outline),

            title: Text(
              pageTitre,
              style: const TextStyle(fontSize: 24.0),
            ),
            bottom: PreferredSize(
                child: Container(
                  /*decoration: const BoxDecoration(
                      color: Color.fromARGB(255, 22, 70, 228),
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(50),
                          bottomRight: Radius.circular(50))),*/

                  child: TabBar(
                    controller: _tabController,
                    isScrollable: true,
                    //indicatorSize: TabBarIndicatorSize.label,
                    unselectedLabelColor: Colors.white,
                    labelColor: Color.fromARGB(255, 5, 104, 218),
                    indicator: const BoxDecoration(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(15),
                            topRight: Radius.circular(15)),
                        color: Color.fromARGB(255, 255, 255, 255)),
                    onTap: (int index) {
                      actualise(2);
                    },
                    tabs: tabs
                        .map<Widget>((e) => Text(
                              e.text!.split("@")[0].toString(),
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16),
                            ))
                        .toList(),
                  ),
                ),
                preferredSize: const Size.fromHeight(30.0)),
            actions: <Widget>[
              const Padding(
                padding: EdgeInsets.only(right: 16.0),
              ),
              Container(
                  child: (FirebaseAuth.instance.currentUser == null)
                      ? IconButton(
                          icon: const Icon(Icons.logout),
                          onPressed: () {
                            signOut();
                          },
                        )
                      : IconButton(
                          icon: const Icon(Icons.login),
                          onPressed: () {
                            signIn();
                          },
                        ))
            ],
          ),
          body: //_currentPage,
              Container(
                  child: (declencheur == 1)
                      ? _currentPage
                      : TabBarView(
                          physics: const NeverScrollableScrollPhysics(),
                          controller: _tabController,
                          children: tabs.map((Tab tab) {
                            return Center(
                              //child: Text(tab.text!.split("@")[1].toString()),
                              child: SousRubTab(documentId: tab.text!.split("@")[1].toString().replaceAll(' ', '')),
                              //child: sousRub(tab.text!.split("@")[1].toString().replaceAll(' ', '')),
                            );
                          }).toList(),
                        )),
          bottomNavigationBar: BottomNavigationBar(
              onTap: (index) {
                _changeTab(index);
                pageTitre = listeTitle[index];
                actualise(1);
              },
              currentIndex: _currentIndex,
              items: const [
                BottomNavigationBarItem(
                  label: page1,
                  icon: Icon(Icons.home,
                      color: Color.fromARGB(255, 12, 109, 219)),
                ),
                BottomNavigationBarItem(
                  label: page2,
                  icon: Icon(Icons.home_repair_service,
                      color: Color.fromARGB(255, 12, 109, 219)),
                ),
                BottomNavigationBarItem(
                  label: page3,
                  icon: Icon(Icons.person,
                      color: Color.fromARGB(255, 12, 109, 219)),
                ),
                BottomNavigationBarItem(
                  label: page4,
                  icon: Icon(Icons.message,
                      color: Color.fromARGB(255, 12, 109, 219)),
                ),
              ]),
          drawer: Drawer(
            child: Container(
              margin: const EdgeInsets.only(top: 10.0),
              child: Column(
                children: <Widget>[
                  _navigationItemListTitle(page1, 0),
                  _navigationItemListTitle(page2, 1),
                  _navigationItemListTitle(page3, 2),
                  _navigationItemListTitle(page4, 3),
                ],
              ),
            ),
          ),
        ));
  }

  Widget _navigationItemListTitle(String title, int index) {
    return ListTile(
      title: Text(
        '$title Page',
        style: TextStyle(color: Colors.blue[400], fontSize: 22.0),
      ),
      onTap: () {
        Navigator.pop(context);
        _changeTab(index);
      },
    );
  }
}
