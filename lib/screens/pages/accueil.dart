import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:scomv1/screens/authenticate/register.dart';
import 'package:scomv1/screens/chat/chat.dart';
import 'package:scomv1/screens/pages/create_profil.dart';
import 'package:scomv1/screens/pages/listeElement/listAnnonce.dart';
import 'package:scomv1/screens/pages/rubriques.dart';

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

class _MyHomePageState extends State<MyHomePage> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  User? user = FirebaseAuth.instance.currentUser;
  //signout function
  signOut() async {
    await auth.signOut();
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => const Register()));
  }

  late List<Widget> _pages;
  late Widget _page1;
  late Widget _page2;
  late Widget _page3;
  late Widget _page4;

  late int _currentIndex;
  late Widget _currentPage;

  @override
  void initState() {
    super.initState();
    _page1 = ListeRubrique();
    _page2 = Anonces();
    _page3 = CreateProfil(
      userId: user!.uid,
    );
    _page4 = ChatRoom(chatRoomId: '', userId: '');
    //_page3 = Page3(changePage: _changeTab);
    _pages = [_page1, _page2, _page3];

    _currentIndex = 0;
    _currentPage = _page1;
  }

  void _changeTab(int index) {
    setState(() {
      _currentIndex = index;
      _currentPage = _pages[index];
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 4,
        child: Scaffold(
          appBar: AppBar(
            toolbarHeight: 110,

            centerTitle: true,
            //leading: Icon(Icons.person_outline),

            title: Text(
              pageTitre,
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
                          child: Text('Véhicules'),
                        ),
                        Tab(
                          child: Text('Import Export'),
                        ),
                        Tab(
                          child: Text('Audit Gestion Comptable'),
                        ),
                        Tab(
                          child: Text('Audit Gestion Comptable'),
                        ),
                        
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
          body: _currentPage,
          bottomNavigationBar: BottomNavigationBar(
              onTap: (index) {
                _changeTab(index);
                pageTitre = listeTitle[index];
              },
              currentIndex: _currentIndex,
              items: const [
                BottomNavigationBarItem(
                  label: page1,
                  icon: Icon(Icons.home),
                ),
                BottomNavigationBarItem(
                  label: page2,
                  icon: Icon(Icons.home_repair_service),
                ),
                BottomNavigationBarItem(
                  label: page3,
                  icon: Icon(Icons.person),
                ),
              ]),
          drawer: Drawer(
            child: Container(
              margin: const EdgeInsets.only(top: 15.0),
              child: Column(
                children: <Widget>[
                  _navigationItemListTitle(page1, 0),
                  _navigationItemListTitle(page2, 1),
                  _navigationItemListTitle(page3, 2),
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
