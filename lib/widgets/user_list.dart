import 'package:chat_app/methods/firestoremethods.dart';
import 'package:chat_app/models/chatuser.dart';
import 'package:chat_app/models/message.dart';
import 'package:chat_app/screens/chat_screen.dart';
import 'package:chat_app/widgets/formated_date.dart';
import 'package:flutter/material.dart';

class UserCard extends StatefulWidget {
  final ChatUser user;
  const UserCard({super.key, required this.user});

  @override
  State<UserCard> createState() => _UserCardState();
}

class _UserCardState extends State<UserCard> {
  Message? _message;
  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color.fromARGB(255, 198, 226, 224),
      child: InkWell(
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return ChatSCreen(
                user: widget.user,
              );
            }));
          },
          child: StreamBuilder(
            stream: FirestoreMethods.getLastMessages(widget.user),
            builder: ((context, snapshot) {
              final data = snapshot.data?.docs;
              final _list =
                  data?.map((e) => Message.fromJson(e.data())).toList() ?? [];
              if (_list.isNotEmpty) {
                _message = _list[0];
              }
              return ListTile(
                title: Text(
                  widget.user.username,
                  style: const TextStyle(color: Colors.black),
                ),
                leading: widget.user.imageUrl != ''
                    ? GestureDetector(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return SizedBox(
                                height: 300,
                                child: Center(
                                  child: Image.network(widget.user.imageUrl),
                                ),
                              );
                            },
                          );
                        },
                        child: GestureDetector(
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return Container(
                                  height: 300,
                                  child: Center(
                                    child: Image.network(
                                        'https://img.freepik.com/premium-vector/icon-man-s-face-with-light-skin_238404-1006.jpg?w=826'),
                                  ),
                                );
                              },
                            );
                          },
                          child: CircleAvatar(
                            backgroundImage: NetworkImage(widget.user.imageUrl),
                            radius: 35,
                          ),
                        ),
                      )
                    : const CircleAvatar(
                        backgroundImage: NetworkImage(
                            'https://img.freepik.com/premium-vector/icon-man-s-face-with-light-skin_238404-1006.jpg?w=826'),
                        radius: 35,
                      ),
                subtitle: Text(
                  _message != null
                      ? _message!.type == Type.image
                          ? 'image'
                          : _message!.message
                      : widget.user.bio,
                  style: const TextStyle(color: Colors.grey),
                ),
                trailing: _message == null
                    ? null
                    : _message!.read.isEmpty &&
                            _message!.fromId != FirestoreMethods.user.uid
                        ? Container(
                            width: 15,
                            height: 15,
                            decoration: const BoxDecoration(
                                borderRadius: BorderRadius.all(
                                    const Radius.circular(100)),
                                color: Colors.green),
                          )
                        : Text(
                            formatedDate.getLastMessageTime(
                                context: context, time: _message!.sent),
                            style: TextStyle(color: Colors.grey),
                          ),
              );
            }),
          )),
    );
  }
}
