import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone_app/core/init/colors.dart';


class SearchView extends StatefulWidget {
  const SearchView({super.key});

  @override
  State<SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  final TextEditingController searchController = TextEditingController();
  bool isShowUsers = false;

  @override
  void dispose() {
    super.dispose();
    searchController.dispose();
  }

  @override

  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        title: TextFormField(
          controller: searchController, decoration: const InputDecoration(
          labelText: 'Search for a user'
        ),
        onFieldSubmitted: (String _) {
            setState(() {
              isShowUsers = true; 
            });
        }
        ),
      ),
      body: isShowUsers? FutureBuilder(future: FirebaseFirestore.instance.collection('users').where('username' , isGreaterThanOrEqualTo: searchController.text).get(),
           builder: (context, snapshot) {
             if (!snapshot.hasData) {
               return const Center(child: CircularProgressIndicator(),);

             }
             return ListView.builder(itemCount: (snapshot.data! as dynamic).docs.length, itemBuilder: (context, index) {
               return ListTile(
                leading: CircleAvatar(
                  backgroundImage: NetworkImage((snapshot.data! as dynamic).docs[index]['photoUrl']),
                ),
                title: Text((snapshot.data! as dynamic).docs[index]['username']),
               );
             },);
           },
      ): const Text('Posts')
    );
  }
}