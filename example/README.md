# Add Contact Plugin

## Overview

**Add Contact Plugin**  is a plugin to open "New Contact" popup native ios so user can add the
contact to device

[![pub  
package](https://img.shields.io/pub/v/add_contact_plugin.svg)](https://pub.dartlang.org/packages/add_contact_plugin)  
<a href="https://pub.dev/packages/fl_chart"><img alt="GitHub Repo  
stars"  
src="https://img.shields.io/github/stars/hoangduchuu/add_contact_plugin"></a>  
<a href="https://github.com/hoangduchuu/add_contact_plugin/graphs/contributors"><img  
alt="GitHub contributors"  
src="https://img.shields.io/github/contributors/hoangduchuu/add_contact_plugin"></a>  
<a href="https://githubc.comhoangduchuu/add_contact_pluginissues?q=is%3Aissue+is%3Aclosed"><img  
src="https://img.shields.io/github/issues-closed-raw/hoangduchuu/add_contact_plugin"  
alt="GitHub closed issues"> </a>

## Usage

### 1. Mock the Contact model

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
        Item(label: "personal", value: "example@gmail.com"),  
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

### 2. Open the ios dialog

    AddContactIos().addContact(contact: contact)

## Showcase

![](https://raw.githubusercontent.com/hoangduchuu/add_contact_plugin/main/showcase/showcase.gif)