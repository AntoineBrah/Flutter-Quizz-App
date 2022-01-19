import 'dart:math';

import 'package:firequiz/blocs/theme.dart';
import 'package:firequiz/services/database.dart';
import 'package:firequiz/views/add_question.dart';
import 'package:firequiz/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:random_string/random_string.dart';

class CreateQuizz extends StatefulWidget {
  @override
  _CreateQuizzState createState() => _CreateQuizzState();
}

class _CreateQuizzState extends State<CreateQuizz> {
  final _formKey = GlobalKey<FormState>();
  late String imageUrl, title, description, id;
  DatabaseService databaseService = new DatabaseService();

  bool _isLoading = false;

  createQuizz() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      id = randomAlphaNumeric(16);

      Map<String, dynamic> quizzData = {
        "quizzId": id,
        "quizzImgUrl": imageUrl,
        "quizzTitle": title,
        "quizzDescription": description
      };

      await databaseService.addQuizzData(quizzData, id).then((value) => {
            setState(() {
              _isLoading = false;
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => AddQuestion(quizzId: id)));
            })
          });
    }
  }

  @override
  Widget build(BuildContext context) {

    ThemeChanger _themeChanger = Provider.of<ThemeChanger>(context);

    return Scaffold(
      appBar: newAppBar(context, _themeChanger),
      body: _isLoading
          ? Container(
              child: Center(
              child: CircularProgressIndicator(),
            ))
          : Form(
              key: _formKey,
              child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    children: [
                      TextFormField(
                        validator: (value) => value == null || value.isEmpty
                            ? "Veuillez entrer l'url d'une Image"
                            : null,
                        decoration: InputDecoration(hintText: "Image URL"),
                        onChanged: (value) => {imageUrl = value},
                      ),
                      SizedBox(
                        height: 6,
                      ),
                      TextFormField(
                        validator: (value) => value == null || value.isEmpty
                            ? "Veuillez entrer un titre"
                            : null,
                        decoration: InputDecoration(hintText: "Titre Quizz"),
                        onChanged: (value) => {title = value},
                      ),
                      SizedBox(
                        height: 6,
                      ),
                      TextFormField(
                        validator: (value) => value == null || value.isEmpty
                            ? "Veuillez entrer une description"
                            : null,
                        decoration:
                            InputDecoration(hintText: "Description Quizz"),
                        onChanged: (value) => {description = value},
                      ),
                      Spacer(),
                      GestureDetector(
                          onTap: () {
                            createQuizz();
                          },
                          child: customButton(
                              context: context, label: "Créer le Quizz", themeChanger:  _themeChanger), ),
                      SizedBox(
                        height: 60,
                      ),
                    ],
                  )),
            ),
    );
  }
}
