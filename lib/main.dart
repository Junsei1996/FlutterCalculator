import 'dart:ffi';

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
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
              primary: Colors.black, onPrimary: Colors.white),
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
  var lastInput = ""; // last input(only for display)
  var previousInput = '';
  var arithmetic = '';

//  var answer = '';
  bool equalsClicked = false;

  void input(String x) {
    setState(() {
      userInput = userInput + x;
      if (x != '+' &&
          x != '-' &&
          x != 'x' &&
          x != '÷' &&
          x != '%' &&
          x != '+/-') {
        lastInput = userInput;
      }
    });
  }

  void clear() {
    setState(() {
      userInput = "";
      lastInput = "";
//      previousInput = "";
//      arithmetic = "";
//      answer = "";
    });
  }

  void _calcPercent() {
    setState(() {
      try {
        userInput = (double.parse(userInput) / 100).toString();
      } catch (e) {
        final snackBar = SnackBar(content: Text('Error: ' + e.toString()));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    });
  }

  void setDisplayNumber(String x){

    setState(() {
      var result = x.replaceAllMapped(new RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => "${m[1]},");
      lastInput = result;
    });

  }

  void _calcFunction() {
    setState(() {
      try {

        var value = lastInput.replaceAll(",", "");
        var x = userInput.lastIndexOf(value);

        

        if (lastInput.contains("-")) {
          lastInput = lastInput.replaceAll("-", "");
        } else {
          lastInput = "-" + lastInput;
        }
      } catch (e) {
        final snackBar = SnackBar(content: Text('Error: ' + e.toString()));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    });
  }

  void equals() {
    setState(() {
      try {
        String finaluserinput = "";
        finaluserinput = userInput.replaceAll("x", "*");
        finaluserinput = finaluserinput.replaceAll("÷", "/");
        Parser p = Parser();
        Expression exp = p.parse(finaluserinput);
        ContextModel cm = ContextModel();
        double eval = exp.evaluate(EvaluationType.REAL, cm);
        var answer = eval.toString();
        userInput = answer;
        lastInput = userInput;
      } catch (e) {
        final snackBar = SnackBar(content: Text('Error: ' + e.toString()));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final ButtonStyle style = ElevatedButton.styleFrom(
        textStyle: const TextStyle(
          fontSize: 30,
          color: Color(0xFF000000),
        ),
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
                lastInput,
                style: TextStyle(fontSize: 50, color: Colors.black),
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
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ConstrainedBox(
                        constraints:
                            BoxConstraints.tightFor(width: 80.0, height: 80.0),
                        child: MyButton(
                          buttonText: "AC",
                          buttonTapped: () {
                            clear();
                          },
                          backgroundColor: Colors.white,
                          textColor: Colors.grey,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ConstrainedBox(
                        constraints:
                            BoxConstraints.tightFor(width: 80.0, height: 80.0),
                        child: MyButton(
                          buttonText: "+/-",
                          buttonTapped: () {
//                            input("+/-");
                            _calcFunction();
                          },
                          backgroundColor: Colors.white,
                          textColor: Colors.grey,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ConstrainedBox(
                        constraints:
                            BoxConstraints.tightFor(width: 80.0, height: 80.0),
                        child: MyButton(
                          backgroundColor: Colors.white,
                          textColor: Colors.grey,
                          buttonTapped: () {
//                            input("%");
//                            equals();
                            _calcPercent();
                          },
                          buttonText: '%',
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ConstrainedBox(
                        constraints:
                            BoxConstraints.tightFor(width: 80.0, height: 80.0),
                        child: MyButton(
                          backgroundColor: Colors.white,
                          textColor: Colors.orange,
                          buttonTapped: () {
                            input("÷");
                          },
                          buttonText: '÷',
                        ),
                      ),
                    )
                  ],
                ),
                Row(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ConstrainedBox(
                        constraints:
                            BoxConstraints.tightFor(width: 80.0, height: 80.0),
                        child: MyButton(
                          backgroundColor: Colors.white,
                          textColor: Colors.black,
                          buttonTapped: () {
                            input("7");
                          },
                          buttonText: '7',
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ConstrainedBox(
                        constraints:
                            BoxConstraints.tightFor(width: 80.0, height: 80.0),
                        child: MyButton(
                          backgroundColor: Colors.white,
                          textColor: Colors.black,
                          buttonTapped: () {
                            input("8");
                          },
                          buttonText: '8',
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ConstrainedBox(
                        constraints:
                            BoxConstraints.tightFor(width: 80.0, height: 80.0),
                        child: MyButton(
                          backgroundColor: Colors.white,
                          textColor: Colors.black,
                          buttonTapped: () {
                            input("9");
                          },
                          buttonText: '9',
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ConstrainedBox(
                        constraints:
                            BoxConstraints.tightFor(width: 80.0, height: 80.0),
                        child: MyButton(
                          backgroundColor: Colors.white,
                          textColor: Colors.orange,
                          buttonTapped: () {
                            input("x");
                          },
                          buttonText: 'x',
                        ),
                      ),
                    )
                  ],
                ),
                Row(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ConstrainedBox(
                        constraints:
                            BoxConstraints.tightFor(width: 80.0, height: 80.0),
                        child: MyButton(
                          backgroundColor: Colors.white,
                          textColor: Colors.black,
                          buttonTapped: () {
                            input("4");
                          },
                          buttonText: '4',
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ConstrainedBox(
                        constraints:
                            BoxConstraints.tightFor(width: 80.0, height: 80.0),
                        child: MyButton(
                          backgroundColor: Colors.white,
                          textColor: Colors.black,
                          buttonTapped: () {
                            input("5");
                          },
                          buttonText: '5',
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ConstrainedBox(
                        constraints:
                            BoxConstraints.tightFor(width: 80.0, height: 80.0),
                        child: MyButton(
                          backgroundColor: Colors.white,
                          textColor: Colors.black,
                          buttonTapped: () {
                            input("6");
                          },
                          buttonText: '6',
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ConstrainedBox(
                        constraints:
                            BoxConstraints.tightFor(width: 80.0, height: 80.0),
                        child: MyButton(
                          backgroundColor: Colors.white,
                          textColor: Colors.orange,
                          buttonTapped: () {
                            input("-");
                          },
                          buttonText: '-',
                        ),
                      ),
                    )
                  ],
                ),
                Row(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ConstrainedBox(
                        constraints:
                            BoxConstraints.tightFor(width: 80.0, height: 80.0),
                        child: MyButton(
                          backgroundColor: Colors.white,
                          textColor: Colors.black,
                          buttonTapped: () {
                            input("1");
                          },
                          buttonText: '1',
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ConstrainedBox(
                        constraints:
                            BoxConstraints.tightFor(width: 80.0, height: 80.0),
                        child: MyButton(
                          backgroundColor: Colors.white,
                          textColor: Colors.black,
                          buttonTapped: () {
                            input("2");
                          },
                          buttonText: '2',
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ConstrainedBox(
                        constraints:
                            BoxConstraints.tightFor(width: 80.0, height: 80.0),
                        child: MyButton(
                          backgroundColor: Colors.white,
                          textColor: Colors.black,
                          buttonTapped: () {
                            input("3");
                          },
                          buttonText: '3',
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ConstrainedBox(
                        constraints:
                            BoxConstraints.tightFor(width: 80.0, height: 80.0),
                        child: MyButton(
                          backgroundColor: Colors.white,
                          textColor: Colors.orange,
                          buttonTapped: () {
                            input("+");
                          },
                          buttonText: '+',
                        ),
                      ),
                    )
                  ],
                ),
                Row(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ConstrainedBox(
                          constraints:
                              BoxConstraints.tightFor(width: 176, height: 80),
                          child: MyButton(
                            backgroundColor: Colors.white,
                            textColor: Colors.black,
                            buttonText: '0',
                            buttonTapped: () {
                              input("0");
                            },
                          )),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ConstrainedBox(
                        constraints:
                            BoxConstraints.tightFor(width: 80.0, height: 80.0),
                        child: MyButton(
                          backgroundColor: Colors.white,
                          textColor: Colors.black,
                          buttonTapped: () {
                            input(".");
                          },
                          buttonText: '.',
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ConstrainedBox(
                        constraints:
                            BoxConstraints.tightFor(width: 80.0, height: 80.0),
                        child: MyButton(
                          backgroundColor: Colors.white,
                          textColor: Colors.orange,
                          buttonTapped: () {
                            equals();
                          },
                          buttonText: '=',
                        ),
                      ),
                    )
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
