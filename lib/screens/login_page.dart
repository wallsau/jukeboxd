import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:jukeboxd/screens/user_profile.dart';
import 'package:jukeboxd/utils/colors.dart';
import 'package:jukeboxd/utils/validation.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final nameController = TextEditingController();
  final passwordController = TextEditingController();
  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  String errorMessage = '';
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;
    var db = FirebaseFirestore.instance;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (user != null) {
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => UserProfile()));
      }
    });

    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Welcome!'),
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
              //Sign In Text
              Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.all(10),
                child: Text('Logged ${user == null ? 'out' : 'in'}'),
              ),
              //Username Text Field
              Container(
                padding: const EdgeInsets.all(10),
                child: TextFormField(
                  controller: nameController,
                  validator: validateEmail,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    filled: true,
                    fillColor: Colors.white,
                    labelText: 'User Name',
                    floatingLabelBehavior: FloatingLabelBehavior.never,
                  ),
                ),
              ),
              //Password Text Field
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
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Text(
                  errorMessage,
                  style: const TextStyle(color: Colors.red),
                ),
              ),
              //Sign In Button
              Container(
                height: 50,
                padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                child: ElevatedButton(
                  onPressed: (user != null)
                      ? null
                      : () async {
                          setState(() {
                            isLoading = true;
                            errorMessage = '';
                          });
                          if (_key.currentState!.validate()) {
                            try {
                              await FirebaseAuth.instance
                                  .signInWithEmailAndPassword(
                                email: nameController.text,
                                password: passwordController.text,
                              );
                            } on FirebaseAuthException catch (error) {
                              errorMessage = error.message!;
                            }
                            setState(() {
                              isLoading = false;
                            });
                          }
                        },
                  child: isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text('Sign In'),
                ),
              ),
              //Sign Out Button
              Container(
                height: 50,
                padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                child: ElevatedButton(
                    onPressed: (user == null)
                        ? null
                        : () async {
                            setState(() {
                              isLoading = true;
                              errorMessage = '';
                            });
                            try {
                              await FirebaseAuth.instance.signOut();
                            } on FirebaseAuthException catch (error) {
                              errorMessage = error.message!;
                            }
                            setState(() => isLoading = false);
                          },
                    child: isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text('Sign Out')),
              ),
              Container(
                  height: 50,
                  padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                  child: ElevatedButton(
                      onPressed: () => {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => UserProfile()))
                          },
                      child: const Text('To UserProfile'))),
              //Create Account TextButton using current text field input
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Text("Don't have an account?"),
                  TextButton(
                    onPressed: (user != null)
                        ? null
                        : () async {
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
                                  //Create user account document with userUid as the document id
                                  db
                                      .collection('accounts')
                                      .doc(userUid)
                                      .set(userAccount);
                                });
                              } on FirebaseAuthException catch (error) {
                                errorMessage = error.message!;
                              }
                              setState(() => isLoading = false);
                            }
                          },
                    child: isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text(
                            'Create one',
                            style: TextStyle(fontSize: 20, color: buttonRed),
                          ),
                  ),
                ],
              )
            ]),
          ),
        ),
      ),
    );
  }
}
