import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:instagram_clone_app/core/network/storage_methods.dart';
import 'package:instagram_clone_app/core/models/user_model.dart' as model;


class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<model.UserModel> getUserDetails() async {
   User currentUSer = _auth.currentUser!;
   DocumentSnapshot snap = await _firestore.collection('users').doc(currentUSer.uid).get();

   return model.UserModel.fromSnap(snap);
  }
// sign up user
  Future<String> signUpUser({
    required String email,
    required String password,
    required String username,
    required String bio,
    required Uint8List file,
  }) async {
    String res = 'Some error occured';
    try {
      if (email.isNotEmpty || password.isNotEmpty || username.isNotEmpty || bio.isNotEmpty) {
        //register user
        UserCredential cred = await _auth.createUserWithEmailAndPassword(email: email, password: password);

        // ignore: avoid_print
        print(cred.user!.uid);

        String photoUrl = await StorageMethods().uploadImageToStorage('profilePics', file, false);
        //add user to database

        model.UserModel user = model.UserModel(
            username: username,
            uid: cred.user!.uid,
            email: email,
            bio: bio,
            followers: [],
            following: [],
            photoUrl: photoUrl);

        await _firestore.collection('users').doc(cred.user!.uid).set(user.toJson());
      }
         res = 'success';
    // } on FirebaseAuthException catch (err) {
    //   if (err.code == 'invalid-email') {
    //     res = 'Email is badly formatted';
    //   } else if (err.code == 'weak-password') {
    //     res = 'Password should be at least 6 characters';
    //   }
     
    } catch (err) {
        res= err.toString();
    }
    return res;
  }
  //   } catch (err) {
  //     res = err.toString();
  //   }
  //   return res;
  // }

  //Log in user
  Future<String> loginUSer({
    required String email,
    required String password,
  }) async {
    String res = 'Some error occured';

    try {
      if (email.isNotEmpty || password.isNotEmpty) {
        await _auth.signInWithEmailAndPassword(email: email, password: password);
        res = 'Success';
      } else {
        res = 'Please enter all the fields!';
      }
    } catch (err) {
      res = err.toString();
    }
    return res;
  }
}
