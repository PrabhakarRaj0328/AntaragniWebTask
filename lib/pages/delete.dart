import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';


class Delete {

static Future<void> delete({ required String id,
required String url}) async{
try{
  Reference storageReference = FirebaseStorage.instance.refFromURL(url);
  await storageReference.delete();
  await FirebaseFirestore.instance.collection('Contacts').doc(id).delete();
  print('Contact Deleted');
  
}
catch(e){
  print('$e');
}
}


}