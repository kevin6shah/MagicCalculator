import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:hardware_buttons/hardware_buttons.dart' as HardwareButtons;
import 'contactsPage.dart';

List<String> phoneNumbers = [];

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String output = '0';
  String clearStatus = 'AC';
  double prev;
  int numPressed = 0;
  String phoneNumber;

  String operatorSelected;
  String operatorConfirmed;
  StreamSubscription<HardwareButtons.HomeButtonEvent> _homeButtonSubscription;

  @override
  void initState() {
    super.initState();
    _homeButtonSubscription = HardwareButtons.homeButtonEvents.listen((event) {
      setState(() {
        numPressed += 1;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    _homeButtonSubscription?.cancel();
  }

  void init() {
    output = '0';
    clearStatus = 'AC';
    operatorSelected = null;
    operatorConfirmed = null;
  }

  bool isNumeric(String s) {
    if (s == null) {
      return false;
    }
    return double.tryParse(s) != null;
  }

  String commaFormattedString(String s) {
    String temp;
    if (s.contains('.'))
      temp = s.substring(0, s.indexOf('.'));
    else
      temp = s;
    if (temp.length > 3) {
      for (int i = temp.length - 3; i >= 0; i = i - 3) {
        temp = temp.substring(0, i) +
            (temp.substring(0, i) != '' ? ',' : '') +
            temp.substring(i);
      }
    }
    if (s.contains('.'))
      return temp + s.substring(s.indexOf('.'));
    else
      return temp;
  }

  void removeFormatting() {
    List<String> test = output.split(',');
    output = '';
    for (int i = 0; i < test.length; i++) {
      output += test[i];
    }
  }

  String removeDecimalZeroFormat(double n) {
    return n.toStringAsFixed(n.truncateToDouble() == n ? 0 : 1);
  }

  void onTapped(String command) {
    setState(() {
      if (command == 'C' || command == 'AC') {
        init();
      } else if (command == '+/-') {
        if (output[0] == '-')
          output = output.substring(1);
        else
          output = '-' + output;
      } else if (command == '%') {
        removeFormatting();
        double compute = double.tryParse(output);
        compute = compute / 100;
        output = commaFormattedString(removeDecimalZeroFormat(compute));
      } else if (output == '0' || output == '-0') {
        if (command == '=') return;
        clearStatus = 'C';
        if (command == '.')
          output += '.';
        else if (command == '+' ||
            command == '−' ||
            command == '×' ||
            command == '÷')
          operatorSelected = command;
        else {
          if (output == '-0') {
            output = command;
            onTapped('+/-');
          } else
            output = command;
        }
      } else if (output.length < 13 && isNumeric(command)) {
        if (prev != null && operatorSelected != null) {
          output = '';
          operatorConfirmed = operatorSelected;
          operatorSelected = null;
        }
        removeFormatting();
        output += command;
        if (!output.contains('.'))
          output = commaFormattedString(output);
        else {
          int i = output.indexOf('.');
          output = commaFormattedString(output.substring(0, i)) +
              output.substring(i);
        }
      } else if (output.length < 11 &&
          command == '.' &&
          !output.contains('.')) {
        removeFormatting();
        output = commaFormattedString(output);
        output += '.';
      } else if (command == '+' ||
          command == '−' ||
          command == '×' ||
          command == '÷' ||
          command == '=') {
        if (command == '=' && phoneNumber != null) {
          String test = '';
          for (int i = 0; i < phoneNumber.length; i++) {
            if (isNumeric(phoneNumber[i])) test += phoneNumber[i];
          }
          if (test.length > 10) test = test.substring(test.length - 10);
          output = commaFormattedString(test);
        } else {
          if (operatorConfirmed != null) {
            removeFormatting();
            if (operatorConfirmed == '+') {
              prev = prev + double.tryParse(output);
            } else if (operatorConfirmed == '−') {
              prev = prev - double.tryParse(output);
            } else if (operatorConfirmed == '×') {
              prev = prev * double.tryParse(output);
            } else {
              prev = prev / double.tryParse(output);
            }
            output = commaFormattedString(removeDecimalZeroFormat(prev));
            if (command == '=')
              operatorSelected = null;
            else
              operatorSelected = command;
            operatorConfirmed = null;
          } else {
            operatorSelected = command;
            String temp = output;
            removeFormatting();
            prev = double.tryParse(output);
            output = temp;
          }
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (phoneNumbers.length != 0 &&
        numPressed <= phoneNumbers.length &&
        numPressed > 0) {
      phoneNumber = phoneNumbers[numPressed - 1];
    }

    if (numPressed > phoneNumbers.length) {
      phoneNumber = null;
      numPressed = 0;
    }

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return CupertinoApp(
      theme: CupertinoThemeData(
        scaffoldBackgroundColor: Colors.black,
        textTheme: CupertinoTextThemeData(
          primaryColor: CupertinoColors.activeBlue,
          textStyle: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      home: CupertinoPageScaffold(
        child: Center(
          child: Column(
            children: [
              Expanded(
                flex: 3,
                child: Container(
                  alignment: Alignment.bottomRight,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 35.0),
                    child: FittedBox(
                      fit: BoxFit.fitWidth,
                      child: Text(
                        output,
                        style: TextStyle(
                          fontSize: 85,
                          fontWeight: FontWeight.w200,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 5,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Button(
                            text: clearStatus,
                            buttonType: 'action',
                            onTapped: onTapped,
                          ),
                          Button(
                            text: '+/-',
                            buttonType: 'action',
                            onTapped: onTapped,
                          ),
                          Button(
                            text: '%',
                            buttonType: 'action',
                            onTapped: onTapped,
                          ),
                          Button(
                            text: '÷',
                            buttonType: 'operation',
                            onTapped: onTapped,
                            activate: operatorSelected == '÷',
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Button(
                            text: '7',
                            onTapped: onTapped,
                          ),
                          Button(
                            text: '8',
                            onTapped: onTapped,
                          ),
                          Button(
                            text: '9',
                            onTapped: onTapped,
                          ),
                          Button(
                            text: '×',
                            buttonType: 'operation',
                            onTapped: onTapped,
                            activate: operatorSelected == '×',
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Button(
                            text: '4',
                            onTapped: onTapped,
                          ),
                          Button(
                            text: '5',
                            onTapped: onTapped,
                          ),
                          Button(
                            text: '6',
                            onTapped: onTapped,
                          ),
                          Button(
                            text: '−',
                            buttonType: 'operation',
                            onTapped: onTapped,
                            activate: operatorSelected == '−',
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Button(
                            text: '1',
                            onTapped: onTapped,
                          ),
                          Button(
                            text: '2',
                            onTapped: onTapped,
                          ),
                          Button(
                            text: '3',
                            onTapped: onTapped,
                          ),
                          Button(
                            text: '+',
                            buttonType: 'operation',
                            onTapped: onTapped,
                            activate: operatorSelected == '+',
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Button(
                            text: '0',
                            buttonType: '0',
                            onTapped: onTapped,
                          ),
                          Button(
                            text: '.',
                            onTapped: onTapped,
                          ),
                          Button(
                            text: '=',
                            buttonType: 'operation',
                            onTapped: onTapped,
                          ),
                        ],
                      ),
                      SizedBox(height: 50),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Button extends StatelessWidget {
  String text;
  String buttonType;
  bool activate;
  void Function(String) onTapped;

  Map<String, CupertinoDynamicColor> colors = {
    'action': CupertinoColors.systemGrey2,
    'operation': CupertinoColors.activeOrange,
    null: CupertinoColors.secondaryLabel,
    '0': CupertinoColors.secondaryLabel,
  };

  Button({
    @required this.text,
    @required this.onTapped,
    this.buttonType,
    this.activate,
  });

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      pressedOpacity: 0.8,
      padding: EdgeInsets.all(0),
      onPressed: () {
        onTapped(text);
      },
      child: GestureDetector(
        onLongPress: () async {
          if (text == 'AC' || text == 'C') {
            Iterable<Contact> contacts = await ContactsService.getContacts();
            List<Contact> list = contacts.toList();
            Navigator.push(context,
                CupertinoPageRoute(builder: (context) => ContactsPage(list)));
          } else if (text == '0') {
            Navigator.push(context, CupertinoPageRoute(builder: (context) {
              return CupertinoPageScaffold(
                child: Center(
                  child: Text('Made by Kevin Shah'),
                ),
              );
            }));
          }
        },
        child: Stack(
          alignment:
              (buttonType == '0') ? Alignment.centerLeft : Alignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(50),
              child: Container(
                color: (activate != null && activate)
                    ? Colors.white
                    : colors[buttonType],
                height: 85,
                width: (buttonType == '0') ? 180 : 85,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: (buttonType == '0') ? 32 : 0),
              child: Text(
                text,
                style: TextStyle(
                  color: buttonType == 'action'
                      ? Colors.black
                      : (activate != null && activate)
                          ? CupertinoColors.activeOrange
                          : Colors.white,
                  fontSize: buttonType == 'action'
                      ? 30
                      : buttonType == 'operation' ? 45 : 35,
                  fontWeight: FontWeight.w500,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
