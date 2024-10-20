import 'package:flutter/material.dart';

void main() {
  runApp(QuizApp());
}

class QuizApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Quiz App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(), // Set HomePage as the initial route
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Welcome to the Quiz App'),
      ),
      backgroundColor: Colors.lightBlueAccent, // Set the background color here
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 20), // Add some space between text and button
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => QuizHomePage()),
                );
              },
              child: Text('Démarrer le Quiz'),
            ),
          ],
        ),
      ),
    );
  }
}

class QuizHomePage extends StatefulWidget {
  @override
  _QuizHomePageState createState() => _QuizHomePageState();
}

class _QuizHomePageState extends State<QuizHomePage> {
  final List<Map<String, Object>> _questions = [
    {
      'questionText':
          'Quel est le langage de programmation utilisé pour développer des applications Android ?',
      'answers': [
        {'text': 'Java', 'score': 1},
        {'text': 'Python', 'score': 0},
        {'text': 'C#', 'score': 0},
        {'text': 'PHP', 'score': 0}
      ]
    },
    {
      'questionText': 'Que signifie "HTML" ?',
      'answers': [
        {'text': 'HyperText Markup Language', 'score': 1},
        {'text': 'Hyper Transfer Management Language', 'score': 0},
        {'text': 'HighText Markup Language', 'score': 0},
        {'text': 'HyperLink Management Language', 'score': 0}
      ]
    },
    {
      'questionText':
          'Quel est le système de gestion de version le plus utilisé ?',
      'answers': [
        {'text': 'Git', 'score': 1},
        {'text': 'Subversion', 'score': 0},
        {'text': 'Mercurial', 'score': 0},
        {'text': 'Perforce', 'score': 0}
      ]
    },
    {
      'questionText':
          'Quelle est la structure de base d’une base de données relationnelle ?',
      'answers': [
        {'text': 'Table', 'score': 1},
        {'text': 'Arborescence', 'score': 0},
        {'text': 'Pile', 'score': 0},
        {'text': 'Liste', 'score': 0}
      ]
    },
    {
      'questionText':
          'Quel langage est principalement utilisé pour le développement web côté client ?',
      'answers': [
        {'text': 'JavaScript', 'score': 1},
        {'text': 'Ruby', 'score': 0},
        {'text': 'Python', 'score': 0},
        {'text': 'C++', 'score': 0}
      ]
    },
  ];

  int _questionIndex = 0;
  int _totalScore = 0;

  void _answerQuestion(int score) {
    _totalScore += score;
    setState(() {
      _questionIndex++;
    });

    if (_questionIndex < _questions.length) {
      print('Il y a encore des questions!');
    } else {
      print('Quiz terminé!');
    }
  }

  void _resetQuiz() {
    setState(() {
      _questionIndex = 0;
      _totalScore = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Quiz App'),
      ),
      backgroundColor: Colors.lightGreenAccent, // Set the background color here
      body: _questionIndex < _questions.length
          ? Quiz(
              answerQuestion: _answerQuestion,
              questionIndex: _questionIndex,
              questions: _questions,
            )
          : Result(_totalScore, _resetQuiz),
    );
  }
}

class Quiz extends StatelessWidget {
  final List<Map<String, Object>> questions;
  final int questionIndex;
  final Function answerQuestion;

  Quiz({ 
    required this.questions,
    required this.answerQuestion,
    required this.questionIndex,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Question(
          questions[questionIndex]['questionText'] as String,
        ),
        ...(questions[questionIndex]['answers'] as List<Map<String, Object>>)
            .map((answer) {
          return Answer(
            () => answerQuestion(answer['score'] as int),
            answer['text'] as String,
          );
        }).toList()
      ],
    );
  }
}

class Question extends StatelessWidget {
  final String questionText;

  Question(this.questionText);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.all(10),
      child: Text(
        questionText,
        style: TextStyle(fontSize: 28),
        textAlign: TextAlign.center,
      ),
    );
  }
}

class Answer extends StatelessWidget {
  final VoidCallback selectHandler;
  final String answerText;

  Answer(this.selectHandler, this.answerText);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(vertical: 5, horizontal: 30),
      child: ElevatedButton(
        onPressed: selectHandler,
        child: Text(answerText),
      ),
    );
  }
}

class Result extends StatelessWidget {
  final int resultScore;
  final VoidCallback resetHandler;

  Result(this.resultScore, this.resetHandler);

  String get resultPhrase {
    String resultText;
    if (resultScore == 3) {
      resultText = 'Excellent!';
    } else if (resultScore == 2) {
      resultText = 'Bien joué!';
    } else if (resultScore == 1) {
      resultText = 'Pas mal!';
    } else {
      resultText = 'Réessayez!';
    }
    return resultText;
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            resultPhrase,
            style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          Text(
            'Votre score est: $resultScore',
            style: TextStyle(fontSize: 24),
          ),
          TextButton(
            onPressed: resetHandler,
            child: Text('Recommencer le Quiz!'),
            style: TextButton.styleFrom(
              foregroundColor: Colors.blue,
            ),
          ),
        ],
      ),
    );
  }
}
