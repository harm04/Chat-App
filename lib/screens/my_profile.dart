import 'dart:typed_data';

import 'package:chat_app/methods/firestoremethods.dart';
import 'package:chat_app/models/chatuser.dart';
import 'package:chat_app/utils/pick_image.dart';
import 'package:chat_app/utils/snackbar.dart';
import 'package:chat_app/widgets/custom_button.dart';
import 'package:chat_app/widgets/custom_textfield.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ProfileScreen extends StatefulWidget {
  final ChatUser user;
  const ProfileScreen({super.key, required this.user});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final TextEditingController biocontroller = TextEditingController();
  final TextEditingController usernamecontroller = TextEditingController();
  bool isLoading = false;
  final _formkey = GlobalKey<FormState>();

  @override
  void dispose() {
    biocontroller.dispose();
    usernamecontroller.dispose();
    super.dispose();
  }

  Uint8List? image;
  void selectImage() async {
    Uint8List img = await pickImage(ImageSource.gallery);
    setState(() {
      image = img;
    });
  }
  

  void uploadImage() async {
    if (image != null) {
      setState(() {
        isLoading = true;
      });
      String res = await FirestoreMethods().UploadDatatoFirestore(file: image);
      if (res == 'success') {
        setState(() {
          isLoading = false;
        });
        // ignore: use_build_context_synchronously
        
      } else {
        showSnackbar(context, res);
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  void updateData() async {
    setState(() {
      isLoading = true;
    });
    String res = await FirestoreMethods().updateData();
    if (res == 'success') {
      setState(() {
        isLoading = false;
      });
      showSnackbar(context, 'updated');
    } else {
      setState(() {
        isLoading = false;
      });
      showSnackbar(context, res);
    }
  }

  @override
  Widget build(BuildContext context) {
    setState(() {
      usernamecontroller.text = widget.user.username;
      biocontroller.text = widget.user.bio;
    });

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
                child: Form(
                  key: _formkey,
                  child: Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(
                          height: 10,
                        ),
                        Stack(
                          children: [
                            widget.user.imageUrl != '' && image==null
                                ? GestureDetector(
                                  onTap: () {
                                     showDialog(
                              context: context,
                              builder: (context) {
                                return SizedBox(
                                  height: 300,
                                  child: Center(
                                    child: Image.network(
                                        widget.user.imageUrl),
                                  ),
                                );
                              },
                            );
                                  },
                                  child: CircleAvatar(
                                      radius: 75,
                                      backgroundImage:
                                          NetworkImage(widget.user.imageUrl),
                                    ),
                                )
                                :  CircleAvatar(
                                    radius: 75,
                                    backgroundImage: MemoryImage(image!),
                                  ),
                            Positioned(
                              left: 70,
                              bottom: -9,
                              child: IconButton(
                                  onPressed: () {
                                    selectImage();
                                  },
                                  icon: const Icon(
                                    Icons.add_a_photo,
                                    size: 50,
                                    color: Colors.yellow,
                                  )),
                            )
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Text(
                          widget.user.username,
                          style: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Text(
                          widget.user.bio,
                          style: const TextStyle(
                            fontSize: 15,
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        CustomTextfield(
                            onsaved: (value) =>
                                FirestoreMethods.me.username = value ?? '',
                            validator: (value) =>
                                value != null && value.isNotEmpty
                                    ? null
                                    : 'enter all the fields',
                            hinttext: 'enter username',
                            label: const Text('Username'),
                            isobscureText: false,
                            controller: usernamecontroller,
                            icon: Icons.person),
                        const SizedBox(
                          height: 20,
                        ),
                        CustomTextfield(
                            onsaved: (value) =>
                                FirestoreMethods.me.bio = value ?? '',
                            validator: (value) =>
                                value != null && value.isNotEmpty
                                    ? null
                                    : 'enter all the fields',
                            hinttext: 'enter bio',
                            label: const Text('bio'),
                            isobscureText: false,
                            controller: biocontroller,
                            icon: Icons.document_scanner),
                        const SizedBox(
                          height: 20,
                        ),
                        InkWell(
                          onTap: () {
                            if (_formkey.currentState!.validate()) {
                              _formkey.currentState!.save();
                             
                              uploadImage();
                              updateData();
                            }
                          },
                          child: const CustomButton(
                              height: 50,
                              width: double.infinity,
                              text: 'Update profile'),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
  }
}
