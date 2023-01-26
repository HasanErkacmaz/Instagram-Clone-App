import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone_app/core/init/colors.dart';
import 'package:instagram_clone_app/core/responsive/mobile_screen_layout.dart';
import 'package:instagram_clone_app/core/responsive/responsive_layout_screen.dart';
import 'package:instagram_clone_app/core/responsive/web_screen_layout.dart';
import 'package:instagram_clone_app/core/state/user_provider.dart';
import 'package:instagram_clone_app/view/login/login_view.dart';

import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    await Firebase.initializeApp(
        options: const FirebaseOptions(
            apiKey: 'AIzaSyDSV4jB4uwTzUMdaQWCh6Es0V_ATGHH0DM',
            appId: '1:459145839134:web:f1c07b761d1642745da40f',
            messagingSenderId: '459145839134',
            projectId: ' instagram-clone-30758',
            storageBucket: 'instagram-clone-30758.appspot.com'));
  } else {
    await Firebase.initializeApp();
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => UserProvider(),
        )
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Instagram Clone',
        theme: ThemeData.dark().copyWith(scaffoldBackgroundColor: mobileBackgroundColor),
        home: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.connectionState == ConnectionState.active) {
              if (snapshot.hasData) {
                return const Responsivelayout(
                    webScreenLayout: WebScreenLayout(), mobileScreenLayout: MobileScreenLayout());
              } else if (snapshot.hasError) {
                return Center(
                  child: Text('${snapshot.error} '),
                );
              }
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(color: primaryColor),
              );
            }
            return const LoginView();
          },
        ),
        // const Responsivelayout(webScreenLayout: WebScreenLayout(), mobileScreenLayout: MobileScreenLayout())
      ),
    );
  }
}
