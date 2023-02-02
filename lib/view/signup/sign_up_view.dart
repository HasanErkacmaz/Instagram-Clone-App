import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram_clone_app/core/init/image_picker.dart';
import 'package:instagram_clone_app/view/login/login_view.dart';
import 'package:instagram_clone_app/view/verify/email_verify_view.dart';

import '../../core/network/auth_methods.dart';

import '../../core/widgets/text_field_input.dart';
import '../../core/init/colors.dart';

class SignUpView extends StatefulWidget {
  const SignUpView({super.key});

  @override
  State<SignUpView> createState() => _SignUpViewState();
}

class _SignUpViewState extends State<SignUpView> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  final TextEditingController _userNameController = TextEditingController();
  Uint8List? _image;
  bool _isLoading = false;

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _userNameController.dispose();
    _bioController.dispose();
  }

  Future<void> selectImage() async {
    Uint8List im = await pickImage(ImageSource.gallery);
    setState(() {
      _image = im;
    });
  }

  void signUpUserr() async {
    if (_image == null) {
      showSnackBar('Please choose a profile picture', context);
    } else {
      setState(() {
        _isLoading = true;
      });
      String res = await AuthMethods().signUpUser(
          email: _emailController.text,
          password: _passwordController.text,
          username: _userNameController.text,
          bio: _bioController.text,
          file: _image!);
      if (res == 'success') {
        setState(() {
          _isLoading = false;
        });
        // ignore: use_build_context_synchronously
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const EmailVerifyView(),
            ));
      } else {
        setState(() {
          _isLoading = false;
        });
        showSnackBar(res, context);
      }
    }
  }

  void navigateToLogin() {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => const LoginView(),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: SafeArea(
            child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          width: double.infinity,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  'assets/images/ic_instagram.svg',
                  color: primaryColor,
                  height: 64,
                ),
                const SizedBox(
                  height: 64,
                ),
                Stack(
                  children: [
                    _image != null
                        ? CircleAvatar(
                            radius: 64,
                            backgroundImage: MemoryImage(_image!),
                          )
                        : const CircleAvatar(
                            radius: 64,
                            backgroundImage: NetworkImage(
                                'https://t4.ftcdn.net/jpg/03/46/93/61/360_F_346936114_RaxE6OQogebgAWTalE1myseY1Hbb5qPM.jpg'),
                          ),
                    Positioned(
                        bottom: -10,
                        left: 80,
                        child: IconButton(onPressed: selectImage, icon: const Icon(Icons.add_a_photo)))
                  ],
                ),
                const SizedBox(
                  height: 24,
                ),
                TextFieldImport(
                  textEditingController: _userNameController,
                  hinText: 'Enter Your Username',
                  textInputType: TextInputType.text,
                ),
                const SizedBox(
                  height: 24,
                ),
                TextFieldImport(
                  textEditingController: _emailController,
                  hinText: 'Enter Your Email',
                  textInputType: TextInputType.emailAddress,
                ),
                const SizedBox(
                  height: 24,
                ),
                TextFieldImport(
                  textEditingController: _passwordController,
                  hinText: 'Enter Your Password',
                  textInputType: TextInputType.text,
                  ispass: true,
                ),
                const SizedBox(
                  height: 24,
                ),
                TextFieldImport(
                  textEditingController: _bioController,
                  hinText: 'Enter Your Bio',
                  textInputType: TextInputType.text,
                ),
                const SizedBox(
                  height: 24,
                ),
                InkWell(
                  onTap: signUpUserr,
                  child: Container(
                    width: double.infinity,
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: const ShapeDecoration(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(4))),
                        color: blueColor),
                    child: _isLoading
                        ? const Center(
                            child: CircularProgressIndicator(color: primaryColor),
                          )
                        : const Text('Sign up'),
                  ),
                ),
                const SizedBox(
                  height: 12,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                        padding: const EdgeInsets.symmetric(vertical: 8), child: const Text("Already have an account?")),
                    GestureDetector(
                      onTap: navigateToLogin,
                      child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: const Text(
                            "Login",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          )),
                    ),
                  ],
                )
              ],
            ),
          ),
        )));
  }
}
