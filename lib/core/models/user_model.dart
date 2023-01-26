import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String email;
  final String username;
  final String bio;
  final String uid;
  final String photoUrl;
  final List followers;
  final List following;
  UserModel({
    required this.email,
    required this.username,
    required this.bio,
    required this.uid,
    required this.photoUrl,
    required this.followers,
    required this.following,
  });

  Map<String, dynamic> toJson() => {
        'username': username,
        'uid': uid,
        'email': email,
        'photoUrl': photoUrl,
        'bio': bio,
        'followers': followers,
        'following': following
      };

  static UserModel fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return UserModel(
        email: snapshot['email'],
        username: snapshot['username'],
        bio: snapshot['bio'],
        uid: snapshot['uid'],
        photoUrl: snapshot['photoUrl'],
        followers: snapshot['followers'],
        following: snapshot['following']);
  }
}
