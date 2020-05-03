import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
      indicatorThings.add(
        FutureBuilder(
          initialData: null,
          future: SharedPreferences.getInstance(),
          builder: (context, AsyncSnapshot<SharedPreferences> snapshot) {
            List<String> phoneNumbers = [];
            if (snapshot.hasData && snapshot.data.containsKey('phoneNumbers'))
              phoneNumbers = snapshot.data.getStringList('phoneNumbers');
            return indicator(phones[i].value, phoneNumbers);
          },
        ),
      );
      indicatorThings.add(SizedBox(
        width: 5,
      ));
    }
    temp.add(Row(children: indicatorThings));
    return temp;
  }

  Widget indicator(String phone, List<String> phoneNumbers) {
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
          onTap: () async {
            SharedPreferences prefs = await SharedPreferences.getInstance();
            prefs.clear();
            setState(() {});
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
