// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:contact_app/pages/create.dart';
import 'package:contact_app/pages/delete.dart';
import 'package:contact_app/pages/home.dart';
import 'package:contact_app/pages/update.dart';
import 'package:flutter/material.dart';

class Contacts extends StatefulWidget {
  const Contacts({super.key});

  @override
  State<Contacts> createState() => _ContactsState();
}

class _ContactsState extends State<Contacts> {
  List<QueryDocumentSnapshot<Object?>> contacts = [];
  bool _isLoading = true;

  Future<void> _getContacts() async {
    try {
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('Contacts').get();

      for (QueryDocumentSnapshot doc in querySnapshot.docs) {
        print(doc.data());
      }
      setState(() {
        contacts = querySnapshot.docs;
        _isLoading = false;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to get Contacts: $e')),
      );
    }
  }

  Future<void> _deleteContact(String id, String url) async {
    await Delete.delete(id: id, url: url);
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => Home(
            index: 2,
          ),
        ),
        (_) => false);
  }

  @override
  void initState() {
    super.initState();
    _getContacts();
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? Center(
            child:
                CircularProgressIndicator(color: Color.fromRGBO(0, 77, 153, 1)),
          )
        : StreamBuilder<QuerySnapshot>(
            stream:
                FirebaseFirestore.instance.collection('Contacts').snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Center(child: CircularProgressIndicator());
              }
              return Expanded(
                  child: ListView.separated(
                separatorBuilder: (context, index) => SizedBox(
                  height: 20,
                ),
                itemCount: contacts.length,
                itemBuilder: (context, index) {
                  final contact = contacts[index];
                  Map<String, dynamic> data =
                      contact.data() as Map<String, dynamic>;
                  String name = data['name'] ?? 'No Name';
                  String url = data['image'];

                  return ListTile(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Update(
                                id: contact.id,
                              ),
                            ));
                      },
                      leading: CircleAvatar(
                        radius: 30,
                        backgroundImage: NetworkImage(url),
                      ),
                      title: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(name),
                            IconButton(
                                onPressed: () async {
                                  _deleteContact(contact.id, url);
                                },
                                icon: Icon(Icons.delete))
                          ]));
                },
              ));
            });
  }
}
