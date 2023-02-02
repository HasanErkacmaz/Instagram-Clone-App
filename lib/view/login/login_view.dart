

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:instagram_clone_app/core/network/auth_methods.dart';
import 'package:instagram_clone_app/core/widgets/text_field_input.dart';
import 'package:instagram_clone_app/core/init/colors.dart';
import 'package:instagram_clone_app/core/init/image_picker.dart';
import 'package:instagram_clone_app/view/signup/sign_up_view.dart';

import '../../core/responsive/mobile_screen_layout.dart';
import '../../core/responsive/responsive_layout.dart';
import '../../core/responsive/web_screen_layout.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;
  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }

  Future<void> loginUserr() async {

    setState(() {
      _isLoading=true;
    });
    String res = await AuthMethods().loginUser(email: _emailController.text, password: _passwordController.text);

    if (res == 'Success') {
     Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (context) => const Responsivelayout(
              mobileScreenLayout: MobileScreenLayout(),
              webScreenLayout: WebScreenLayout(),
            ),
          ),
          (route) => false);
    } else {
      // ignore: use_build_context_synchronously
      showSnackBar(res, context);
      
    }
    
    setState(() {
      _isLoading=false;
    });
  }

  void navigateToSignin() {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => const SignUpView(),));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Flexible(
            flex: 2,
            child: Container(),
          ),
          SvgPicture.asset(
            'assets/images/ic_instagram.svg',
            color: primaryColor,
            height: 64,
          ),
          const SizedBox(
            height: 64,
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
          InkWell(
            onTap: loginUserr,
            child: Container(
              width: double.infinity,
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: const ShapeDecoration(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(4))), color: blueColor),
              child: _isLoading ? const Center(child: CircularProgressIndicator(color: primaryColor,)) : const Text('Login'),
            ),
          ),
          const SizedBox(
            height: 12,
          ),
          Flexible(flex: 2, child: Container()),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: const Text("Don't have an acount?"),
              ),
              GestureDetector(
                onTap: navigateToSignin  ,
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: const Text(
                    "Sign up",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    )));
  }
}
