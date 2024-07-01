// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:contact_app/pages/contacts.dart';
import 'package:contact_app/pages/home.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class Update extends StatefulWidget {
  final String id;

  const Update({super.key, required this.id});

  @override
  State<Update> createState() => _UpdateState();
}

class _UpdateState extends State<Update> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  String? url = '';
  final ImagePicker _picker = ImagePicker();
  File? _image;
  bool _isUploading = false;

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  Future<void> _fetchContactById() async {
    try {
      DocumentSnapshot contact = await FirebaseFirestore.instance
          .collection('Contacts')
          .doc(widget.id)
          .get();
      print(contact);
      if (contact.exists) {
        Map<String, dynamic> contactData =
            contact.data() as Map<String, dynamic>;
        setState(() {
          url = contactData['image'];
          _nameController.text = contactData['name'];
          _phoneController.text = contactData['phone'];
          _emailController.text = contactData['email'];
        });
      }
    } catch (e) {
      print("Failed to fetch contact data: $e");
    }
  }

  Future<void> _update() async {
    final name = _nameController.text;
    final phone = _phoneController.text;
    final email = _emailController.text;
    String fileName;
    Reference storageReference;
    UploadTask uploadTask;
    TaskSnapshot taskSnapshot;

    String downloadUrl;

    if (name.isNotEmpty && email.isNotEmpty) {
      try {
        setState(() {
          _isUploading = true;
        });
        if (_image != null) {
          Reference storageReference = FirebaseStorage.instance.refFromURL(url!);
          await storageReference.delete();
          fileName =
              'images/${DateTime.now().millisecondsSinceEpoch.toString()}.jpg';
          storageReference = FirebaseStorage.instance.ref().child(fileName);
          uploadTask = storageReference.putFile(_image!);
          taskSnapshot = await uploadTask;

          downloadUrl = await taskSnapshot.ref.getDownloadURL();
        } else {
          downloadUrl = url!;
        }
        await FirebaseFirestore.instance
            .collection('Contacts')
            .doc(widget.id)
            .update({
          'name': name,
          'email': email,
          'phone': phone,
          'image': downloadUrl,
        });
        setState(() {
          _isUploading = true;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Updated Contact successfully!')),
        );
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => Home(
                index: 2,
              ),
            ),
            (_) => false);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to add data: $e')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill out all fields')),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchContactById();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.close),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Update',
              style: TextStyle(
                fontSize: 20,
              ),
            ),
            Row(children: [
              _isUploading
                  ? CircularProgressIndicator()
                  : TextButton(
                      onPressed: _update,
                      child: Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: Color.fromRGBO(0, 77, 153, 1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text('Save',
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.white,
                              )))),
              Icon(
                Icons.more_vert,
                size: 30,
              )
            ])
          ],
        ),
      ),
      body: SingleChildScrollView(
          child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
        child: Column(children: [
          Center(
              child: TextButton(
            style: TextButton.styleFrom(
              overlayColor: Colors.transparent,
            ),
            onPressed: _pickImage,
            child: Column(children: [
              _image != null
                  ? CircleAvatar(
                      radius: 90,
                      backgroundColor: Color.fromRGBO(216, 213, 239, 1),
                      backgroundImage: FileImage(_image!),
                    )
                  : CircleAvatar(
                      radius: 90,
                      backgroundColor: Color.fromRGBO(216, 213, 239, 1),
                      backgroundImage: NetworkImage(url!),
                    ),
              SizedBox(
                height: 10,
              ),
              Text(
                'Add Photo',
                style: TextStyle(
                  fontSize: 17,
                  color: Color.fromRGBO(0, 77, 153, 1),
                ),
              )
            ]),
          )),
          SizedBox(
            height: 50,
          ),
          Row(
            children: [
              Icon(
                Icons.person_outline_outlined,
                size: 35,
              ),
              SizedBox(
                width: 15,
              ),
              Expanded(
                child: TextField(
                  controller: _nameController,
                ),
              )
            ],
          ),
          SizedBox(
            height: 15,
          ),
          Row(
            children: [
              Icon(
                Icons.phone_outlined,
                size: 35,
              ),
              SizedBox(
                width: 15,
              ),
              Expanded(
                child: TextField(
                    controller: _phoneController,
                    decoration: InputDecoration(hintText: 'Phone')),
              )
            ],
          ),
          SizedBox(
            height: 15,
          ),
          Row(
            children: [
              Icon(
                Icons.mail_outline_outlined,
                size: 35,
              ),
              SizedBox(
                width: 15,
              ),
              Expanded(
                child: TextField(
                    controller: _emailController,
                    decoration: InputDecoration(hintText: 'Email')),
              )
            ],
          )
        ]),
      )),
    );
  }
}
