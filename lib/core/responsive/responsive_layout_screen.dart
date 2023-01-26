import 'package:flutter/material.dart';

import 'package:instagram_clone_app/core/init/global_variables.dart.dart';
import 'package:instagram_clone_app/core/state/user_provider.dart';
import 'package:provider/provider.dart';

class Responsivelayout extends StatefulWidget {

  final Widget webScreenLayout ;
  final Widget mobileScreenLayout ;
  const Responsivelayout({super.key, required this.webScreenLayout, required this.mobileScreenLayout});

  @override
  State<Responsivelayout> createState() => _ResponsivelayoutState();
}

class _ResponsivelayoutState extends State<Responsivelayout> {
  @override
  void initState() {
    super.initState();
    addData();
  }

  void addData() async {
    // ignore: no_leading_underscores_for_local_identifiers
    UserProvider _userProvider = Provider.of(context , listen: false);
    await _userProvider.rereshUSer();
  }
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > webScreenSize ) {
            // web screen
            return widget.webScreenLayout;
        }
           // mobile screen
           return widget.mobileScreenLayout;
      },
    );
  }
}