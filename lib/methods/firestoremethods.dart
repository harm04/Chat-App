import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:chat_app/models/chatuser.dart';
import 'package:chat_app/models/message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:http/http.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;
final String uid = FirebaseAuth.instance.currentUser!.uid;
final FirebaseAuth _auth = FirebaseAuth.instance;

class FirestoreMethods {
//   Future<void> UploadUser({
//     required String username,required String email,
//   })async{
// _firestore.collection('User').doc(username).set({
//   'username':username,
//   'email':email,
//   'uid':uid,
//   'profImg':'',
//   'bio':''
// });
//   }
  static  ChatUser me= ChatUser(
      uid: user.uid,
      username: user.displayName.toString(),
      email: user.email.toString(),
      bio: "Hey, I'm using We Chat!",
      imageUrl: user.photoURL.toString(),
      createdAt: '',
      isOnline: false,
      lastActive: '',
      pushToken: ''
      );
   Future<void> getSelfInfo() async {
    await _firestore.collection('User').doc(uid).get().then((uid) async {
      if (uid.exists) {
        
        me = ChatUser.fromJson(uid.data()!);
       await firebaseMessagingToken();
    
        updateActiveStatus(true);
      }
    });
  }


  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<String> uploadImagetoStorage(
    String childName,
    Uint8List file,
  ) async {
    Reference ref = _storage.ref().child(childName).child(uid);
    UploadTask uploadTask = ref.putData(file);
    TaskSnapshot snapshot = await uploadTask;
    String downloadUrl = await snapshot.ref.getDownloadURL();
    return downloadUrl;
  }

  // ignore: non_constant_identifier_names
  Future<String> UploadDatatoFirestore({Uint8List? file}) async {
    String res = 'some error occured';
    try {
      String imageUrl = '';
      imageUrl = await uploadImagetoStorage('ProfileImg', file!);
      await _firestore.collection('User').doc(uid).update({
        'imageUrl': imageUrl,
      });
      res = 'success';
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<String> updateData() async {
    String res = 'some error occured';
    try {
      await _firestore.collection('User').doc(uid).update({
        'username': me.username,
        'bio': me.bio,
      });
      res = 'success';
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  static FirebaseMessaging fMessaging = FirebaseMessaging.instance;
   Future<void> firebaseMessagingToken() async {
    await fMessaging.requestPermission();
    await fMessaging.getToken().then((token){
      if(token!=null){
        me.pushToken=token;
        print('pushtoken =${token}');
      }
    } );
  }

  Future<void> sendPushNotification(
      ChatUser chatUser, String msg) async {
    try {
      final body = {
        "to": chatUser.pushToken,
        "notification": {
          "title": me.username,
          "body": msg,
          "android_channel_id": "chats"
        },
        
      };

      var res = await post(Uri.parse('https://fcm.googleapis.com/fcm/send'),
          headers: {
            HttpHeaders.contentTypeHeader: 'application/json',
            HttpHeaders.authorizationHeader:
                'key=AAAABC7LDlk:APA91bHMemrqCECSM6hlxYpD4aa1V-IZscnswGJS_U16Prg1ll2gN8IxQdgglM6Xav7I1zyOVAdw5fe6yUTZcC_kChlbsC0CgojOUD3UzTLAFf8iei-F-2EAITJyU4ZOXxiAAyMEoHFE'
          },
          body: jsonEncode(body));
      print('Response status: ${res.statusCode}');
      print('Response body: ${res.body}');
    } catch (e) {
      print('\nsendPushNotificationE: $e');
    }
  }

  static User get user => _auth.currentUser!;

  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllUsers() {
    return _firestore
        .collection('User')
        .where('uid', isNotEqualTo: uid)
        .snapshots();
  }
 

  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllMessages(
      ChatUser user) {
    return _firestore
        .collection('chats/${getConversationId(user.uid)}/Messages/')
        .orderBy('sent', descending: true)
        .snapshots();
  }

  static String getConversationId(String id) => user.uid.hashCode <= id.hashCode
      ? '${user.uid}_$id'
      : '${id}_${user.uid}';

   Future<void> sendMessage(
      ChatUser chatUser, String msg, Type type) async {
    final time = DateTime.now().millisecondsSinceEpoch.toString();

    final Message message = Message(
        toId: chatUser.uid,
        message: msg,
        read: '',
        type: type,
        fromId: user.uid,
        sent: time);

    final ref = _firestore
        .collection('chats/${getConversationId(chatUser.uid)}/Messages/');
    await ref.doc(time).set(message.toJson()).then((value) {
      sendPushNotification(chatUser,type==Type.text? msg:'image');
    });
    //
  }

  static Future<void> updateReadMessage(Message message) async {
    _firestore
        .collection('chats/${getConversationId(message.fromId)}/Messages/')
        .doc(message.sent)
        .update({'read': DateTime.now().microsecondsSinceEpoch.toString()});
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getLastMessages(
      ChatUser user) {
    return _firestore
        .collection('chats/${getConversationId(user.uid)}/Messages/')
        .orderBy('sent', descending: true)
        .limit(1)
        .snapshots();
  }

  Future<void> sendChatImage(ChatUser chatUser, File file) async {
    final ext = file.path.split('.').last;
    Reference ref = _storage.ref().child(
        'Images/${getConversationId(chatUser.uid)}/${DateTime.now().millisecondsSinceEpoch}.$ext');
    await ref
        .putFile(file, SettableMetadata(contentType: 'Images/$ext'))
        // ignore: avoid_print
        .then((p0) => print('dta transfred :${p0.bytesTransferred / 1000}kb'));
    final imgUrl = await ref.getDownloadURL();
    await sendMessage(chatUser, imgUrl, Type.image);
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getUserInfo(
      ChatUser chatUser) {
    return _firestore
        .collection('User')
        .where('uid', isEqualTo: chatUser.uid)
        .snapshots();
  }

  Future<void> updateActiveStatus(bool isOnline) async {
    _firestore.collection('User').doc(user.uid).update({
      'isOnline': isOnline,
      'lastActive': DateTime.now().millisecondsSinceEpoch.toString(),
      'pushToken': me.pushToken,
    });
  }
}
