import 'dart:io';

import 'package:chat_app/methods/firestoremethods.dart';
import 'package:chat_app/models/chatuser.dart';
import 'package:chat_app/models/message.dart';
import 'package:chat_app/screens/user_profile.dart';
import 'package:chat_app/widgets/formated_date.dart';
import 'package:chat_app/widgets/messageCard.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ChatSCreen extends StatefulWidget {
  final ChatUser user;
  const ChatSCreen({super.key, required this.user});

  @override
  _ChatSCreenState createState() => _ChatSCreenState();
}

class _ChatSCreenState extends State<ChatSCreen> {
  final TextEditingController _textcontroller = TextEditingController();
  bool _showEmoji = false;
  bool isUploading = false;

  List<Message> _list = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor: Colors.black,
        // centerTitle: false,
        automaticallyImplyLeading: true,
        title: GestureDetector(
          onTap: ()=> Navigator.push(context, MaterialPageRoute(builder: (context)=>UserProfileScreen(user: widget.user))),
          child: StreamBuilder(
              stream: FirestoreMethods.getUserInfo(widget.user),
              builder: (context, snapshot) {
                final data = snapshot.data?.docs;
                final _list =
                    data?.map((e) => ChatUser.fromJson(e.data())).toList() ?? [];
                return Row(
                  children: [
                    CircleAvatar(
                      radius: 22,
                      backgroundImage: _list.isNotEmpty
                          ? NetworkImage(_list[0].imageUrl)
                          : NetworkImage(widget.user.imageUrl),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _list.isNotEmpty
                            ? Text(_list[0].username)
                            : Text(widget.user.username),
                        Text(
                       _list.isNotEmpty?_list[0].isOnline?'Online': formatedDate.getlastActiveTime(context: context, lastActive: _list[0].lastActive):formatedDate.getlastActiveTime(context: context, lastActive: widget.user.lastActive),
                          style:
                              const TextStyle(color: Colors.grey, fontSize: 14),
                        )
                      ],
                    ),
                  ],
                );
              }),
        ),
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SafeArea(
          child: StreamBuilder(
              stream: FirestoreMethods.getAllMessages(widget.user),
              builder: (context, snapshot) {
                final data = snapshot.data?.docs;
                _list =
                    data?.map((e) => Message.fromJson(e.data())).toList() ?? [];
                return Column(
                  children: [
                    Expanded(
                      child: Align(
                        alignment: Alignment.topCenter,
                        child: ListView.builder(
                          reverse: true,
                          itemCount: _list.length,
                          physics: const BouncingScrollPhysics(),
                          itemBuilder: (context, index) {
                            return MessageCard(message: _list[index]);
                          },
                        ),
                      ),
                    ),
                    isUploading
                        ? const CircularProgressIndicator()
                        : const SizedBox(),
                    bottomwidget(),
                    const SizedBox(
                      height: 10,
                    ),
                    if (_showEmoji)
                      SizedBox(
                        height: MediaQuery.of(context).size.height * .35,
                        child: EmojiPicker(
                          textEditingController: _textcontroller,
                          config: Config(
                            bgColor: const Color.fromARGB(255, 237, 249, 255),
                            columns: 8,
                            emojiSizeMax: 32 * (Platform.isIOS ? 1.30 : 1.0),
                          ),
                        ),
                      )
                  ],
                );
              }),
        ),
      ),
    );
  }

  bottomwidget() {
    return Row(
      children: [
        Expanded(
          child: Card(
            color: const Color.fromARGB(255, 63, 62, 62),
            child: Row(
              children: [
                IconButton(
                    onPressed: () {
                      FocusScope.of(context).unfocus();
                      setState(() {
                        _showEmoji = !_showEmoji;
                      });
                    },
                    icon: const Icon(
                      Icons.emoji_emotions,
                      size: 28,
                    )),
                Expanded(
                    child: TextField(
                  onTap: () {
                    if (_showEmoji)
                      setState(() {
                        _showEmoji = !_showEmoji;
                      });
                  },
                  controller: _textcontroller,
                  maxLines: null,
                  autofocus: true,
                  decoration: const InputDecoration(
                    hintText: 'Message',
                    border: InputBorder.none,
                  ),
                )),
                IconButton(
                    onPressed: () async {
                      final ImagePicker picker = ImagePicker();
                      final List<XFile> images =
                          await picker.pickMultiImage(imageQuality: 70);
                      setState(() {
                        isUploading = true;
                      });
                      for (var i in images) {
                        await FirestoreMethods()
                            .sendChatImage(widget.user, File(i.path));
                      }
                      setState(() {
                        isUploading = false;
                      });
                    },
                    icon: const Icon(
                      Icons.image,
                      size: 28,
                    )),
                IconButton(
                    onPressed: () async {
                      final ImagePicker picker = ImagePicker();
                      final XFile? image = await picker.pickImage(
                          source: ImageSource.camera, imageQuality: 70);
                      if (image != null) {
                        setState(() {
                          isUploading = true;
                        });
                        await FirestoreMethods()
                            .sendChatImage(widget.user, File(image.path));
                        setState(() {
                          isUploading = false;
                        });
                      }
                    },
                    icon: const Icon(
                      Icons.camera_alt,
                      size: 28,
                    )),
              ],
            ),
          ),
        ),
        MaterialButton(
            onPressed: () {
              if (_textcontroller.text.isNotEmpty) {
                FirestoreMethods().sendMessage(
                    widget.user, _textcontroller.text, Type.text);
                _textcontroller.text = '';
              }
            },
            minWidth: 0,
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
            shape: const CircleBorder(),
            color: Colors.green,
            child: const Icon(
              Icons.send,
              size: 28,
              color: Colors.white,
            )),
      ],
    );
  }
}

class ChatMessage {
  String text;
  String sender;

  ChatMessage({required this.text, required this.sender});
}
