import 'package:flutter/material.dart';
import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart' as models;
import 'package:major_project/appwrite/auth_api.dart';
import 'package:major_project/constants.dart';
import 'package:major_project/core/presentation/pages/onbording_page.dart';
import 'package:provider/provider.dart';
import 'signup_page.dart';
import 'home_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  models.User? loggedInUser;

  late TextEditingController _emailController, _passwordController;
  bool loading = false;

  signIn() async {
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
      await appwrite.createEmailSession(
        email: _emailController.text,
        password: _passwordController.text,
      );
      Navigator.pop(context);
    } on AppwriteException catch (e) {
      Navigator.pop(context);
      showAlert(title: 'Login failed', text: e.message.toString());
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
  void initState() {
    // TODO: implement initState
    super.initState();

    _passwordController = TextEditingController();
    _emailController = TextEditingController();
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
                height: MediaQuery.of(context).size.height * 0.45,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Center(
                        child: Text("LOGIN", style: TextStyle(fontSize: 20,color: canvasColor))),
                    TextField(
                      controller: _emailController,
                      style: TextStyle(color: canvasColor),
                      decoration: InputDecoration(
                          labelText: 'Email',
                          labelStyle: TextStyle(color: canvasColor),
                          hoverColor: canvasColor,
                          hintText: "Enter your email address",
                          hintStyle: TextStyle(fontSize: 12,color: canvasColor)),
                    ),
                    TextField(
                      controller: _passwordController,
                      style: TextStyle(color: canvasColor),
                      decoration: InputDecoration(
                          labelText: 'Password',
                          labelStyle: TextStyle(color: canvasColor),
                          hintText: "Enter your password",
                          hintStyle: TextStyle(fontSize: 12,color: canvasColor)),
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
                        signIn();
                        Navigator.pushReplacement<void, void>(
                          context,
                          MaterialPageRoute<void>(
                            builder: (BuildContext context) =>
                                const OnboardingPage(),
                          ),
                        );
                      },
                      child: Text(
                        'LOG IN',
                        style: TextStyle(color: scaffoldBackgroundColor, fontSize: 13),
                      ),
                    ),
                    SizedBox(height: 10),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Don't Have an account yet?",
                          style: TextStyle(fontSize: 10,color: Colors.black45),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        const SignupPage()));
                          },
                          child: Text(
                            "Sign Up",
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
