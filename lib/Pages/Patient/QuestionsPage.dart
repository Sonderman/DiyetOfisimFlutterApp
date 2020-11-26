import 'package:diyet_ofisim/Pages/Patient/Inspection.dart';
import 'package:diyet_ofisim/Tools/NavigationManager.dart';
import 'package:diyet_ofisim/Tools/PageComponents.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class QuestionsPage extends StatefulWidget {
  QuestionsPage({Key key}) : super(key: key);

  @override
  _QuestionsPageState createState() => _QuestionsPageState();
}

class _QuestionsPageState extends State<QuestionsPage> {
  int currentPageIndex = 0;
  bool showBackButton = false;
  NavigationManager _nav;
  Inspection inspection;
  bool gender;
  int answerType = 0;
  TextEditingController age_controller = TextEditingController();
  TextEditingController length_controller = TextEditingController();
  TextEditingController weight_controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    _nav = NavigationManager(context);
    return Scaffold(
        body: Center(
            child: Container(
                height: PageComponents(context).heightSize(80),
                child: PageView.builder(
                    onPageChanged: (position) {
                      setState(() {
                        currentPageIndex =
                            _nav.getQuestionPageController().page.round();
                        currentPageIndex == 0
                            ? showBackButton = false
                            : showBackButton = true;
                      });
                    },
                    physics: NeverScrollableScrollPhysics(),
                    controller: _nav.getQuestionPageController(),
                    itemCount: inspection != null
                        ? inspection.gender
                            ? questionsAndAnswers.length
                            : questionsAndAnswers.length + 1
                        : questionsAndAnswers.length,
                    itemBuilder: (context, index) {
                      if (index == 0) return basicInformations(context);

                      return questionCard(
                          context: context,
                          questionIndex: index - 1,
                          type: answerType);
                    }))));
  }

  Widget basicInformations(BuildContext context) {
    // print("yaş: " + age_controller.text);
    //print("boy: " + length_controller.text);
    return Card(
      color: Colors.blueGrey,
      margin: EdgeInsets.all(PageComponents(context).widthSize(10)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Yaşınız?"),
                  SizedBox(
                    width: PageComponents(context).widthSize(5),
                  ),
                  Container(
                      width: PageComponents(context).widthSize(10),
                      child: TextFormField(
                          textAlign: TextAlign.center,
                          controller: age_controller,
                          onChanged: (input) {
                            if (int.tryParse(input) == 0 ||
                                int.tryParse(input) > 100)
                              age_controller.text = null;
                            setState(() {});
                          },
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          keyboardType: TextInputType.phone))
                ],
              ),
            ),
          ),
          Flexible(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Boyunuz?"),
                  SizedBox(
                    width: PageComponents(context).widthSize(5),
                  ),
                  Container(
                      width: PageComponents(context).widthSize(10),
                      child: TextFormField(
                          textAlign: TextAlign.center,
                          controller: length_controller,
                          onChanged: (input) {
                            if (int.tryParse(input) == 0 ||
                                int.tryParse(input) > 200)
                              setState(() {
                                length_controller.text = "";
                              });
                          },
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          keyboardType: TextInputType.phone))
                ],
              ),
            ),
          ),
          Flexible(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Kilonuz?"),
                  SizedBox(
                    width: PageComponents(context).widthSize(5),
                  ),
                  Container(
                      width: PageComponents(context).widthSize(10),
                      child: TextFormField(
                          textAlign: TextAlign.center,
                          controller: weight_controller,
                          onChanged: (input) {
                            if (int.tryParse(input) == 0 ||
                                int.tryParse(input) > 300)
                              setState(() {
                                weight_controller.text = "";
                              });
                          },
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          keyboardType: TextInputType.number))
                ],
              ),
            ),
          ),
          Flexible(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Text("Cinsiyetiniz nedir?"),
                    MaterialButton(
                      onPressed: () {
                        setState(() {
                          gender = true;
                        });
                      },
                      color: gender == null
                          ? Colors.green
                          : (gender ? Colors.blue : Colors.green),
                      child: Text("Erkek"),
                    ),
                    MaterialButton(
                      onPressed: () {
                        setState(() {
                          gender = false;
                        });
                      },
                      color: gender == null
                          ? Colors.green
                          : (gender ? Colors.green : Colors.blue),
                      child: Text("Kadın"),
                    )
                  ]),
            ),
          ),
          MaterialButton(
            onPressed: () {
              inspection = Inspection(
                  age: int.tryParse(age_controller.text),
                  length: int.tryParse(length_controller.text),
                  weight: int.tryParse(weight_controller.text),
                  gender: gender);
              _nav.getQuestionPageController().nextPage(
                  duration: Duration(seconds: 1), curve: Curves.bounceOut);
            },
            color: Colors.green,
            child: Text("İleri"),
          )
        ],
      ),
    );
  }

  Widget questionCard(
      {@required BuildContext context,
      @required int questionIndex,
      @required int type}) {
    return StatefulBuilder(
      builder: (context, StateSetter mystate) {
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
                        if (answerType == 0)
                          _nav.getQuestionPageController().previousPage(
                              duration: Duration(seconds: 1),
                              curve: Curves.bounceOut);
                        else
                          setState(() {
                            answerType = 0;
                          });
                      }),
                ),
                Container(
                  width: double.infinity,
                  height: double.infinity,
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                          Text(type == 0
                              ? (questionsAndAnswers[questionIndex] as List)
                                  .first
                              : (questionsAndAnswers[questionIndex] as List)
                                  .last),
                          SizedBox(
                            height: PageComponents(context).heightSize(5),
                          ),
                        ] +
                        (type == 0
                            ? answerParser(questionIndex,
                                questionsAndAnswers[questionIndex][1])
                            : getInput()),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  List<Widget> answerParser(int questionIndex, List<String> answers) {
    List<Widget> temp = [];

    answers.forEach((element) {
      temp.add(MaterialButton(
        onPressed: () {
          answerType = inspection.proceedAnswer(questionIndex,
              (questionsAndAnswers[questionIndex][1] as List).indexOf(element));
          if (answerType == 1) {
            setState(() {});
          } else if (questionIndex == questionsAndAnswers.length - 1) {
            //TODO - Bağlanacak
            print("Son Sayfa");
          } else {
            answerType = 0;
            _nav.getQuestionPageController().nextPage(
                duration: Duration(seconds: 1), curve: Curves.bounceOut);
          }
        },
        color: Colors.green,
        child: Text(element),
      ));
    });

    return temp;
  }

  List<Widget> getInput() {
    TextEditingController controller = TextEditingController();
    return [
      Container(
          width: PageComponents(context).widthSize(10),
          child: TextFormField(
              textAlign: TextAlign.center,
              controller: controller,
              onChanged: (input) {
                if (int.tryParse(input) == 0 || int.tryParse(input) > 200)
                  setState(() {
                    controller.text = "";
                  });
              },
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly
              ],
              keyboardType: TextInputType.phone)),
      SizedBox(
        height: PageComponents(context).heightSize(10),
      ),
      MaterialButton(
        onPressed: () {
          setState(() {
            answerType = 0;
          });

          _nav.getQuestionPageController().nextPage(
              duration: Duration(seconds: 1), curve: Curves.bounceOut);
        },
        color: Colors.green,
        child: Text("İleri"),
      )
    ];
  }
}
