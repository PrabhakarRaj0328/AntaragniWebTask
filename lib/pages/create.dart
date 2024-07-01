// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:contact_app/pages/home.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class Create extends StatefulWidget {
  const Create({
    super.key,
  });

  @override
  State<Create> createState() => _CreateState();
}

// Future<void> _pickImage() async {
//   final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

//   setState(() {
//     if (pickedFile != null) {
//       _image = File(pickedFile.path);
//     }
//   });
// }
class _CreateState extends State<Create> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

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

  Future<void> _save() async {
    final name = _nameController.text;
    final phone = _phoneController.text;
    final email = _emailController.text;

    if (name.isNotEmpty &&
        email.isNotEmpty &&
        phone.isNotEmpty &&
        _image != null) {
      setState(() {
        _isUploading = true;
      });
      try {
        String fileName =
            'images/${DateTime.now().millisecondsSinceEpoch.toString()}.jpg';
        Reference storageReference =
            FirebaseStorage.instance.ref().child(fileName);
        UploadTask uploadTask = storageReference.putFile(_image!);
        TaskSnapshot taskSnapshot = await uploadTask;

        String downloadUrl = await taskSnapshot.ref.getDownloadURL();

        await FirebaseFirestore.instance.collection('Contacts').add({
          'name': name,
          'email': email,
          'phone': phone,
          'image': downloadUrl,
        });
        setState(() {
          _isUploading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Data added successfully!')),
        );
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => Home(index: 2,),
            ),
            (_) => false);
      } catch (e) {
        setState(() {
          _isUploading = false;
        });
        print(e);
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
              'Create',
              style: TextStyle(
                fontSize: 20,
              ),
            ),
            Row(children: [
              _isUploading
                  ? CircularProgressIndicator()
                  : TextButton(
                      onPressed: _save,
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
                      child: Icon(
                        Icons.add_photo_alternate_outlined,
                        size: 70,
                      ),
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
                    decoration: InputDecoration(hintText: 'Name')),
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
