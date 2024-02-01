

import 'package:chat_app/screens/home.dart';
import 'package:chat_app/utils/snackbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthMethods{
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore=FirebaseFirestore.instance;

 Future<String>  signup({
    required String email,required String username,required String password ,required BuildContext context
  })async{
     String res ='some error occured';
    if(email.isNotEmpty && password.isNotEmpty && username.isNotEmpty){
     
      try{
       UserCredential cred =  await _auth.createUserWithEmailAndPassword(email: email, password: password);
        await _firestore.collection('User').doc(cred.user!.uid).set({
          'email':email,
          'password':password,
          'username':username,
          'bio':'hey I\'m using chat',
          'uid':cred.user!.uid,
          'createdAt':DateTime.now().millisecondsSinceEpoch,
          'isOnline':false,
          'lastActive':'',
          'imageUrl':'https://img.freepik.com/premium-vector/icon-man-s-face-with-light-skin_238404-1006.jpg?w=826',
        });
        // await FirestoreMethods().UploadUser(username: username, email: email);
        res ='success';
        // ignore: use_build_context_synchronously
        showSnackbar(context, 'Signup success');
      }catch(err){
        res = err.toString();
      }
    } else{
      showSnackbar(context, 'Please enter all the fields');
    }
    return res;
  }

   Future<String>  login({
    required String email,required String password ,required BuildContext context
  })async{
     String res ='some error occured';
    if(email.isNotEmpty && password.isNotEmpty ){
     await _auth.signInWithEmailAndPassword(email: email, password: password);
     res=='success';}

    //   try{
        // await _auth.signInWithEmailAndPassword(email: email, password: password);
    //     res ='success';
    //     showSnackbar(context, 'Login success');
    //   }catch(err){
    //     res = err.toString();
    //   }
    // }
     else{
      showSnackbar(context, 'Please enter all the fields');
    }
    return res;
  }

  Future<String> logout()async{
    String res = 'some error occured';
    await _auth.signOut();
  res ='success';
  return res;
  }
 checkUser(){
    if(_auth.currentUser!=null){
     return const HomeScreen();
    } else{
      // return LoginScreen();
    }
  }
}