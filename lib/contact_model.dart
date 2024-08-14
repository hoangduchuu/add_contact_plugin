// ignore_for_file: prefer_collection_literals

import 'dart:typed_data';

import 'package:collection/collection.dart';
import 'package:flutter/services.dart';
import 'package:quiver/core.dart';

class Contact {
  Contact({
    this.identifier,
    this.displayName,
    this.givenName,
    this.middleName,
    this.prefix,
    this.suffix,
    this.familyName,
    this.company,
    this.jobTitle,
    this.emails,
    this.phones,
    this.postalAddresses,
    this.avatar,
    this.birthday,
    this.androidAccountType,
    this.androidAccountTypeRaw,
    this.androidAccountName,
    this.note,
    this.socialProfiles,
  });

  String? identifier, displayName, givenName, middleName, prefix, suffix, familyName, company, jobTitle;
  String? androidAccountTypeRaw, androidAccountName;
  AndroidAccountType? androidAccountType;
  List<Item>? emails = [];
  List<Item>? phones = [];
  List<PostalAddress>? postalAddresses = [];
  Uint8List? avatar;
  DateTime? birthday;
  String? note;
  List<SocialProfile>? socialProfiles = [];

  String initials() {
    return ((givenName?.isNotEmpty == true ? givenName![0] : "") +
            (familyName?.isNotEmpty == true ? familyName![0] : ""))
        .toUpperCase();
  }

  Contact.fromMap(Map m) {
    identifier = m["identifier"];
    displayName = m["displayName"];
    givenName = m["givenName"];
    middleName = m["middleName"];
    familyName = m["familyName"];
    prefix = m["prefix"];
    suffix = m["suffix"];
    company = m["company"];
    jobTitle = m["jobTitle"];
    androidAccountTypeRaw = m["androidAccountType"];
    androidAccountType = accountTypeFromString(androidAccountTypeRaw);
    androidAccountName = m["androidAccountName"];
    emails = (m["emails"] as List?)?.map((m) => Item.fromMap(m)).toList();
    phones = (m["phones"] as List?)?.map((m) => Item.fromMap(m)).toList();
    postalAddresses = (m["postalAddresses"] as List?)?.map((m) => PostalAddress.fromMap(m)).toList();
    avatar = m["avatar"];
    note = m["note"];
    socialProfiles = (m["socialProfiles"] as List?)?.map((m) => SocialProfile.fromMap(m)).toList();
    try {
      birthday = m["birthday"] != null ? DateTime.parse(m["birthday"]) : null;
    } catch (e) {
      birthday = null;
    }
  }

  static Map _toMap(Contact contact) {
    var emails = contact.emails?.map((email) => Item._toMap(email)).toList() ?? [];
    var phones = contact.phones?.map((phone) => Item._toMap(phone)).toList() ?? [];
    var postalAddresses = contact.postalAddresses?.map((address) => PostalAddress._toMap(address)).toList() ?? [];
    var socialProfiles = contact.socialProfiles?.map((profile) => SocialProfile._toMap(profile)).toList() ?? [];

    final birthday = contact.birthday == null
        ? null
        : "${contact.birthday!.year.toString()}-${contact.birthday!.month.toString().padLeft(2, '0')}-${contact.birthday!.day.toString().padLeft(2, '0')}";

    return {
      "identifier": contact.identifier,
      "displayName": contact.displayName,
      "givenName": contact.givenName,
      "middleName": contact.middleName,
      "familyName": contact.familyName,
      "prefix": contact.prefix,
      "suffix": contact.suffix,
      "company": contact.company,
      "jobTitle": contact.jobTitle,
      "androidAccountType": contact.androidAccountTypeRaw,
      "androidAccountName": contact.androidAccountName,
      "emails": emails,
      "phones": phones,
      "postalAddresses": postalAddresses,
      "avatar": contact.avatar,
      "birthday": birthday,
      "note": contact.note,
      "socialProfiles": socialProfiles,
    };
  }

  Map toMap() {
    return Contact._toMap(this);
  }

  /// The [+] operator fills in this contact's empty fields with the fields from [other]
  operator +(Contact other) => Contact(
        givenName: givenName ?? other.givenName,
        middleName: middleName ?? other.middleName,
        prefix: prefix ?? other.prefix,
        suffix: suffix ?? other.suffix,
        familyName: familyName ?? other.familyName,
        company: company ?? other.company,
        jobTitle: jobTitle ?? other.jobTitle,
        androidAccountType: androidAccountType ?? other.androidAccountType,
        androidAccountName: androidAccountName ?? other.androidAccountName,
        emails: emails == null ? other.emails : emails!.toSet().union(other.emails?.toSet() ?? Set()).toList(),
        phones: phones == null ? other.phones : phones!.toSet().union(other.phones?.toSet() ?? Set()).toList(),
        postalAddresses: postalAddresses == null
            ? other.postalAddresses
            : postalAddresses!.toSet().union(other.postalAddresses?.toSet() ?? Set()).toList(),
        avatar: avatar ?? other.avatar,
        birthday: birthday ?? other.birthday,
        note: note ?? other.note,
        socialProfiles: socialProfiles == null
            ? other.socialProfiles
            : socialProfiles!.toSet().union(other.socialProfiles?.toSet() ?? Set()).toList(),
      );

  /// Returns true if all items in this contact are identical.
  @override
  bool operator ==(Object other) {
    return other is Contact &&
        avatar == other.avatar &&
        company == other.company &&
        displayName == other.displayName &&
        givenName == other.givenName &&
        familyName == other.familyName &&
        identifier == other.identifier &&
        jobTitle == other.jobTitle &&
        androidAccountType == other.androidAccountType &&
        androidAccountName == other.androidAccountName &&
        middleName == other.middleName &&
        prefix == other.prefix &&
        suffix == other.suffix &&
        birthday == other.birthday &&
        note == other.note &&
        const DeepCollectionEquality.unordered().equals(phones, other.phones) &&
        const DeepCollectionEquality.unordered().equals(emails, other.emails) &&
        const DeepCollectionEquality.unordered().equals(postalAddresses, other.postalAddresses) &&
        const DeepCollectionEquality.unordered().equals(socialProfiles, other.socialProfiles);
  }

  @override
  int get hashCode {
    return hashObjects([
      company,
      displayName,
      familyName,
      givenName,
      identifier,
      jobTitle,
      androidAccountType,
      androidAccountName,
      middleName,
      prefix,
      suffix,
      birthday,
      note,
    ].where((s) => s != null));
  }

  AndroidAccountType? accountTypeFromString(String? androidAccountType) {
    if (androidAccountType == null) {
      return null;
    }
    if (androidAccountType.startsWith("com.google")) {
      return AndroidAccountType.google;
    } else if (androidAccountType.startsWith("com.whatsapp")) {
      return AndroidAccountType.whatsapp;
    } else if (androidAccountType.startsWith("com.facebook")) {
      return AndroidAccountType.facebook;
    }

    /// Other account types are not supported on Android
    /// such as Samsung, htc etc...
    return AndroidAccountType.other;
  }
}

class PostalAddress {
  PostalAddress({this.label, this.street, this.city, this.postcode, this.region, this.country});

  String? label, street, city, postcode, region, country;

  PostalAddress.fromMap(Map m) {
    label = m["label"];
    street = m["street"];
    city = m["city"];
    postcode = m["postcode"];
    region = m["region"];
    country = m["country"];
  }

  @override
  bool operator ==(Object other) {
    return other is PostalAddress &&
        city == other.city &&
        country == other.country &&
        label == other.label &&
        postcode == other.postcode &&
        region == other.region &&
        street == other.street;
  }

  @override
  int get hashCode {
    return hashObjects([
      label,
      street,
      city,
      country,
      region,
      postcode,
    ].where((s) => s != null));
  }

  static Map _toMap(PostalAddress address) => {
        "label": address.label,
        "street": address.street,
        "city": address.city,
        "postcode": address.postcode,
        "region": address.region,
        "country": address.country
      };

  @override
  String toString() {
    String finalString = "";
    if (street != null) {
      finalString += street!;
    }
    if (city != null) {
      if (finalString.isNotEmpty) {
        finalString += ", ${city!}";
      } else {
        finalString += city!;
      }
    }
    if (region != null) {
      if (finalString.isNotEmpty) {
        finalString += ", ${region!}";
      } else {
        finalString += region!;
      }
    }
    if (postcode != null) {
      if (finalString.isNotEmpty) {
        finalString += " ${postcode!}";
      } else {
        finalString += postcode!;
      }
    }
    if (country != null) {
      if (finalString.isNotEmpty) {
        finalString += ", ${country!}";
      } else {
        finalString += country!;
      }
    }
    return finalString;
  }
}

class Item {
  Item({this.label, this.value});

  String? label, value;

  Item.fromMap(Map m) {
    label = m["label"];
    value = m["value"];
  }

  @override
  bool operator ==(Object other) {
    return other is Item && label == other.label && value == other.value;
  }

  @override
  int get hashCode => hash2(label ?? "", value ?? "");

  static Map _toMap(Item i) => {"label": i.label, "value": i.value};
}

class SocialProfile {
  SocialProfile({this.label, this.urlString, this.username, this.service});

  String? label, urlString, username, service;

  SocialProfile.fromMap(Map m) {
    label = m["label"];
    urlString = m["urlString"];
    username = m["username"];
    service = m["service"];
  }

  static Map _toMap(SocialProfile profile) => {
        "label": profile.label,
        "urlString": profile.urlString,
        "username": profile.username,
        "service": profile.service,
      };

  @override
  bool operator ==(Object other) {
    return other is SocialProfile &&
        label == other.label &&
        urlString == other.urlString &&
        username == other.username &&
        service == other.service;
  }

  @override
  int get hashCode => hashObjects([label, urlString, username, service]);
}

enum AndroidAccountType { facebook, google, whatsapp, other }
