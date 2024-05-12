import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:appwrite/appwrite.dart';
import 'package:major_project/appwrite/auth_api.dart';
import '../../../constants.dart';
import 'home_page.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {

  TextEditingController _emailController = TextEditingController();
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  createAccount() async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Dialog(
            backgroundColor: Colors.transparent,
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: const [
                  CircularProgressIndicator(),
                ]),
          );
        });
    try {
      final AuthAPI appwrite = context.read<AuthAPI>();
      await appwrite.createUser(
        username: _usernameController.text,
        email: _emailController.text,
        password: _passwordController.text,
      );
      Navigator.pop(context);
      const snackbar = SnackBar(content: Text('Account created!'));
      ScaffoldMessenger.of(context).showSnackBar(snackbar);
    } on AppwriteException catch (e) {
      Navigator.pop(context);
      showAlert(title: 'Account creation failed', text: e.message.toString());
    }
  }

  showAlert({required String title, required String text}) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(title),
            content: Text(text),
            actions: [
              ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Ok'))
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: canvasColor,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                height: MediaQuery.of(context).size.height*0.2,
                width: MediaQuery.of(context).size.height,
                decoration: BoxDecoration(
                    image: DecorationImage(image: AssetImage("assets/logo.png"),)
                ),
              ),
              Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: scaffoldBackgroundColor, // Color(0xff726f82),
                  borderRadius: BorderRadius.circular(12),
                ),
                width: MediaQuery.of(context).size.width * 0.3,
                height: MediaQuery.of(context).size.height * 0.5,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children:
                  [
                    Center(
                        child: Text("SIGN UP", style: TextStyle(fontSize: 20,color: canvasColor))),
                    TextField(
                      controller: _usernameController,
                      style: TextStyle(color: canvasColor),
                      decoration: InputDecoration(
                          labelText: 'User Name',
                          labelStyle: TextStyle(color: canvasColor),
                          hoverColor: canvasColor,
                          hintText: "Enter your username",
                          hintStyle: TextStyle(fontSize: 7,color: canvasColor)),
                    ),
                    TextField(
                      controller: _emailController,
                      style: TextStyle(color: canvasColor),
                      decoration: InputDecoration(
                          labelText: 'Email',
                          labelStyle: TextStyle(color: canvasColor),
                          hoverColor: canvasColor,
                          hintText: "Enter your email address",
                          hintStyle: TextStyle(fontSize: 7,color: canvasColor)),
                    ),
                    TextField(
                      controller: _passwordController,
                      style: TextStyle(color: canvasColor),
                      decoration: InputDecoration(
                          labelText: 'Password',
                          labelStyle: TextStyle(color: canvasColor),
                          hintText: "Enter your password",
                          hintStyle: TextStyle(fontSize: 7,color: canvasColor)),
                      obscureText: true,
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor:
                          MaterialStatePropertyAll(canvasColor),
                          shape: MaterialStatePropertyAll(
                              RoundedRectangleBorder(
                                  borderRadius:
                                  BorderRadius.all(Radius.circular(7))))),
                      onPressed: () {
                        createAccount();
                        Navigator.pushReplacement<void, void>(
                          context,
                          MaterialPageRoute<void>(
                            builder: (BuildContext context) => const HomePage(),
                          ),
                        );
                      },
                      child: Text('SIGN UP'),
                    ),
                    SizedBox(height: 10),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Already have an account?",
                          style: TextStyle(fontSize: 10,color: Colors.black45),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text(
                            "Log In",
                            style: TextStyle(fontSize: 10,color: canvasColor),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
