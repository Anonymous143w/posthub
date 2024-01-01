import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:posthub/data/firebase_servise/firestor.dart';
import 'package:posthub/data/firebase_servise/storage.dart';
import 'package:posthub/util/exeption.dart';

class Authentication {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  Future<void> Login({
    required String email,
    required String password,
  }) async {
    try {
      await _auth.signInWithEmailAndPassword(
          email: email.trim(), password: password.trim());
    } on FirebaseException catch (e) {
      throw exceptions(e.message.toString());
    }
  }
  
  Future<void> Signup({
    required String email,
    required String password,
    required String passwordConfirme,
    required String username,
    required String bio,
    required File profile,
  }) async {
    String URL;
    try {
      if (email.isNotEmpty &&
          password.isNotEmpty &&
          username.isNotEmpty &&
          bio.isNotEmpty) {
        if (password == passwordConfirme) {
          // create user with email and password
          await _auth.createUserWithEmailAndPassword(
            email: email.trim(),
            password: password.trim(),
          );
          // upload profile image on storage

          if (profile != File('')) {
            URL =
                await StorageMethod().uploadImageToStorage('Profile', profile);
          } else {
            URL = '';
          }

          // get information with firestor

          await Firebase_Firestor().CreateUser(
            email: email,
            username: username,
            bio: bio,
            profile: URL == ''
                ? 'https://firebasestorage.googleapis.com/v0/b/posthub-7f739.appspot.com/o/ideogram%20(4).jpeg?alt=media&token=165668b1-64ad-487e-8a40-6642b4e1e120'
                : URL,
          );
        } else {
          throw exceptions('password and confirm password should be same');
        }
      } else {
        throw exceptions('enter all the fields');
      }
    } on FirebaseException catch (e) {
      throw exceptions(e.message.toString());
    }
  }
}