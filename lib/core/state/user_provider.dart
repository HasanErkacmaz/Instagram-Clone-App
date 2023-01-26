

import 'package:flutter/cupertino.dart';
import 'package:instagram_clone_app/core/network/auth_methods.dart';
import 'package:instagram_clone_app/core/models/user_model.dart';

class UserProvider with ChangeNotifier {
  UserModel? _userModel;
  final AuthMethods _authMethods = AuthMethods();
 UserModel get getUserModel => _userModel!;

 Future<void> rereshUSer() async{
  UserModel user = await _authMethods.getUserDetails();
  _userModel = user;
  notifyListeners();
   
 }
}