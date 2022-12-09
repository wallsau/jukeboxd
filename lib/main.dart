import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:jukeboxd/screens/login_page.dart';
import 'package:jukeboxd/screens/user_profile.dart';
import 'package:jukeboxd/utils/colors.dart';

//Contributed by Austin Walls
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  await dotenv.load(fileName: '.env');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    User? firebaseUser = FirebaseAuth.instance.currentUser;
    Widget homeWidget;

    if (firebaseUser != null) {
      homeWidget = UserProfile();
    } else {
      homeWidget = LoginPage();
    }
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            colorScheme: ColorScheme.fromSwatch().copyWith(
              primary: const Color(0xFF654364),
              secondary: const Color(0xFFf85f6a),
            ),
            scaffoldBackgroundColor: bgGray,
            textTheme: const TextTheme(
                headline1:
                    TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
                headline6:
                    TextStyle(fontSize: 36.0, fontStyle: FontStyle.italic),
                bodyText2: TextStyle(fontSize: 14.0, color: Colors.white))),
        home: homeWidget);
  }
}
