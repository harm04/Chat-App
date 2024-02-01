import 'package:chat_app/methods/firestoremethods.dart';
import 'package:chat_app/models/chatuser.dart';
import 'package:chat_app/screens/my_profile.dart';

import 'package:chat_app/widgets/user_list.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isLoading = false;
  bool isSearching = false;
  List<ChatUser> _list = [];
  final List<ChatUser> _searchList = [];

  @override
  void initState() {
    super.initState();
 FirestoreMethods().getSelfInfo();
    SystemChannels.lifecycle.setMessageHandler((message) {
      if (FirestoreMethods.user != null) {
        if (message.toString().contains('resume')) {
          FirestoreMethods().updateActiveStatus(true);
        }
        if (message.toString().contains('pause')) {
          FirestoreMethods().updateActiveStatus(false);
        }
      }
      return Future.value(message);
    });
   
  }

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
                centerTitle: false,
                title: isSearching
                    ? TextField(
                        decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Search Username,email'),
                        onChanged: (value) {
                          _searchList.clear();
                          for (var i in _list) {
                            if (i.username
                                    .toLowerCase()
                                    .contains(value.toLowerCase()) ||
                                i.email
                                    .toLowerCase()
                                    .contains(value.toLowerCase())) {
                              _searchList.add(i);
                            }
                            setState(() {
                              _searchList;
                            });
                          }
                        },
                        autofocus: true,
                      )
                    : const Text(
                        'Chat App',
                        style: TextStyle(
                            letterSpacing: 3,
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                            fontSize: 30),
                      ),
                automaticallyImplyLeading: false,
                backgroundColor: Colors.black,
                leading: isSearching
                    ? IconButton(
                        onPressed: () {
                          Navigator.pushReplacement(context,
                              MaterialPageRoute(builder: (context) {
                            return const HomeScreen();
                          }));
                        },
                        icon: const Icon(Icons.arrow_back))
                    : Container(
                        width: 0,
                      ),
                actions: [
                  IconButton(
                      onPressed: () {
                        setState(() {
                          isSearching = !isSearching;
                        });
                      },
                      icon: isSearching
                          ? const Icon(Icons.cancel)
                          : const Icon(Icons.search)),
                  IconButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ProfileScreen(
                                      user: FirestoreMethods.me,
                                    )));
                      },
                      icon: const Icon(Icons.person)),
                ],
              ),
              body: StreamBuilder(
                  stream: FirestoreMethods.getAllUsers(),
                  builder: (context, snapshot) {
                    //
                    switch (snapshot.connectionState) {
                      case ConnectionState.waiting:
                      case ConnectionState.none:
                        return const Center(child: CircularProgressIndicator());
                      case ConnectionState.active:
                      case ConnectionState.done:
                        final data = snapshot.data?.docs;
                        _list = data
                                ?.map((e) => ChatUser.fromJson(e.data()))
                                .toList() ??
                            [];
                        if (_list.isNotEmpty) {
                          return ListView.builder(
                            itemBuilder: ((context, index) {
                              return UserCard(
                                  user: isSearching
                                      ? _searchList[index]
                                      : _list[index]);
                            }),
                            physics: const BouncingScrollPhysics(),
                            itemCount:
                                isSearching ? _searchList.length : _list.length,
                          );
                        } else {
                          return const Center(
                            child: Text(
                              'No user found',
                              style:
                                  TextStyle(color: Colors.grey, fontSize: 20),
                            ),
                          );
                        }
                    }
                  }),
            ),
          );
  }
}
