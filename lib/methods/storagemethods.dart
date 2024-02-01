// import 'dart:typed_data';

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_storage/firebase_storage.dart';

// FirebaseStorage _storage = FirebaseStorage.instance;
// FirebaseFirestore _firestore = FirebaseFirestore.instance;
// String uid =FirebaseAuth.instance.currentUser!.uid;
// class StorageMethods{
//   Future<String> uploadImagetoStorage(String childName,Uint8List file)async {
// Reference ref= _storage.ref().child(childName);
// UploadTask uploadTask =ref.putData(file);
// TaskSnapshot snapshot = await uploadTask;
// String downloadUrl = await snapshot.ref.getDownloadURL();
// return downloadUrl;
//   }

//   Future<String>UploadDatatoFirestore({
//     required String username,required String bio, Uint8List? file
//   })async{
//      String res='some error occured';
// try{
//  String imageUrl='';
//  imageUrl= await uploadImagetoStorage('ProfileImg', file!);
// await _firestore.collection('User').doc(uid).update({
//     'username':username,
//   'bio':bio,
//   'imageUrl':imageUrl,
//   'uid':uid
// });
// res ='success';
// } catch(err){
//   res =err.toString();
// }
// return res;
//   }
// }