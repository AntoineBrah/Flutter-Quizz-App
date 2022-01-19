import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase/firestore.dart';

class DatabaseService {
  Future<void> addQuizzData(
      Map<String, dynamic> quizzData, String quizzId) async {
    await FirebaseFirestore.instance
        .collection("Quizz")
        .doc(quizzId)
        .set(quizzData)
        .catchError((err) {
      print(err.toString());
    });
  }

  Future<void> addQuestionData(
      Map<String, dynamic> questionData, String quizzId) async {
    await FirebaseFirestore.instance
        .collection("Quizz")
        .doc(quizzId)
        .collection("Q&A")
        .add(questionData)
        .catchError((err) {
      print(err);
    });
  }

  getQuizzData() async {
    return await FirebaseFirestore.instance.collection("Quizz").snapshots();
  }

  getQuizzQuestions(String quizzId) async {
    return await FirebaseFirestore.instance
    .collection("Quizz")
    .doc(quizzId)
    .collection("Q&A")
    .get();
  }
}
