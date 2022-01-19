import 'package:firequiz/blocs/theme.dart';
import 'package:firequiz/services/database.dart';
import 'package:firequiz/views/create_quizz.dart';
import 'package:firequiz/views/play_quizz.dart';
import 'package:flutter/material.dart';
import 'package:firequiz/widgets/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';

import 'add_question.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late Stream quizzStream;
  DatabaseService databaseService = new DatabaseService();

  Widget quizzList() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 24),
      child: StreamBuilder(
        stream: quizzStream,
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.hasError || snapshot.data == null) {
            return Text('Erreur, impossible d\'accéder à la base de données');
          }

          return ListView(
            children:
                snapshot.data!.docs.map<Widget>((DocumentSnapshot document) {
              Map<String, dynamic> data =
                  document.data()! as Map<String, dynamic>;
              return QuizzTitle(
                imgUrl: data['quizzImgUrl'],
                title: data['quizzTitle'],
                desc: data['quizzDescription'],
                quizzId: data['quizzId'],
              );
            }).toList(),
          );
        },
      ),
    );
  }

  @override
  void initState() {
    databaseService.getQuizzData().then((value) {
      setState(() {
        quizzStream = value;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    /* Fonctionne uniquement sur mobile */
    //var brightness = MediaQuery.of(context).platformBrightness;
    //bool isDarkMode = brightness == Brightness.dark;

    ThemeChanger _themeChanger = Provider.of<ThemeChanger>(context);

    return Scaffold(
      appBar: newAppBar(context, _themeChanger),
      body: Container(
        child: quizzList(),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => CreateQuizz()));
        },
      ),
    );
  }
}

class QuizzTitle extends StatelessWidget {
  final String imgUrl;
  final String title;
  final String desc;
  final String quizzId;

  QuizzTitle(
      {required this.imgUrl, required this.title, required this.desc, required this.quizzId});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => PlayQuizz(quizzId, imgUrl, title)));
      },
      child: Container(
          margin: EdgeInsets.only(top: 8),
          height: 150,
          child: Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(imgUrl,
                    width: MediaQuery.of(context).size.width - 48,
                    fit: BoxFit.cover),
              ),
              Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.black26,
                  ),
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(title,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 17,
                              fontWeight: FontWeight.w600)),
                      SizedBox(height: 6),
                      Text(desc,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w400)),
                    ],
                  )),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Container(
                      height: 40.0,
                      width: 40.0,
                      margin: const EdgeInsets.only(bottom: 8.0, right: 8.0),
                      child: FloatingActionButton(
                        child: Icon(Icons.edit),
                        onPressed: () {
                          Navigator.push(
                              context, MaterialPageRoute(builder: (context) => AddQuestion(quizzId: quizzId,)));
                        },
                      ),
                    ),
                ),
            ],
          )),
    );
  }
}
