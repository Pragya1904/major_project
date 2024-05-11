import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:appwrite/appwrite.dart';
import 'package:major_project/appwrite/auth_api.dart';
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
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Container(
            width: MediaQuery.of(context).size.width * 0.3,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextField(
                  controller: _usernameController,
                  decoration: InputDecoration(labelText: 'Username'),
                ),
                TextField(
                  controller: _emailController,
                  decoration: InputDecoration(labelText: 'Email'),
                ),
                TextField(
                  controller: _passwordController,
                  decoration: InputDecoration(labelText: 'Password'),
                  obscureText: true,
                ),
                SizedBox(height: 20),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text("Already have an account? Log In"),
                ),
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    createAccount();
                    Navigator.pushReplacement<void, void>(
                      context,
                      MaterialPageRoute<void>(
                        builder: (BuildContext context) => const HomePage(),
                      ),
                    );
                  },
                  child: Text('SignUp'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
