import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instagram_clone_app/core/network/storage_methods.dart';
import 'package:uuid/uuid.dart';

import '../models/post_model.dart';

class FireStoreMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String> uploadPost(String description, Uint8List file, String uid, String username, String profImage) async {
    String res = 'Some error occured!';
    try {
      String photoUrl = await StorageMethods().uploadImageToStorage('posts', file, true);

      String postId = const Uuid().v1();

      PostModel post = PostModel(
          description: description,
          username: username,
          postId: postId,
          uid: uid,
          datePublished: DateTime.now(),
          postUrl: photoUrl,
          profImage: profImage,
          likes: []);

      _firestore.collection('posts').doc(postId).set(post.toJson());
      res = 'Success';
    } catch (e) {
      res = e.toString();
    }
    return res;
  }

  Future<void> likePost(String uid, String postId, List likes) async {
    try {
      if (likes.contains(uid)) {
        await _firestore.collection('posts').doc(postId).update({
          'likes': FieldValue.arrayRemove([uid])
        });
      } else {
        await _firestore.collection('posts').doc(postId).update({
          'likes': FieldValue.arrayUnion([uid])
        });
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<String> postComment(String postId, String text, String uid, String name, String profilePic) async {
    String res = "Some error occurred";
    try {
      if (text.isNotEmpty) {
        // if the likes list contains the user uid, we need to remove it
        String commentId = const Uuid().v1();
       await _firestore.collection('posts').doc(postId).collection('comments').doc(commentId).set({
          'profilePic': profilePic,
          'name': name,
          'uid': uid,
          'text': text,
          'commentId': commentId,
          'datePublished': DateTime.now(),
        });
        res = 'success';
      } else {
        res = "Please enter text";
      }
    } catch (err) {
      res = err.toString();
    }
    return res;
  }
  Future<void> deletePost(String postId) async{
    try {
       await _firestore.collection('posts').doc(postId).delete();
    } catch (err) {
      print(err.toString());
    }
    
  }

  Future<void> followUser(String uid , String followId) async{
    try {
      DocumentSnapshot snap = await _firestore.collection('users').doc(uid).get();
      List following = (snap.data()! as dynamic)['following'];

      if (following.contains(followId)) {
        await _firestore.collection('users').doc(followId).update({
          'followers': FieldValue.arrayRemove([uid])
        });

        await _firestore.collection('users').doc(followId).update({
          'following': FieldValue.arrayRemove([uid])
        });
      } else {
           await _firestore.collection('users').doc(followId).update({
          'followers': FieldValue.arrayUnion([followId])
        });

        await _firestore.collection('users').doc(followId).update({
          'following': FieldValue.arrayUnion([followId])
        });
      }
    } catch (e) {
      print(e.toString());
    }
  }
}
