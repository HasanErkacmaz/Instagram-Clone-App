import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:instagram_clone_app/core/widgets/post.card.dart';
import 'package:instagram_clone_app/core/init/colors.dart';

class FeedView extends StatelessWidget {
  const FeedView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        centerTitle: false,
        title: SvgPicture.asset('assets/images/ic_instagram.svg', color: primaryColor, height: 32),
        actions: [IconButton(onPressed: () {}, icon: const Icon(Icons.messenger_outline))],
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('posts').snapshots(), 
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot<Map<String ,dynamic>>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) => Container(
            child: PostCard(
              snap: snapshot.data!.docs[index].data(),
            ),
          ),
          );
        },
      ),
    );
  }
}
