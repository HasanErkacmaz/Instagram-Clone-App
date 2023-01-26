import 'package:cloud_firestore/cloud_firestore.dart';

class PostModel {
  final String description;
  final String username;
  final String postId;
  final String uid;
  final dynamic datePublished;
  final String postUrl;
  final String profImage;
  final List likes;

  PostModel(
      {required this.description,
      required this.username,
      required this.postId,
      required this.uid,
      required this.datePublished,
      required this.postUrl,
      required this.profImage,
      required this.likes});

  Map<String, dynamic> toJson() => {
        'description': description,
        'username': username,
        'postId': postId,
        'uid': uid,
        'datePublished': datePublished,
        'postUrl': postUrl,
        'profImage': profImage,
        'likes': likes
      };

  static PostModel fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return PostModel(
        description: snapshot['description'],
        username: snapshot['username'],
        postId: snapshot['postId'],
        uid: snapshot['uid'],
        datePublished: snapshot['datePublished'],
        postUrl: snapshot['postUrl'],
        profImage: snapshot['profImage'],
        likes: snapshot['likes']);
  }
}
