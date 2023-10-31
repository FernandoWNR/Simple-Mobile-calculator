import 'package:calculator/buttons_value.dart';
import 'package:flutter/material.dart';

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  String number1 = ""; // 0 - 9
  String operand = ""; // + - / *
  String number2 = ""; // 0 - 9
  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Scaffold(
        body: SafeArea(
      bottom: false,
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              reverse: true,
              child: Container(
                alignment: Alignment.bottomRight,
                padding: const EdgeInsets.all(16),
                child: Text(
                  "$number1$operand$number2".isEmpty
                      ? "0"
                      : "$number1$operand$number2",
                  style: const TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.end,
                ),
              ),
            ),
          ),
          //buttons
          Wrap(
            children: Btn.buttonValues
                .map((value) => SizedBox(
                    width: value == Btn.n0
                        ? screenSize.width / 2
                        : (screenSize.width / 4),
                    height: screenSize.width / 5,
                    child: buildButton(value)))
                .toList(),
          )
        ],
      ),
    ));
  }

  Widget buildButton(value) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Material(
        color: getBtnColor(value),
        clipBehavior:
            Clip.hardEdge, //when pressa boutton click hover not overflow
        shape: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.white24),
            borderRadius: BorderRadius.circular(
              (100),
            )),
        child: InkWell(
          onTap: () => onBtnTap(value),
          child: Center(
            child: Text(value,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: getButtonSize(value),
                )),
          ),
        ),
      ),
    );
  }

  void onBtnTap(String value) {
    if (value == Btn.del) {
      delete();
      return;
    }
    if (value == Btn.clr) {
      clearAll();
      return;
    }
    if (value == Btn.per) {
      convertToPercentage();
      return;
    }
    if (value == Btn.calculate) {
      calculate();
      return;
    }

    appendValue(value);
  }

// Delete Function
  void delete() {
    if (number2.isNotEmpty) {
      number2 = number2.substring(0, number2.length - 1);
    } else if (operand.isNotEmpty) {
      operand = "";
    } else if (number1.isNotEmpty) {
      number1 = number1.substring(0, number1.length - 1);
    }
    setState(() {});
  }

  //clear Function
  void clearAll() {
    setState(() {
      number1 = "";
      number2 = "";
      operand = "";
    });
  }

  // percentage Function
  void convertToPercentage() {
    if (number1.isNotEmpty && number2.isNotEmpty && operand.isNotEmpty) {
      // calculate before conversion
      calculate();
    }
    if (operand.isNotEmpty) {
      //Cannot Be converted
      return;
    }
    final number = double.parse(number1);
    setState(() {
      number1 = "${(number / 100)}%";
      operand = "";
      number2 = "";
    });
  }

  //Calculate Function
  void calculate() {
    if (number1.isEmpty || number2.isEmpty || operand.isEmpty) {
      return;
    }
    final double num1 = double.parse(number1);
    final double num2 = double.parse(number2);

    var results = 0.0;
    switch (operand) {
      case Btn.add:
        results = num1 + num2;
        break;
      case Btn.subtract:
        results = num1 - num2;
        break;
      case Btn.multiply:
        results = num1 * num2;
        break;
      case Btn.divide:
        results = num1 / num2;
        break;
      default:
    }
    setState(() {
      number1 = "$results";
      if (number1.endsWith(".0")) {
        number1 = number1.substring(0, number1.length - 2);
      }
      operand = "";
      number2 = "";
    });
  }

// String Value get Function
  void appendValue(String value) {
    if (value != Btn.dot && int.tryParse(value) == null) {
      if (operand.isNotEmpty && number2.isNotEmpty) {
        calculate();
      }

      operand = value;
    } else if (number1.isEmpty || operand.isEmpty) {
      //number1 = "1.2"
      if (value == Btn.dot && number1.contains(Btn.dot)) return;
      if (value == Btn.dot && (number1.isEmpty || number1 == Btn.n0)) {
// number = "" |"0"
        value = "0.";
      }

      number1 += value;
    } else if (number2.isEmpty || operand.isNotEmpty) {
      //number1 = "1.2"
      if (value == Btn.dot && number2.contains(Btn.dot)) return;
      if (value == Btn.dot && (number2.isEmpty || number1 == Btn.n0)) {
// number = "" |"0"
        value = "0.";
      }

      number2 += value;
    }

    setState(() {});
  }

  Color getBtnColor(value) {
    return [Btn.del, Btn.clr].contains(value)
        ? Colors.blueGrey
        : [
            Btn.per,
            Btn.multiply,
            Btn.add,
            Btn.subtract,
            Btn.divide,
            Btn.calculate,
          ].contains(value)
            ? Colors.orange
            : Colors.black87;
  }

  double getButtonSize(value) {
    return [
      Btn.per,
      Btn.multiply,
      Btn.add,
      Btn.subtract,
      Btn.divide,
      Btn.calculate,
    ].contains(value)
        ? 25
        : 18;
  }
}
