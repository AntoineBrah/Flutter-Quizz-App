import 'package:firequiz/blocs/theme.dart';
import 'package:firequiz/services/database.dart';
import 'package:firequiz/views/home.dart';
import 'package:flutter/material.dart';
import 'package:firequiz/widgets/widgets.dart';
import 'package:provider/provider.dart';

class AddQuestion extends StatefulWidget {
  final String quizzId;

  AddQuestion({required this.quizzId});

  @override
  _AddQuestionState createState() => _AddQuestionState();
}

class _AddQuestionState extends State<AddQuestion> {
  final _formKey = GlobalKey<FormState>();

  late String question;
  bool res = true;
  bool _isLoading = false;

  int _value = 1;

  DatabaseService databaseService = new DatabaseService();

  uploadQuestion() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      Map<String, String> questionMap = {
        "question": question,
        "response": res.toString()
      };

      databaseService
          .addQuestionData(questionMap, widget.quizzId)
          .then((value) => {
                setState(() {
                  _isLoading = false;
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
                              ? "Le champ ne peut pas être vide"
                              : null,
                          decoration:
                              InputDecoration(hintText: "Entrez la question"),
                          onChanged: (value) => {question = value},
                        ),
                        SizedBox(
                          height: 6,
                        ),
                        ListTile(
                          title: Text('La question est VRAIE'),
                          leading: Radio<int>(
                            value: 1, 
                            groupValue: _value, 
                            onChanged: (value) {
                              setState(() {
                                res = true;
                                _value = value!;
                              });
                            }
                          ),
                        ),
                        SizedBox(
                          height: 6,
                        ),
                        ListTile(
                          title: Text('La question est FAUSSE'),
                          leading: Radio<int>(
                            value: 2, 
                            groupValue: _value, 
                            onChanged: (value) {
                              setState(() {
                                res = false;
                                _value = value!;
                              });
                            }
                          ),
                        ),
                        Spacer(),
                        Row(
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: customButton(
                                  context: context,
                                  label: "Accueil",
                                  width: MediaQuery.of(context).size.width / 2 -
                                      36, themeChanger: _themeChanger),
                            ),
                            SizedBox(width: 24),
                            GestureDetector(
                              onTap: () {
                                uploadQuestion();
                              },
                              child: customButton(
                                  context: context,
                                  label: "Ajouter une question",
                                  width: MediaQuery.of(context).size.width / 2 -
                                      36, themeChanger: _themeChanger),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 60,
                        ),
                      ],
                    )),
              ));
  }
}
