import 'package:add_contact_ios/contact_model.dart';
import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:add_contact_ios/add_contact_ios.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _addContactIosPlugin = AddContactIos();

  @override
  void initState() {
    super.initState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: TextButton(
            onPressed: () {
              var contact = mockContact;
              _addContactIosPlugin.addContact(contact: contact).then((value) {
                print('Add contact success');
              });
            },
            child: const Text('Add Contact'),
          ),
        ),
      ),
    );
  }
}

final mockContact = Contact(
  displayName: "BI-DISPLAY",
  givenName: "HOANG DUC",
  middleName: "HUU",
  prefix: "Mr.",
  suffix: "Jr.",
  familyName: "BEE",
  company: "Carrots Labs🥕",
  jobTitle: "Flutter  Engineer",
  emails: [
    Item(label: "work", value: "huu@carrots.so"),
    Item(label: "personal", value: "Hoangduchuuvn@gmail.com"),
  ],
  phones: [
    Item(label: "mobile", value: "+1 (555) 123-4567"),
    Item(label: "work", value: "+1 (555) 987-6543"),
  ],
  postalAddresses: [
    PostalAddress(
      label: "home",
      street: "80 Quoc Lo 13",
      city: "Ho CHi Minh",
      postcode: "12345",
      region: "VN",
      country: "VN",
    ),
    PostalAddress(
      label: "Daklak-Home",
      street: "56 Xuan Phu - Phu Xuan",
      city: "Krong Nang",
      postcode: "12345",
      region: "VN",
      country: "VN",
    ),
  ],
  socialProfiles: [
    SocialProfile(
      label: "twitter",
      urlString: "https://twitter.com/hoangduchuuvn",
      username: "hoangduchuuvn",
      service: "twitter",
    ),
    SocialProfile(
      label: "facebook",
      urlString: "https://facebook.com/hoangduchuuvn",
      username: "hoangduchuuvn",
      service: "facebook",
    ),
  ],
  avatar: Uint8List.fromList([0, 1, 2, 3, 4, 5]),
  birthday: DateTime(1994, 1, 1),
  androidAccountType: AndroidAccountType.google,
  androidAccountTypeRaw: "com.google",
  androidAccountName: "johndoe@gmail.com",
);
