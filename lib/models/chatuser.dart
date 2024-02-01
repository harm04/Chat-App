class ChatUser{
  ChatUser({
    required this.email,
    required this.username,
    required this.uid,
    required this.imageUrl,
    required this.bio,
    required this.createdAt,
    required this.isOnline,
    required this.lastActive,
    required this.pushToken,
  });
  late  String email;
  late  String username;
  late  String uid;
  late  String imageUrl;
  late  String bio;
  late  var createdAt;
  late  bool isOnline;
  late  String lastActive;
  late String pushToken;

  ChatUser.fromJson(Map<String,dynamic>json){
    email=json['email']??' ';
    username=json['username']??' ';
    uid =json['uid']??' ';
    imageUrl=json['imageUrl']??'https://img.freepik.com/premium-vector/icon-man-s-face-with-light-skin_238404-1006.jpg?w=826';
    bio=json['bio']??'Hello I\'m using Chat';
    createdAt=json['createdAt']??'';
    isOnline=json['isOnline']??'';
    lastActive=json['lastActive']??' ';
    pushToken=json['pushToken']??' ';
  }
  Map<String,dynamic>toJson(){
    final data = <String ,dynamic>{};
    data['username']=username;
    data['email']=email;
    data['uid']=uid;
    data['bio']=bio;
    data['imageUrl']=imageUrl;
     data['createdAt']=createdAt;
      data['isOnline']=isOnline;
       data['lastActive']=lastActive;
       data['pushToken']=pushToken;
    return data;
  }
}