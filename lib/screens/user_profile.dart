import 'package:chat_app/models/chatuser.dart';
import 'package:chat_app/screens/chat_screen.dart';
import 'package:chat_app/widgets/custom_button.dart';
import 'package:chat_app/widgets/formated_date.dart';
import 'package:flutter/material.dart';

class UserProfileScreen extends StatefulWidget {
  final ChatUser user;
  const UserProfileScreen({super.key, required this.user});

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: Scaffold(
              backgroundColor: Colors.black,
              appBar: AppBar(
                automaticallyImplyLeading: true,
                backgroundColor: Colors.black,
              ),
              body: SingleChildScrollView(
                child: Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                   
                      const SizedBox(
                        height: 10,
                      ),
                      GestureDetector(
                        onTap: (){
                           showDialog(
                context: context,
                builder: (context) {
                  return Container(
                    height: 300,
                    child: Center(
                      child:Image.network(widget.user.imageUrl),
                    ),
                  );
                },
              );
                        },
                        child: CircleAvatar(
                          radius: 75,
                          backgroundImage: NetworkImage(widget.user.imageUrl),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Text(
                        widget.user.username,
                        style: const TextStyle(
                            fontSize: 30, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Text(
                        widget.user.bio,
                        style: const TextStyle(
                          fontSize: 20,
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      InkWell(
                          onTap: () => Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      ChatSCreen(user: widget.user))),
                          child: const CustomButton(
                              height: 50, width: 100, text: 'Message')),
                             SizedBox(height: 30,),
                             Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text('Joined on ',),
                                // SizedBox(width: 10,),
                                Text(formatedDate.getLastMessageTime(context: context,year: true, time: widget.user.createdAt.toString()))
                              ],
                             )
                               
                    ],
                  ),
                ),
              ),
            ),
          );
  }
}
