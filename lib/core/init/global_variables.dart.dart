import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone_app/view/addPost/add_post_view.dart';
import 'package:instagram_clone_app/view/feed/feed_view.dart';
import 'package:instagram_clone_app/view/profile/profile_view.dart';
import 'package:instagram_clone_app/view/search/search_view.dart';

const webScreenSize = 600;

List<Widget> homeViewsItems = [
  const FeedView(),
  const SearchView(),
  const AddPostView(),
  const Text('data3'),
  ProfileView(
    uid: FirebaseAuth.instance.currentUser!.uid,
  )
];
