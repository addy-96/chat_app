import 'dart:developer';
import 'dart:io';

import 'package:chat_application/core/custom_snack.dart';
import 'package:chat_application/provider/image_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AuthProvider with ChangeNotifier {
  final _auth = FirebaseAuth.instance;
  final _storage = FirebaseStorage.instance;
  final _cloud = FirebaseFirestore.instance;

  User? get currentUser => _auth.currentUser;

  bool get isSignedIn => currentUser != null;
  Future<void> createWithEmailAndPass(BuildContext context, String userEmail,
      String userPass, String userName, File imageFile) async {
    try {
      final response = await _auth.createUserWithEmailAndPassword(
        email: userEmail,
        password: userPass,
      );

      if (currentUser == null) return;

      log('USER AUTH CREATED');

      // Store the image to Firebase Storage
      final ref = _storage.ref().child('user-image').child(currentUser!.uid);
      await ref.putFile(imageFile);

      log('USER IMAGE UPLOADED');

      // Get the download URL for the image
      final imageUrl = await ref.getDownloadURL();

      // Store the user data in Firestore
      await _cloud.collection('users').doc(currentUser!.uid).set({
        'userId': currentUser!.uid,
        'username': userName,
        'email': userEmail, // changed to userEmail
        'imageurl': imageUrl,
      });

      log('USER DATA STORED (notifying listeners)');

      notifyListeners();
    } on FirebaseAuthException catch (err) {
      log(err.message.toString());
      getSnack(err.message.toString(), context, snackType.failure);
    }
  }

  Future<void> signinUserWithEmailPass(
      BuildContext context, String userEmail, String userPass) async {
    try {
      final response = await _auth.signInWithEmailAndPassword(
        email: userEmail,
        password: userPass,
      );
      log('user loogged in ${currentUser!.uid}');
      notifyListeners();
    } on FirebaseAuthException catch (err) {
      log(err.message.toString());

      getSnack(err.message.toString(), context, snackType.failure);
    }
  }

  Future<void> signOut(
    BuildContext context,
  ) async {
    try {
      final response = await _auth.signOut();
      final imageProvider =
          Provider.of<ProfileImageProvider>(context, listen: false);
      imageProvider.selectedImage = null;
    } on FirebaseAuthException catch (err) {
      log(err.message.toString());

      getSnack(err.message.toString(), context, snackType.failure);
    }
  }
}
