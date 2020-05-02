import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:magicCalculator/main.dart';

import 'phonePage.dart';

class ContactsPage extends StatelessWidget {
  List<Contact> contacts;
  ContactsPage(this.contacts);

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
            phoneNumber = null;
            Navigator.pop(context);
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
        itemCount: contacts.length,
        itemBuilder: (context, index) {
          return Column(
            children: [
              CupertinoButton(
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  child: Text(
                    contacts[index].displayName,
                    style: TextStyle(
                      color: CupertinoColors.white,
                    ),
                  ),
                ),
                onPressed: () => Navigator.push(
                  context,
                  CupertinoPageRoute(
                    builder: (context) => PhonePage(contacts[index]),
                  ),
                ),
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
