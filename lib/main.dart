import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final List<String> calculationHistory = [];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SplashScreen(
        onInitializationComplete: () {},
      ),
      routes: {
        '/calculator': (context) => CalculatorScreen(calculationHistory),
        '/info': (context) => InfoScreen(calculationHistory),
      },
    );
  }
}

class SplashScreen extends StatefulWidget {
  final Function onInitializationComplete;

  SplashScreen({required this.onInitializationComplete});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    _initializeApp();
  }

  _initializeApp() async {
    await Future.delayed(Duration(seconds: 1));
    widget.onInitializationComplete();
    Navigator.pushReplacementNamed(context, '/calculator');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/splash.png'),
            SizedBox(height: 20),
            SpinKitChasingDots(
              color: Colors.blue,
              size: 50.0,
            ),
          ],
        ),
      ),
    );
  }
}

class CalculatorScreen extends StatefulWidget {
  final List<String> calculationHistory;

  CalculatorScreen(this.calculationHistory);

  @override
  _CalculatorScreenState createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  String display = '';
  String currentInput = '';
  String operator = '';
  bool hasDecimal = false;

  void onNumberClick(String value) {
    setState(() {
      currentInput += value;
      display = '$display$value';
    });
  }

  void onOperatorClick(String newOperator) {
    setState(() {
      if (currentInput.isNotEmpty) {
        if (operator.isNotEmpty) {
          calculateResult();
          display = result.toString();
        } else {
          result = double.parse(currentInput);
        }
        currentInput = '';
        operator = newOperator;
        hasDecimal = false;
        display = '$display $newOperator ';
      }
    });
  }

  void onDecimalClick() {
    if (!hasDecimal) {
      setState(() {
        currentInput += '.';
        display = '$display.';
        hasDecimal = true;
      });
    }
  }

  double result = 0;

  void calculateResult() {
    double value = double.parse(currentInput);
    String operation = '$result $operator $value = $result';
    widget.calculationHistory.add(operation);

    switch (operator) {
      case '+':
        result += value;
        break;
      case '-':
        result -= value;
        break;
      case '*':
        result *= value;
        break;
      case '/':
        if (value != 0) {
          result /= value;
        } else {
          display = 'Erro';
          return;
        }
        break;
    }
    operator = '';
    currentInput = '';
  }

  void onEqualClick() {
    setState(() {
      if (currentInput.isNotEmpty && operator.isNotEmpty) {
        calculateResult();
        String operation = '$display = $result';
        widget.calculationHistory.add(operation);
        currentInput = result.toString();
        display = currentInput;
        operator = '';
      }
    });
  }

  void onClearClick() {
    setState(() {
      currentInput = '';
      operator = '';
      result = 0;
      display = '';
      hasDecimal = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Calculadora'),
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            ListTile(
              title: Text('Calculadora'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text('Histórico de cálculos'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/info');
              },
            ),
          ],
        ),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: Container(
              padding: EdgeInsets.all(16.0),
              alignment: Alignment.centerRight,
              child: Text(
                display,
                style: TextStyle(fontSize: 24.0),
              ),
            ),
          ),
          Row(
            children: <Widget>[
              buildButton('7'),
              buildButton('8'),
              buildButton('9'),
              buildButton('/'),
            ],
          ),
          Row(
            children: <Widget>[
              buildButton('4'),
              buildButton('5'),
              buildButton('6'),
              buildButton('*'),
            ],
          ),
          Row(
            children: <Widget>[
              buildButton('1'),
              buildButton('2'),
              buildButton('3'),
              buildButton('-'),
            ],
          ),
          Row(
            children: <Widget>[
              buildButton('0'),
              buildButton('.'),
              buildButton('='),
              buildButton('+'),
            ],
          ),
          Row(
            children: <Widget>[
              buildButton('C'),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildButton(String label) {
    return Expanded(
      child: ElevatedButton(
        onPressed: () {
          if (label == '=') {
            onEqualClick();
          } else if (label == 'C') {
            onClearClick();
          } else if (label == '.') {
            onDecimalClick();
          } else if (label == '+' || label == '-' || label == '*' || label == '/') {
            onOperatorClick(label);
          } else {
            onNumberClick(label);
          }
        },
        child: Text(
          label,
          style: TextStyle(fontSize: 20.0),
        ),
      ),
    );
  }
}

class InfoScreen extends StatelessWidget {
  final List<String> calculationHistory;

  InfoScreen(this.calculationHistory);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Histórico de cálculos'),
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            ListTile(
              title: Text('Calculadora'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushReplacementNamed(context, '/calculator');
              },
            ),
            ListTile(
              title: Text('Histórico de cálculos'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
      body: ListView.builder(
        itemCount: calculationHistory.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(calculationHistory[index]),
          );
        },
      ),
    );
  }
}
