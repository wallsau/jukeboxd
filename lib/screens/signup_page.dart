import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:jukeboxd/utils/colors.dart';
import 'package:jukeboxd/utils/validation.dart';

//Signup Page contributed by Austin Walls
class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final nameController = TextEditingController();
  final passwordController = TextEditingController();
  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  String errorMessage = '';
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    var db = FirebaseFirestore.instance;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Create an Account',
          style: TextStyle(fontSize: 30),
        ),
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
          TextEditingController().clear();
        },
        child: Form(
          key: _key,
          child: ListView(children: <Widget>[
            Center(
              child: Image.asset('images/jukeboxd.jpg'),
            ),
            Container(
              padding: const EdgeInsets.all(10),
              child: TextFormField(
                controller: nameController,
                validator: validateEmail,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.white,
                  labelText: 'User Name (Must be a valid email address)',
                  floatingLabelBehavior: FloatingLabelBehavior.never,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
              child: TextFormField(
                obscureText: true,
                controller: passwordController,
                validator: validatePassword,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.white,
                  labelText: 'Password',
                  floatingLabelBehavior: FloatingLabelBehavior.never,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(5),
              alignment: Alignment.center,
              child: const Text(
                '(Must contain a capital letter, number, and symbol)',
                style: TextStyle(color: buttonRed),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Text(
                errorMessage,
                style: const TextStyle(color: Colors.red),
              ),
            ),
            //Create Account TextButton using current text field input
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                ElevatedButton(
                  onPressed: () async {
                    setState(() {
                      isLoading = true;
                      errorMessage = '';
                    });
                    if (_key.currentState!.validate()) {
                      try {
                        await FirebaseAuth.instance
                            .createUserWithEmailAndPassword(
                          email: nameController.text,
                          password: passwordController.text,
                        )
                            .then((userCredential) {
                          var userUid = userCredential.user!.uid;
                          var email = userCredential.user!.email;

                          final userAccount = <String, String?>{
                            'email': email,
                          };
                          db
                              .collection('accounts')
                              .doc(userUid)
                              .set(userAccount);
                        });
                      } on FirebaseAuthException catch (error) {
                        errorMessage = error.message!;
                      }
                      setState(() => isLoading = false);
                      if (!mounted) return;
                      Navigator.of(context).pop();
                    }
                  },
                  child: isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                          'Sign Up',
                          style: TextStyle(fontSize: 20, color: buttonRed),
                        ),
                ),
                ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text(
                      'Cancel',
                      style: TextStyle(fontSize: 20, color: buttonRed),
                    )),
              ],
            )
          ]),
        ),
      ),
    );
  }
}
