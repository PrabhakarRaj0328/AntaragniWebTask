// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:contact_app/pages/create.dart';
import 'package:flutter/material.dart';
import 'package:contact_app/pages/recents.dart';
import 'package:contact_app/pages/favorites.dart';
import 'package:contact_app/pages/contacts.dart';

class Home extends StatefulWidget {
  final index;
  const Home({super.key, required this.index});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selectedIndex = 0;


   @override
  void initState() {
    super.initState();
    _selectedIndex = widget.index;
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> widgetOptions = <Widget>[Favorites(), Recents(), Contacts()];
    void onItemTapped(int index) {
      setState(() {
        _selectedIndex = index;
      });
    }

    return Scaffold(
        floatingActionButton: FloatingActionButton(
            backgroundColor: Color.fromRGBO(0, 77, 153, 1),
            child: Icon(
              Icons.dialpad,
              color: Colors.white,
            ),
            onPressed: () {}),
        body: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 5),
            child: Column(
              children: [
                AppBar(
                  title: Container(
                    decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(50.0)),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 15, vertical: 4),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Icon(
                          Icons.search,
                          size: 30,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: TextField(
                            decoration: InputDecoration(
                              hintText: 'Search Contacts',
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                        Icon(
                          Icons.mic_sharp,
                          size: 30,
                        ),
                        Icon(
                          Icons.more_vert_sharp,
                          size: 30,
                        )
                      ],
                    ),
                  ),
                ),
                _selectedIndex == 2
                    ? Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 75, vertical: 15),
                        child: TextButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => Create(),
                                ));
                          },
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Icon(
                                  Icons.person_add_alt,
                                  color: Color.fromRGBO(0, 77, 153, 1),
                                ),
                                SizedBox(
                                  width: 15,
                                ),
                                Expanded(
                                  child: Text(
                                    "Add contact",
                                    style: TextStyle(
                                      fontSize: 20,
                                      color: Color.fromRGBO(0, 77, 153, 1),
                                    ),
                                  ),
                                ),
                              ]),
                        ),
                      )
                    : SizedBox(
                      height: 0,
                      width: 0,
                    ),
                    widgetOptions.elementAt(_selectedIndex)
              ],
            )),
        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.star_border_purple500_outlined),
              label: 'Favorites',
            ),
            BottomNavigationBarItem(
                icon: Icon(Icons.access_time_outlined), label: 'Recents'),
            BottomNavigationBarItem(
                icon: Icon(Icons.person), label: 'Contacts'),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Color.fromRGBO(0, 77, 153, 1),
          onTap: onItemTapped,
        ));
  }
}
