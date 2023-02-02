import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone_app/core/init/colors.dart';
import 'package:instagram_clone_app/core/init/image_picker.dart';
import 'package:instagram_clone_app/view/login/login_view.dart';
import 'package:instagram_clone_app/view/signup/sign_up_view.dart';

class EmailVerifyView extends StatefulWidget {
  const EmailVerifyView({super.key});

  @override
  State<EmailVerifyView> createState() => _EmailVerifyViewState();
}

class _EmailVerifyViewState extends State<EmailVerifyView> {
  bool isEmailVerified = false;
  Timer? timer;

  @override
  void initState() {
    super.initState();
    isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;
    if (!isEmailVerified) {
        sendVerificationEmail();

       timer = Timer.periodic(Duration(seconds: 3), 
        (_) => checkEmailVerified()
        );
    }
  }

  @override
  void dispose() {
    super.dispose();
    timer?.cancel();
  }

  Future checkEmailVerified() async{
      //call after email verification!
      await FirebaseAuth.instance.currentUser!.reload();
    setState(() {   
      isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;
    });
    if (isEmailVerified) {
      showSnackBar('Email Successfully Verified', context);

      timer!.cancel();

    }
  }

  Future sendVerificationEmail() async{
     try {
        final user = FirebaseAuth.instance.currentUser!;
      await user.sendEmailVerification();
     } catch (e) {
       showSnackBar(e.toString(), context);
     }
  }
  @override
  Widget build(BuildContext context) => isEmailVerified
      ? const LoginView()
      : Scaffold(
        appBar: AppBar(
          backgroundColor: mobileBackgroundColor,
          leading: IconButton(onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => SignUpView(),)), icon: Icon(Icons.arrow_back)),
        ),
           body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 35),
              const SizedBox(height: 30),
              const Center(
                child: Text(
                  'Check your \n Email',
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32.0),
                child: Center(
                  child: Text(
                    'We have sent you a Email on  ${FirebaseAuth.instance.currentUser?.email}',
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Center(child: CircularProgressIndicator()),
              const SizedBox(height: 8),
              const Padding(
                padding: EdgeInsets
                    .symmetric(horizontal: 32.0),
                child: Center(
                  child: Text(
                    'Verifying email....',
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              const SizedBox(height: 57),
              Padding(
                padding: const EdgeInsets
                    .symmetric(horizontal: 32.0),
                child: ElevatedButton(
                  child: const Text('Resend'),
                  onPressed: () {
                    try {
                      FirebaseAuth.instance.currentUser
                          ?.sendEmailVerification();
                    } catch (e) {
                      debugPrint('$e');
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      );
          
        
}
