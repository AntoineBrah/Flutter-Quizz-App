import 'package:firequiz/blocs/theme.dart';
import 'package:firequiz/views/create_quizz.dart';
import 'package:firequiz/views/home.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    
    return ChangeNotifierProvider<ThemeChanger>(
      create: (_) => ThemeChanger(ThemeData.dark()),
      child: new MaterialAppWithTheme(),
    );
  }
}


class MaterialAppWithTheme extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeChanger>(context);
    return MaterialApp(
        title: 'TP3',
        debugShowCheckedModeBanner: false,
        theme: theme.getTheme(),
        home: Home(),
      );
  }
}