import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:project/Screens/SignUp_Screen.dart';

class FormScreen extends StatefulWidget {
  const FormScreen({Key? key}) : super(key: key);

  @override
  _FormScreenState createState() => _FormScreenState();
}

class _FormScreenState extends State<FormScreen> {
  final numberNode = new FocusNode();
  final ageNode = new FocusNode();
  final addressNode = new FocusNode();
  final vaccineNode = new FocusNode();
  final additionalDetailNode = new FocusNode();

  final _covidFormKey = GlobalKey<FormState>();

  final _numberController = TextEditingController();
  final _ageController = TextEditingController();
  final _nameController = TextEditingController();
  final _addressController = TextEditingController();
  final _vaccineController = TextEditingController();
  final _additionalInfoController = TextEditingController();

  void clearForm() {
    _nameController.clear();
    _numberController.clear();
    _ageController.clear();
    _addressController.clear();
    _vaccineController.clear();
    _additionalInfoController.clear();
  }

  CollectionReference users = FirebaseFirestore.instance.collection('users');
  @override
  void dispose() {
    numberNode.dispose();
    ageNode.dispose();
    addressNode.dispose();
    vaccineNode.dispose();
    additionalDetailNode.dispose();
    super.dispose();
  }

  Future<void> signOut(BuildContext ct) async {
    await auth.signOut();
    email = '';
    password = '';
    userId = '';
    Navigator.of(ct).pop();
    ScaffoldMessenger.of(ct).showSnackBar(SnackBar(
        content: Text("User has signed out",
            style: TextStyle(
              fontSize: 15,
            ))));
  }

  void submitForm() {
    if (_covidFormKey.currentState!.validate()) {
      _covidFormKey.currentState!.save();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Your form has been submitted',
              style: TextStyle(fontSize: 15))));
      clearForm();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text("COVID-19 Vaccination Form"),
          actions: <Widget>[
            IconButton(
              onPressed: () => signOut(context),
              icon: Icon(Icons.logout),
              color: Colors.white,
            ),
          ],
        ),
        body: SafeArea(
          child: Form(
            key: _covidFormKey,
            child: ListView(
              children: <Widget>[
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(labelText: 'Name'),
                  textInputAction: TextInputAction.next,
                  validator: (val) {
                    if (val!.isEmpty) {
                      return "Enter something for name";
                    }
                    return null;
                  },
                  onFieldSubmitted: (_) {
                    FocusScope.of(context).requestFocus(numberNode);
                  },
                  onSaved: (newValue) async {
                    await users.get().then((querySnapshot) => {
                          querySnapshot.docs.forEach((element) {
                            if (element['uid'] == userId) {
                              users.doc(element.id).update({'Name': newValue});
                              print(1);
                            }
                          })
                        });
                  },
                ),
                SizedBox(
                  height: 15,
                ),
                TextFormField(
                  controller: _numberController,
                  decoration: InputDecoration(labelText: 'Phone Number'),
                  textInputAction: TextInputAction.next,
                  focusNode: numberNode,
                  keyboardType: TextInputType.number,
                  validator: (val) {
                    if (val!.isEmpty) {
                      return "Enter something for phone number";
                    }
                    return null;
                  },
                  onFieldSubmitted: (_) {
                    FocusScope.of(context).requestFocus(ageNode);
                  },
                  onSaved: (newValue) async {
                    await users.get().then((querySnapshot) => {
                          querySnapshot.docs.forEach((element) {
                            if (element['uid'] == userId) {
                              users
                                  .doc(element.id)
                                  .update({'Phone Number': newValue});
                              print(2);
                            }
                          })
                        });
                  },
                ),
                SizedBox(height: 15),
                TextFormField(
                  controller: _ageController,
                  decoration: InputDecoration(labelText: 'Age'),
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.number,
                  focusNode: ageNode,
                  validator: (val) {
                    if (val!.isEmpty) {
                      return "Enter something for age";
                    }
                    var age = int.parse(val.toString());
                    if (age < 18) {
                      return "You must be 18 years or more to take the Vaccine";
                    }
                    return null;
                  },
                  onFieldSubmitted: (_) {
                    FocusScope.of(context).requestFocus(addressNode);
                  },
                  onSaved: (newValue) async {
                    await users.get().then((querySnapshot) => {
                          querySnapshot.docs.forEach((element) {
                            if (element['uid'] == userId) {
                              users.doc(element.id).update({'Age': newValue});
                              print(3);
                            }
                          })
                        });
                  },
                ),
                SizedBox(height: 15),
                TextFormField(
                  controller: _addressController,
                  decoration: InputDecoration(labelText: 'Address'),
                  textInputAction: TextInputAction.next,
                  focusNode: addressNode,
                  validator: (val) {
                    if (val!.isEmpty) {
                      return "Enter something for address";
                    }
                    return null;
                  },
                  onFieldSubmitted: (_) {
                    FocusScope.of(context).requestFocus(vaccineNode);
                  },
                  onSaved: (newValue) async {
                    await users.get().then((querySnapshot) => {
                          querySnapshot.docs.forEach((element) {
                            if (element['uid'] == userId) {
                              users
                                  .doc(element.id)
                                  .update({'Address': newValue});
                              print(4);
                            }
                          })
                        });
                  },
                ),
                SizedBox(height: 15),
                TextFormField(
                  controller: _vaccineController,
                  decoration: InputDecoration(
                      labelText: 'Vaccine Type(Pfizer, Moderna, J&J etc)'),
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.streetAddress,
                  focusNode: vaccineNode,
                  validator: (val) {
                    if (val!.isEmpty) {
                      return "Enter something for the vaccine you want to choose";
                    }
                    return null;
                  },
                  keyboardAppearance: Brightness.dark,
                  onFieldSubmitted: (_) {
                    FocusScope.of(context).requestFocus(additionalDetailNode);
                  },
                  onSaved: (newValue) async {
                    await users.get().then((querySnapshot) => {
                          querySnapshot.docs.forEach((element) {
                            if (element['uid'] == userId) {
                              users
                                  .doc(element.id)
                                  .update({'Vaccine type': newValue});
                              print(5);
                            }
                          })
                        });
                  },
                ),
                SizedBox(height: 15),
                TextFormField(
                  controller: _additionalInfoController,
                  decoration: InputDecoration(
                      labelText:
                          'Do you want to inform us about anything else?'),
                  textInputAction: TextInputAction.next,
                  focusNode: additionalDetailNode,
                  keyboardType: TextInputType.multiline,
                  maxLines: 3,
                  autocorrect: true,
                  onSaved: (newValue) async {
                    await users.get().then((querySnapshot) => {
                          querySnapshot.docs.forEach((element) {
                            if (element['uid'] == userId) {
                              users
                                  .doc(element.id)
                                  .update({'Additional info': newValue});
                              print(6);
                            }
                          })
                        });
                  },
                ),
                SizedBox(height: 15),
                ElevatedButton(
                  onPressed: () => submitForm(),
                  child: Text("Submit Form"),
                  style: ElevatedButton.styleFrom(primary: Colors.pinkAccent),
                )
              ],
            ),
          ),
        ));
  }
}
