import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:healthytics/Models/DB/LoggedUser.dart';
import 'package:healthytics/Models/Utils/FirebaseStructure.dart';
import 'package:healthytics/Models/Utils/Utils.dart';
import 'package:healthytics/Views/Auth/Login.dart';
import 'package:flutter/material.dart';

class AuthController {
  static late FirebaseAuth _auth;
  late DatabaseReference _databaseRef;

  AuthController() {
    _auth = FirebaseAuth.instance;
    _databaseRef = FirebaseDatabase.instance.ref();
  }

  Future<bool> doRegistration(data) async {
    bool check = true;

    await _auth
        .createUserWithEmailAndPassword(
      email: data['email'],
      password: data['password'],
    )
        .then((value) async {
      data.remove('password');

      await _databaseRef
          .child(FirebaseStructure.users)
          .child(value.user!.uid)
          .set(data);

      CustomUtils.showToast('Successfully Registered. Please Login Now.');
    }).catchError((e) {
      check = false;
      CustomUtils.showToast(e.toString());
    });

    return check;
  }

  Future<bool> doLogin(data) async {
    bool check = true;

    await _auth
        .signInWithEmailAndPassword(
      email: data['email'],
      password: data['password'],
    )
        .catchError((e) {
      check = false;

      late String errorMessage;

      switch (e.code) {
        case 'invalid-email':
        case 'user-not-found':
        case 'wrong-password':
          errorMessage = 'Invalid credentails.';
          break;
        case 'user-disabled':
          errorMessage = 'Account has been disabled.';
          break;
        default:
          errorMessage = 'Something wrong.';
      }

      CustomUtils.showToast(errorMessage);
    }).then((value) async {
      CustomUtils.loggedInUser = await getUserData();
    });

    return Future.value(check);
  }

  Future<void> logout(context) async {
    await _auth.signOut();
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (_) => const Login()));
  }

  Future<LoggedUser> getUserData() async {
    late LoggedUser user;
    await _databaseRef
        .child(FirebaseStructure.users)
        .child(_auth.currentUser!.uid)
        .once()
        .then((DatabaseEvent event) async {
      Map<dynamic, dynamic> profileUserData = event.snapshot.value as Map;
      if (event.snapshot.value != null) {
        user = LoggedUser(
            name: profileUserData['name'],
            email: _auth.currentUser!.email,
            uid: _auth.currentUser!.uid,
            type: profileUserData['type'] ?? 2);
      }
    });

    return user;
  }

  Future<bool> doLoginCheck() async {
    bool check = false;
    return check;
  }

  Future<dynamic> sendPasswordResetLink(context, email) async {
    dynamic check = false;
    _auth.sendPasswordResetEmail(email: email).then((value) => check = true);
    return check;
  }
}
