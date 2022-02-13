import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:flutter/material.dart';

import 'Form_Screen.dart';

String email = '';
String password = '';
final FirebaseAuth auth = FirebaseAuth.instance;
final _formkey = GlobalKey<FormState>();
final databaseReference = FirebaseFirestore.instance;
String userId = '';
final _emailController = TextEditingController();
final _passwordController = TextEditingController();

void clearText() {
  _emailController.clear();
  _passwordController.clear();
}

class SignUpScreen extends StatefulWidget {
  SignUpScreen({Key? key}) : super(key: key);

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 50,
                child: Text(
                  'Sign Up',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 40,
                    color: Colors.white,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
              Center(
                  child: Container(
                child: Form(
                  key: _formkey,
                  child: ListView(
                    children: <Widget>[
                      TextFormField(
                        controller: _emailController,
                        validator: (val) {
                          if (val!.isEmpty) {
                            return "Please enter something for email";
                          }
                          if (val.contains("@") == false) {
                            return "Enter an @ symbol!";
                          }
                          return null;
                        },
                        onChanged: (val) {
                          setState(() {
                            email = val;
                          });
                        },
                        decoration: InputDecoration(hintText: "Email"),
                        textInputAction: TextInputAction.next,
                      ),
                      SizedBox(height: 15),
                      TextFormField(
                          controller: _passwordController,
                          validator: (val) {
                            if (val!.isEmpty) {
                              return "Enter something for Password";
                            }
                            if (val.length <= 6) {
                              return "Enter a password which has more than 6 letters";
                            }
                            return null;
                          },
                          decoration: InputDecoration(hintText: "Password"),
                          textInputAction: TextInputAction.next,
                          obscureText: true,
                          onChanged: (val) {
                            password = val;
                          })
                    ],
                  ),
                ),
                padding: EdgeInsets.symmetric(),
                width: MediaQuery.of(context).size.width / 1.2,
                height: MediaQuery.of(context).size.height / 1.5,
                color: Colors.white,
              )),
              SizedBox(
                height: 15,
              ),
              Row(
                children: [
                  ElevatedButton(
                      onPressed: () => signIn(context),
                      child: Text("Sign in"),
                      style: ElevatedButton.styleFrom(primary: Colors.pink)),
                  ElevatedButton(
                    onPressed: () => signUp(context),
                    child: Text("Sign up"),
                    style: ElevatedButton.styleFrom(primary: Colors.blue),
                  ),
                ],
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              )
            ],
          ),
        ),
      ),
    );
  }

  Future signUp(BuildContext ct) async {
    try {
      if (_formkey.currentState!.validate()) {
        UserCredential result = await auth.createUserWithEmailAndPassword(
            email: email, password: password);
        User user = result.user as User;
        createRecord(user);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("You have created a sign in",
                style: TextStyle(fontSize: 15))));
        return user;
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar((SnackBar(
        content:
            Text("Error occured in Signing up", style: TextStyle(fontSize: 15)),
        backgroundColor: Colors.red,
      )));
      return null;
    }
  }

  Future signIn(BuildContext ct) async {
    try {
      UserCredential result = await auth.signInWithEmailAndPassword(
          email: email, password: password);
      User user = result.user as User;
      final currentUser = auth.currentUser;
      if (currentUser!.uid == user.uid) {
        clearText();
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("You have been signed in",
                style: TextStyle(fontSize: 15))));
        userId = user.uid;
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => FormScreen(),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("Please Sign in", style: TextStyle(fontSize: 15))));
      }
      print(currentUser);
      print(user);
      return user;
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content:
            Text("Error occured in Signing in", style: TextStyle(fontSize: 15)),
        backgroundColor: Colors.red,
      ));
      print(e);
      return null;
    }
  }

  Future<void> createRecord(User user) async {
    /*return await databaseReference
        .collection('users')
        .doc(_email.toString())
        .set({'email': _email, 'uid': user.uid})
        .then((value) => print("User added"))
        .catchError((error) => print("Couldn't do it"));*/

    await databaseReference
        .collection('users')
        .add({
          'email': email,
          'uid': user.uid,
          'password': password,
        })
        .then((value) => print("User added"))
        .catchError((error) {
          print("Couldn't do it");
          print(error);
        });
  }
}
