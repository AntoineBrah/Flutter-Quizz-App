import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firequiz/blocs/theme.dart';
import 'package:firequiz/models/question.dart';
import 'package:firequiz/services/database.dart';
import 'package:flutter/material.dart';
import 'package:firequiz/widgets/widgets.dart';
import 'package:provider/provider.dart';

class PlayQuizz extends StatefulWidget {
  final String quizzId;
  final String quizzUrl;
  final String quizzTitle;

  PlayQuizz(this.quizzId, this.quizzUrl, this.quizzTitle);

  @override
  _PlayQuizzState createState() => _PlayQuizzState();
}

class _PlayQuizzState extends State<PlayQuizz> {

  DatabaseService databaseService = new DatabaseService();
  QuerySnapshot? questionSnapshot;

  int index = 0;
  String response = "";

  void _nextQuestion() {
    setState(() {
      if(index >= questionSnapshot!.docs.length-1)
        index = 0;
      else
        index++;      
    });
  }

  _checkAnswer(bool userChoice, BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        duration: Duration(milliseconds: 800),
        content: userChoice
            ? Text('FÉLICITATION, vous avez répondu juste !')
            : Text('DOMMAGE, vous vous êtes trompé !')));
  }

  Question getQuestionFromDataSnapshot(DocumentSnapshot questionSnapshot){
    Question question = new Question();

    Map<String, dynamic> data = questionSnapshot.data()! as Map<String, dynamic>;

    question.question = data['question'];
    question.response = data['response'];

    return question;
  }

  @override
  void initState() {
    databaseService.getQuizzQuestions(widget.quizzId).then((value) {
      questionSnapshot = value;

      setState(() {

      });

    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    
    ThemeChanger _themeChanger = Provider.of<ThemeChanger>(context);

    return Scaffold(
      appBar: newAppBar(context, _themeChanger),
      body: Container(
        child: Column(children: [
          questionSnapshot == null ? Container() : 
          Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(top: 20),
              width: MediaQuery.of(context).size.width * 0.80,
              height: 150,
              decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  border: Border.all(
                    width: 1,
                  ),
                  image: DecorationImage(
                      image: NetworkImage(widget.quizzUrl),
                      fit: BoxFit.cover)),
            ),
            SizedBox(height: 50,),
            Stack(
              children: <Widget>[
                Container(
                  width: MediaQuery.of(context).size.width * 0.80,
                  height: 300,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black),
                    borderRadius: BorderRadius.circular(10),
                    color: _themeChanger.getToggled()? Colors.cyanAccent:Colors.grey,
                  ),
                  child: Center(
                    child: Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Text(getQuestionFromDataSnapshot(questionSnapshot!.docs[index]).question,
                            textAlign: TextAlign.center,
                            style: TextStyle(color: _themeChanger.getToggled()? Colors.black:Colors.white))),
                  ),
                ),
              ],
            ),
            ButtonBar(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(top: 50),
                  child: ElevatedButton(
                    onPressed: () => _checkAnswer(getQuestionFromDataSnapshot(questionSnapshot!.docs[index]).response == "true", context),
                    child: Text("VRAI"),
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.resolveWith(
                            (states) => _themeChanger.getToggled()? Colors.blue:Colors.black)),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 50),
                  child: ElevatedButton(
                    onPressed: () => _checkAnswer(getQuestionFromDataSnapshot(questionSnapshot!.docs[index]).response == "false", context),
                    child: Text("FAUX"),
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.resolveWith(
                            (states) => _themeChanger.getToggled()? Colors.blue:Colors.black)),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 50),
                  child: ElevatedButton(
                    onPressed: _nextQuestion,
                    child: Text("→"),
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.resolveWith(
                            (states) => _themeChanger.getToggled()? Colors.blue:Colors.black)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
        ],),
      )
    );
  }
}
