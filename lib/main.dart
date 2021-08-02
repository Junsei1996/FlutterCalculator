
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterapp/widgets/MyButton.dart';
import 'package:math_expressions/math_expressions.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  static const String _title = 'Flutter Code';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: _title,
      theme: ThemeData(
        brightness: Brightness.light,
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
              primary: Colors.white, onPrimary: Colors.black),
        ),
        textTheme: TextTheme(
          headline1: TextStyle(color: Colors.black, fontSize: 70),
          //for the result text
          headline2: TextStyle(color: Colors.black, fontSize: 30),
          //for numbers
          headline3: TextStyle(color: Colors.orange, fontSize: 30),
          //for operations
          headline4:
              TextStyle(color: Colors.grey, fontSize: 30), //for functions
        ),
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
              primary: Colors.black, onPrimary: Colors.white),
        ),
        textTheme: TextTheme(
          headline1: TextStyle(color: Colors.white, fontSize: 70),
          //for the result text
          headline2: TextStyle(color: Colors.white, fontSize: 30),
          //for numbers
          headline3: TextStyle(color: Colors.orange, fontSize: 30),
          //for operations
          headline4:
              TextStyle(color: Colors.grey, fontSize: 30), //for functions
        ),
        /* dark theme settings */
      ),
      home: Scaffold(
//        appBar: AppBar(title: const Text(_title)),
        body: const MyStatefulWidget(),
      ),
    );
  }
}

class MyStatefulWidget extends StatefulWidget {
  const MyStatefulWidget({Key? key}) : super(key: key);

  @override
  State<MyStatefulWidget> createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  var userInput = '';
  var displayInput = ""; // last input(only for display)
  var previousInput = '';
  var arithmetic = '';

  void input(String x) {
    setState(() {
      userInput = userInput + x;
//      displayInput = userInput;
      setInputNumber(userInput);
    });
  }

  String solveEquation(String equation) {
    String finaluserinput = "";
    finaluserinput = equation.replaceAll("x", "*");
    finaluserinput = finaluserinput.replaceAll("÷", "/");
    Parser p = Parser();
    Expression exp = p.parse(finaluserinput);
    ContextModel cm = ContextModel();
    double eval = exp.evaluate(EvaluationType.REAL, cm);
    var answer = eval.toString();
    return answer;
  }

  void showResult() {
    setState(() {
      var equation = previousInput + arithmetic + userInput;
      var result = solveEquation(equation);
      setDisplayNumber(result);
      userInput = result;
      arithmetic = "";
      previousInput = "";
    });
  }

  void inputArithmetic(String x) {
    setState(() {
      if (userInput.isEmpty && x == "-") {
        userInput = "-" + userInput;
//        displayInput = userInput;
        setDisplayNumber(userInput);
      } else if (previousInput.isEmpty) {
        previousInput = userInput;
        userInput = "";
        arithmetic = x;
      } else if (previousInput.isNotEmpty &&
          userInput.isNotEmpty &&
          arithmetic.isNotEmpty) {
        var equation = previousInput + arithmetic + userInput;
        previousInput = solveEquation(equation);
        userInput = "";
        arithmetic = x;
//        displayInput = previousInput;
        setDisplayNumber(previousInput);
      }
    });
  }

  void clear() {
    setState(() {
      userInput = "";
      displayInput = "";
      previousInput = "";
      arithmetic = "";
    });
  }

  void _calcPercent() {
    setState(() {
      try {
        userInput = (double.parse(userInput) / 100).toString();
//        displayInput = userInput;
        setDisplayNumber(userInput);
      } catch (e) {
        final snackBar = SnackBar(content: Text('Error: ' + e.toString()));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    });
  }

  void setDisplayNumber(String x) {
    setState(() {
      var result = x.replaceAllMapped(
          new RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => "${m[1]},");
      String s = result.toString().replaceAll(RegExp(r"([.]*0)(?!.*\d)"), "");
      displayInput = s;
    });
  }

  void setInputNumber(String x) {
    setState(() {
      var result = x.replaceAllMapped(
          new RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => "${m[1]},");
      displayInput = result;
    });
  }

  void _calcFunction() {
    setState(() {
//      displayInput and userInput
      if (userInput.contains("-")) {
        userInput.replaceAll("-", "");
        displayInput = userInput;
      } else {
        userInput = "-" + userInput;
//        displayInput = userInput;
      setDisplayNumber(userInput);

      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final ButtonStyle style = ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(40.0),
    ));

    return Center(
      child: Column(
        children: <Widget>[
          Expanded(
            flex: 3,
            child: Container(
              padding: EdgeInsets.all(20),
              alignment: Alignment.centerRight,
              child: Text(
                displayInput,
                style: Theme.of(context).textTheme.headline1!,
//                  TextStyle(
//                      fontSize: 50,
//                      color: Colors.black),
                maxLines: 2,
              ),
            ),
          ),
          Expanded(
            flex: 6,
            child: Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Expanded(
                        flex: 1,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ConstrainedBox(
                            constraints: BoxConstraints.tightFor(
                                width: 80.0, height: 80.0),
                            child: MyButton(
                              buttonText: "AC",
                              textAlignment: TextAlign.center,
                              alignment: Alignment.center,
                              buttonTapped: () {
                                clear();
                              },
                              backgroundColor: Colors.white,
                              textColor: Theme.of(context).textTheme.headline4!,
                            ),
                          ),
                        )),
                    Expanded(
                        flex: 1,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ConstrainedBox(
                            constraints: BoxConstraints.tightFor(
                                width: 80.0, height: 80.0),
                            child: MyButton(
                              buttonText: "+/-",
                              textAlignment: TextAlign.center,
                              alignment: Alignment.center,
                              buttonTapped: () {
//                            input("+/-");
                                _calcFunction();
                              },
                              backgroundColor: Colors.white,
                              textColor: Theme.of(context).textTheme.headline4!,
                            ),
                          ),
                        )),
                    Expanded(
                        flex: 1,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ConstrainedBox(
                            constraints: BoxConstraints.tightFor(
                                width: 80.0, height: 80.0),
                            child: MyButton(
                              backgroundColor: Colors.white,
                              textAlignment: TextAlign.center,
                              alignment: Alignment.center,
                              textColor: Theme.of(context).textTheme.headline4!,
                              buttonTapped: () {
//                            input("%");
//                            equals();
                                _calcPercent();
                              },
                              buttonText: '%',
                            ),
                          ),
                        )),
                    Expanded(
                        flex: 1,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ConstrainedBox(
                            constraints: BoxConstraints.tightFor(
                                width: 80.0, height: 80.0),
                            child: MyButton(
                              backgroundColor: Colors.white,
                              alignment: Alignment.center,
                              textAlignment: TextAlign.center,
                              textColor: Theme.of(context).textTheme.headline3!,
                              buttonTapped: () {
//                                input("÷");
                                inputArithmetic("÷");
                              },
                              buttonText: '÷',
                            ),
                          ),
                        ))
                  ],
                ),
                Row(
                  children: <Widget>[
                    Expanded(
                        flex: 1,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ConstrainedBox(
                            constraints: BoxConstraints.tightFor(
                                width: 80.0, height: 80.0),
                            child: MyButton(
                              backgroundColor: Colors.white,
                              textAlignment: TextAlign.center,
                              alignment: Alignment.center,
                              textColor: Theme.of(context).textTheme.headline2!,
                              buttonTapped: () {
                                input("7");
                              },
                              buttonText: '7',
                            ),
                          ),
                        )),
                    Expanded(
                        flex: 1,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ConstrainedBox(
                            constraints: BoxConstraints.tightFor(
                                width: 80.0, height: 80.0),
                            child: MyButton(
                              backgroundColor: Colors.white,
                              textAlignment: TextAlign.center,
                              alignment: Alignment.center,
                              textColor: Theme.of(context).textTheme.headline2!,
                              buttonTapped: () {
                                input("8");
                              },
                              buttonText: '8',
                            ),
                          ),
                        )),
                    Expanded(
                        flex: 1,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ConstrainedBox(
                            constraints: BoxConstraints.tightFor(
                                width: 80.0, height: 80.0),
                            child: MyButton(
                              backgroundColor: Colors.white,
                              textAlignment: TextAlign.center,
                              alignment: Alignment.center,
                              textColor: Theme.of(context).textTheme.headline2!,
                              buttonTapped: () {
                                input("9");
                              },
                              buttonText: '9',
                            ),
                          ),
                        )),
                    Expanded(
                        flex: 1,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ConstrainedBox(
                            constraints: BoxConstraints.tightFor(
                                width: 80.0, height: 80.0),
                            child: MyButton(
                              backgroundColor: Colors.white,
                              textAlignment: TextAlign.center,
                              alignment: Alignment.center,
                              textColor: Theme.of(context).textTheme.headline3!,
                              buttonTapped: () {
//                                input("x");
                                inputArithmetic("x");
                              },
                              buttonText: 'x',
                            ),
                          ),
                        ))
                  ],
                ),
                Row(
                  children: <Widget>[
                    Expanded(
                        flex: 1,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ConstrainedBox(
                            constraints: BoxConstraints.tightFor(
                                width: 80.0, height: 80.0),
                            child: MyButton(
                              backgroundColor: Colors.white,
                              textAlignment: TextAlign.center,
                              alignment: Alignment.center,
                              textColor: Theme.of(context).textTheme.headline2!,
                              buttonTapped: () {
                                input("4");
                              },
                              buttonText: '4',
                            ),
                          ),
                        )),
                    Expanded(
                        flex: 1,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ConstrainedBox(
                            constraints: BoxConstraints.tightFor(
                                width: 80.0, height: 80.0),
                            child: MyButton(
                              backgroundColor: Colors.white,
                              textAlignment: TextAlign.center,
                              alignment: Alignment.center,
                              textColor: Theme.of(context).textTheme.headline2!,
                              buttonTapped: () {
                                input("5");
                              },
                              buttonText: '5',
                            ),
                          ),
                        )),
                    Expanded(
                        flex: 1,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ConstrainedBox(
                            constraints: BoxConstraints.tightFor(
                                width: 80.0, height: 80.0),
                            child: MyButton(
                              backgroundColor: Colors.white,
                              textAlignment: TextAlign.center,
                              alignment: Alignment.center,
                              textColor: Theme.of(context).textTheme.headline2!,
                              buttonTapped: () {
                                input("6");
                              },
                              buttonText: '6',
                            ),
                          ),
                        )),
                    Expanded(
                        flex: 1,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ConstrainedBox(
                            constraints: BoxConstraints.tightFor(
                                width: 80.0, height: 80.0),
                            child: MyButton(
                              backgroundColor: Colors.white,
                              textAlignment: TextAlign.center,
                              alignment: Alignment.center,
                              textColor: Theme.of(context).textTheme.headline3!,
                              buttonTapped: () {
//                                input("-");
                                inputArithmetic("-");
                              },
                              buttonText: '-',
                            ),
                          ),
                        ))
                  ],
                ),
                Row(
                  children: <Widget>[
                    Expanded(
                        flex: 1,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ConstrainedBox(
                            constraints: BoxConstraints.tightFor(
                                width: 80.0, height: 80.0),
                            child: MyButton(
                              backgroundColor: Colors.white,
                              textAlignment: TextAlign.center,
                              alignment: Alignment.center,
                              textColor: Theme.of(context).textTheme.headline2!,
                              buttonTapped: () {
                                input("1");
                              },
                              buttonText: '1',
                            ),
                          ),
                        )),
                    Expanded(
                        flex: 1,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ConstrainedBox(
                            constraints: BoxConstraints.tightFor(
                                width: 80.0, height: 80.0),
                            child: MyButton(
                              backgroundColor: Colors.white,
                              textAlignment: TextAlign.center,
                              alignment: Alignment.center,
                              textColor: Theme.of(context).textTheme.headline2!,
                              buttonTapped: () {
                                input("2");
                              },
                              buttonText: '2',
                            ),
                          ),
                        )),
                    Expanded(
                        flex: 1,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ConstrainedBox(
                            constraints: BoxConstraints.tightFor(
                                width: 80.0, height: 80.0),
                            child: MyButton(
                              backgroundColor: Colors.white,
                              textAlignment: TextAlign.center,
                              alignment: Alignment.center,
                              textColor: Theme.of(context).textTheme.headline2!,
                              buttonTapped: () {
                                input("3");
                              },
                              buttonText: '3',
                            ),
                          ),
                        )),
                    Expanded(
                        flex: 1,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ConstrainedBox(
                            constraints: BoxConstraints.tightFor(
                                width: 80.0, height: 80.0),
                            child: MyButton(
                              backgroundColor: Colors.white,
                              textAlignment: TextAlign.center,
                              alignment: Alignment.center,
                              textColor: Theme.of(context).textTheme.headline3!,
                              buttonTapped: () {
//                                input("+");
                                inputArithmetic("+");
                              },
                              buttonText: '+',
                            ),
                          ),
                        ))
                  ],
                ),
                Row(
                  children: <Widget>[
                    Expanded(
                        flex: 2,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ConstrainedBox(
                              constraints: BoxConstraints.tightFor(
                                  width: 176, height: 80),
                              child: MyButton(
                                backgroundColor: Colors.white,
                                textAlignment: TextAlign.start,
                                alignment: Alignment.centerLeft,
                                textColor:
                                    Theme.of(context).textTheme.headline2!,
                                buttonText: '0',
                                buttonTapped: () {
                                  input("0");
                                },
                              )),
                        )),
                    Expanded(
                        flex: 1,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ConstrainedBox(
                            constraints: BoxConstraints.tightFor(
                                width: 80.0, height: 80.0),
                            child: MyButton(
                              backgroundColor: Colors.white,
                              textAlignment: TextAlign.center,
                              alignment: Alignment.center,
                              textColor: Theme.of(context).textTheme.headline2!,
                              buttonTapped: () {
                                input(".");
                              },
                              buttonText: '.',
                            ),
                          ),
                        )),
                    Expanded(
                        flex: 1,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ConstrainedBox(
                            constraints: BoxConstraints.tightFor(
                                width: 80.0, height: 80.0),
                            child: MyButton(
                              backgroundColor: Colors.white,
                              textAlignment: TextAlign.center,
                              alignment: Alignment.center,
                              textColor: Theme.of(context).textTheme.headline3!,
                              buttonTapped: () {
//                                equals();
                                showResult();
                              },
                              buttonText: '=',
                            ),
                          ),
                        ))
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
