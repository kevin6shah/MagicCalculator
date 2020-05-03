import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:magicCalculator/main.dart';
import 'phonePage.dart';

class ContactsPage extends StatefulWidget {
  List<Contact> contacts;
  ContactsPage(this.contacts);

  @override
  _ContactsPageState createState() => _ContactsPageState();
}

class _ContactsPageState extends State<ContactsPage> {
  List<Widget> indicators(Contact c) {
    List<Widget> indicatorThings = [];
    List<Widget> temp = [
      Text(
        c.displayName,
        style: TextStyle(
          color: CupertinoColors.white,
        ),
      ),
    ];
    List<Item> phones = c.phones.toList();
    for (int i = 0; i < phones.length; i++) {
      if (phoneNumbers.contains(phones[i].value)) {
        indicatorThings.add(indicator(phones[i].value));
        indicatorThings.add(SizedBox(
          width: 5,
        ));
      }
    }
    temp.add(Row(
      children: indicatorThings,
    ));
    return temp;
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        trailing: GestureDetector(
          child: Text(
            'Clear',
            style: TextStyle(
              fontSize: 14,
              color: CupertinoColors.activeBlue,
            ),
          ),
          onTap: () {
            setState(() {
              phoneNumbers.clear();
            });
          },
        ),
        backgroundColor: CupertinoColors.darkBackgroundGray,
        previousPageTitle: 'Calculator',
        middle: Text(
          'Contacts',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      child: ListView.builder(
        itemCount: widget.contacts.length,
        itemBuilder: (context, index) {
          return Column(
            children: [
              CupertinoButton(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: indicators(widget.contacts[index]),
                ),
                onPressed: () => Navigator.push(
                  context,
                  CupertinoPageRoute(
                    builder: (context) => PhonePage(widget.contacts[index]),
                  ),
                ).then((value) {
                  setState(() {});
                }),
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
