import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:magicCalculator/main.dart';

class PhonePage extends StatelessWidget {
  Contact contact;
  PhonePage(this.contact);
  List<Item> phones;

  @override
  Widget build(BuildContext context) {
    phones = contact.phones.toList();

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
                    ],
                  ),
                ),
                onPressed: () {
                  phoneNumber = phones[index].value;
                  Navigator.pop(context);
                  Navigator.pop(context);
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
