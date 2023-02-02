import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone_app/core/init/colors.dart';
import 'package:instagram_clone_app/core/init/image_picker.dart';
import 'package:instagram_clone_app/core/network/fire_store_methods.dart';
import 'package:instagram_clone_app/view/comments/comments_view.dart';
import 'package:intl/intl.dart';

import 'like_animation.dart';

class PostCard extends StatefulWidget {
  final snap;
  const PostCard({super.key, required this.snap});

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  bool isLikeAnimating = false;
  int commentLen = 0;

  @override
  void initState() {
    super.initState();
    getComments();
  }

     getComments()async {
    try {
       QuerySnapshot snap = await FirebaseFirestore.instance.collection('posts').doc(widget.snap['postId']).collection('comments').get();
     commentLen = snap.docs.length;
    } catch (e) {
      showSnackBar(e.toString(), context);
    }
    }
  @override
  Widget build(BuildContext context) {
    // final UserModel userModel = Provider.of<UserProvider>(context).getUserModel;
    return Container(
      color: mobileBackgroundColor,
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        children: [
          //Header Section
          Container(
            padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 16).copyWith(right: 0),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 16,
                  backgroundImage: NetworkImage(widget.snap['profImage']),
                ),
                Expanded(
                    child: Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.snap['username'],
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                )),
                IconButton(
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (context) => Dialog(
                                child: ListView(
                                    padding: const EdgeInsets.symmetric(vertical: 16),
                                    shrinkWrap: true,
                                    children: [
                                      'delete',
                                    ]
                                        .map((e) => InkWell(
                                              onTap: () async{
                                                FireStoreMethods().deletePost(widget.snap['postId']);
                                                Navigator.of(context).pop();
                                              },
                                              child: Container(
                                                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                                                child: Text(e),
                                              ),
                                            ))
                                        .toList()),
                              ));
                    },
                    icon: const Icon(Icons.more_vert))
              ],
            ),
            //Image Section
          ),
          GestureDetector(
            onDoubleTap: () {},

            // async {
            //   //!!!!! Likes Problem Here
            //   await FireStoreMethods().likePost(widget.snap['postId'], userModel.uid, widget.snap['likes']);
            //   setState(() {
            //     isLikeAnimating = true;
            //   });
            // },
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.35,
                  width: double.infinity,
                  child: Image.network(
                    widget.snap['postUrl'],
                    fit: BoxFit.cover,
                  ),
                ),
                AnimatedOpacity(
                  duration: const Duration(milliseconds: 200),
                  opacity: isLikeAnimating ? 1 : 0,
                  child: LikeAnimation(
                    isAnimating: isLikeAnimating,
                    duration: const Duration(milliseconds: 400),
                    onEnd: () {
                      setState(() {
                        isLikeAnimating = false;
                      });
                    },
                    child: const Icon(Icons.favorite, color: Colors.white, size: 120),
                  ),
                )
              ],
            ),
          ),

          //Like Comment Section
          Row(
            children: [
              LikeAnimation(
                //!!!!! Likes Problem Here
                isAnimating: false,

                smallLike: true,
                child: IconButton(
                  //!!!!! Likes Problem Here
                  onPressed: () {},
                  // => FireStoreMethods()
                  //     .likePost(userModel.uid, widget.snap['postId'].toString(), widget.snap['likes'] ?? []),
                  icon:
                      //!!!!! Likes Problem Here
                      // widget.snap['likes'].contains(userModel.uid)
                      // ? const Icon(
                      //     Icons.favorite,
                      //     color: Colors.red,
                      //   )
                      // :
                      const Icon(
                    Icons.favorite_border,
                  ),
                ),
              ),
              IconButton(
                onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => CommentsView(snap: widget.snap['postId'].toString()),
                )),
                icon: const Icon(
                  Icons.comment_outlined,
                ),
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.send,
                ),
              ),
              Expanded(
                  child: Align(
                alignment: Alignment.bottomRight,
                child: IconButton(onPressed: () {}, icon: const Icon(Icons.bookmark_border)),
              ))
            ],
          ),
          //Description and Comments number
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'likes',
                  //!!!!! Likes Problem Here
                  //  (widget.snap['likes'].length) != null ?
                  // '${widget.snap['likes'].length } likes'
                  style: Theme.of(context).textTheme.bodySmall!.copyWith(fontWeight: FontWeight.w800),
                ),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.only(top: 8),
                  child: RichText(
                    text: TextSpan(style: const TextStyle(color: primaryColor), children: [
                      TextSpan(text: widget.snap['username'], style: const TextStyle(fontWeight: FontWeight.bold)),
                      TextSpan(
                          style: const TextStyle(color: primaryColor),
                          children: [TextSpan(text: '  ${widget.snap['description']}')])
                    ]),
                  ),
                ),
                InkWell(
                  onTap: () {},
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child:  Text(
                      'View all $commentLen comments',
                      style: const TextStyle(fontSize: 16, color: secondaryColor),
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Text(
                    DateFormat.yMMMd().format(widget.snap['datePublished'].toDate()),
                    style: const TextStyle(fontSize: 16, color: secondaryColor),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
