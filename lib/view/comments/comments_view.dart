import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone_app/core/extensions/widgets/comment_card.dart';
import 'package:instagram_clone_app/core/init/colors.dart';
import 'package:instagram_clone_app/core/network/fire_store_methods.dart';
import 'package:provider/provider.dart';

import '../../core/models/user_model.dart';
import '../../core/state/user_provider.dart';

class CommentsView extends StatefulWidget {
  final snap;
  const CommentsView({super.key, required this.snap});

  @override
  State<CommentsView> createState() => _CommentsViewState();
}

class _CommentsViewState extends State<CommentsView> {
  final TextEditingController _commentController = TextEditingController();
  @override
  void dispose() {
    super.dispose();
    _commentController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final UserModel userModel = Provider.of<UserProvider>(context).getUserModel;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        title: const Text('Comments'),
        centerTitle: false,
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('posts')
            .doc(widget.snap['postId'])
            .collection('comments').orderBy('datePublished' , descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return ListView.builder(
            itemCount: (snapshot.data! as dynamic).docs.length,
            itemBuilder: (context, index) => CommentCard(snap: (snapshot.data! as dynamic).docs[index].data()),
          );
        },
      ),
      bottomNavigationBar: SafeArea(
          child: Container(
        height: kToolbarHeight,
        margin: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        padding: const EdgeInsets.only(left: 16, right: 8),
        child: Row(
          children: [
            const CircleAvatar(
              backgroundImage: NetworkImage('https://picsum.photos/200'),
              radius: 18,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 16, right: 8),
                child: TextField(
                  controller: _commentController,
                  decoration: InputDecoration(hintText: 'Comment as ${userModel.username} ', border: InputBorder.none),
                ),
              ),
            ),
            InkWell(
              onTap: () async {
                await FireStoreMethods().postComment(widget.snap['postId'], _commentController.text, userModel.uid,
                    userModel.username, userModel.photoUrl);  setState(() {
                      _commentController.text = '';
                    });
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                child: const Text(
                  'Post',
                  style: TextStyle(color: blueColor),
                ),
              ),
            )
          ],
        ),
      )),
    );
  }
}
