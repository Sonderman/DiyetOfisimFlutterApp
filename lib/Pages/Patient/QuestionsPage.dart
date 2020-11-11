import 'package:diyet_ofisim/Tools/NavigationManager.dart';
import 'package:diyet_ofisim/Tools/PageComponents.dart';
import 'package:flutter/material.dart';

class QuestionsPage extends StatefulWidget {
  QuestionsPage({Key key}) : super(key: key);

  @override
  _QuestionsPageState createState() => _QuestionsPageState();
}

class _QuestionsPageState extends State<QuestionsPage> {
  int currentPageIndex = 0;
  bool showBackButton = false;
  NavigationManager _nav;

  @override
  Widget build(BuildContext context) {
    _nav = NavigationManager(context);
    return Scaffold(
        body: Center(
            child: Container(
      height: PageComponents(context).heightSize(80),
      child: PageView(
        onPageChanged: (position) {
          setState(() {
            currentPageIndex = _nav.getQuestionPageController().page.round();
            currentPageIndex == 0
                ? showBackButton = false
                : showBackButton = true;
          });
        },
        physics: NeverScrollableScrollPhysics(),
        controller: _nav.getQuestionPageController(),
        children: [
          questionCard(context, "Cinsiyetiniz nedir", ["Erkek", "Kadın"]),
          questionCard(context, "Ağrınız varmı?", [
            "Evet",
            "Hayır",
          ]),
        ],
      ),
    )));
  }

  Card questionCard(
      BuildContext context, String question, List<String> answers) {
    return Card(
      color: Colors.blueGrey,
      margin: EdgeInsets.all(PageComponents(context).widthSize(10)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Stack(
          children: [
            Visibility(
              visible: showBackButton,
              child: IconButton(
                  color: Colors.red,
                  iconSize: 32,
                  icon: Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    _nav.getQuestionPageController().previousPage(
                        duration: Duration(seconds: 1),
                        curve: Curves.bounceOut);
                  }),
            ),
            Container(
              width: double.infinity,
              height: double.infinity,
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                //crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                      Text(question),
                      SizedBox(
                        height: PageComponents(context).heightSize(5),
                      ),
                    ] +
                    answerParser(answers),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> answerParser(List<String> answers) {
    List<Widget> temp = [];

    answers.forEach((element) {
      temp.add(MaterialButton(
        onPressed: () {
          _nav.getQuestionPageController().nextPage(
              duration: Duration(seconds: 1), curve: Curves.bounceOut);
        },
        color: Colors.green,
        child: Text(element),
      ));
    });

    return temp;
  }
}
