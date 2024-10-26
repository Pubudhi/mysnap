import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:mysnap/config/firebase_options.dart';
import 'package:mysnap/my_app.dart';

void main() async {
  // firebase set up
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // run app
  runApp(MyApp());
}
