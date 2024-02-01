import 'package:chat_app/methods/authmethods.dart';

import 'package:chat_app/screens/home.dart';
import 'package:chat_app/utils/snackbar.dart';
import 'package:chat_app/widgets/custom_button.dart';
import 'package:chat_app/widgets/custom_textfield.dart';
import 'package:flutter/material.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController emailcontroller = TextEditingController();
  final TextEditingController passwordcontroller = TextEditingController();
  final TextEditingController usernamecontroller = TextEditingController();
  bool isLoading=false;

  @override
  void dispose() {
    emailcontroller.dispose();
    passwordcontroller.dispose();
    usernamecontroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return isLoading?const Center(
      child: CircularProgressIndicator()
    ) :GestureDetector(
      onTap: ()=>FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: Colors.black,
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 70,),
              Center(
                child: Image.asset(
                  'assets/images/chat.png',
                  height: 150,
                ),
              ),
              const Text(
                'Chat App',
                style: TextStyle(
                    color: Colors.white, fontSize: 48, fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 35,
              ),
              CustomTextfield(
                hinttext: 'enter your email',
                controller: emailcontroller,
                isobscureText: false,
                icon: Icons.person,
              ),
              const SizedBox(
                height: 10,
              ),
              CustomTextfield(
                hinttext: 'enter your password',
                controller: passwordcontroller,
                isobscureText: true,
                icon: Icons.password,
              ),
              const SizedBox(
                height: 10,
              ),
              CustomTextfield(
                hinttext: 'enter your username',
                controller: usernamecontroller,
                isobscureText: false,
                icon: Icons.people,
              ),
              const SizedBox(
                height: 10,
              ),
             
              const SizedBox(
                height: 20,
              ),
              InkWell(
                onTap: ()async{
                  setState(() {
                    isLoading=true;
                  });
                 String res =await AuthMethods().signup(email: emailcontroller.text, username: usernamecontroller.text, password: passwordcontroller.text, context: context);
                  setState(() {
                    isLoading=false;
                  });
                  if(res=='success'){
                    
                      // ignore: use_build_context_synchronously
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context){
                    return const HomeScreen();
                  }
                  ));
                  } else{
                    showSnackbar(context, res);
                  }
                },
                child: const CustomButton(
                    height: 50, width: double.infinity, text: 'Sign up'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}