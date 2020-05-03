import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:magicCalculator/main.dart';

class PhonePage extends StatefulWidget {
  Contact contact;
  PhonePage(this.contact);

  @override
  _PhonePageState createState() => _PhonePageState();
}

class _PhonePageState extends State<PhonePage> {
  List<Item> phones;

  @override
  Widget build(BuildContext context) {
    phones = widget.contact.phones.toList();

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        backgroundColor: CupertinoColors.darkBackgroundGray,
        previousPageTitle: 'Contacts',
        middle: Text(
          'Phone Selection',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      child: ListView.builder(
        itemCount: phones.length,
        itemBuilder: (context, index) {
          return Column(
            children: [
              CupertinoButton(
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  child: Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: Text(
                          phones[index].label,
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 5,
                        child: Text(
                          phones[index].value,
                        ),
                      ),
                      Expanded(
                        flex: 0,
                        child: indicator(phones[index].value),
                      ),
                    ],
                  ),
                ),
                onPressed: () {
                  setState(() {
                    phoneNumbers.add(phones[index].value);
                  });
                },
              ),
              Divider(
                color: CupertinoColors.inactiveGray,
                height: 0,
                indent: 15,
                endIndent: 15,
              )
            ],
          );
        },
      ),
    );
  }
}

Widget indicator(String phone) {
  return Stack(
    alignment: Alignment.center,
    children: [
      ClipRRect(
        borderRadius: BorderRadius.circular(50),
        child: Container(
          color: (phoneNumbers.contains(phone)) ? Colors.white : Colors.black,
          height: 20,
          width: 20,
        ),
      ),
      Text(
        (phoneNumbers.indexOf(phone) + 1).toString(),
        style: TextStyle(
          color: Colors.black,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    ],
  );
}
