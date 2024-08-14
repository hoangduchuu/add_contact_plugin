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
    return ((this.givenName?.isNotEmpty == true ? this.givenName![0] : "") +
            (this.familyName?.isNotEmpty == true ? this.familyName![0] : ""))
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
        givenName: this.givenName ?? other.givenName,
        middleName: this.middleName ?? other.middleName,
        prefix: this.prefix ?? other.prefix,
        suffix: this.suffix ?? other.suffix,
        familyName: this.familyName ?? other.familyName,
        company: this.company ?? other.company,
        jobTitle: this.jobTitle ?? other.jobTitle,
        androidAccountType: this.androidAccountType ?? other.androidAccountType,
        androidAccountName: this.androidAccountName ?? other.androidAccountName,
        emails:
            this.emails == null ? other.emails : this.emails!.toSet().union(other.emails?.toSet() ?? Set()).toList(),
        phones:
            this.phones == null ? other.phones : this.phones!.toSet().union(other.phones?.toSet() ?? Set()).toList(),
        postalAddresses: this.postalAddresses == null
            ? other.postalAddresses
            : this.postalAddresses!.toSet().union(other.postalAddresses?.toSet() ?? Set()).toList(),
        avatar: this.avatar ?? other.avatar,
        birthday: this.birthday ?? other.birthday,
        note: this.note ?? other.note,
        socialProfiles: this.socialProfiles == null
            ? other.socialProfiles
            : this.socialProfiles!.toSet().union(other.socialProfiles?.toSet() ?? Set()).toList(),
      );

  /// Returns true if all items in this contact are identical.
  @override
  bool operator ==(Object other) {
    return other is Contact &&
        this.avatar == other.avatar &&
        this.company == other.company &&
        this.displayName == other.displayName &&
        this.givenName == other.givenName &&
        this.familyName == other.familyName &&
        this.identifier == other.identifier &&
        this.jobTitle == other.jobTitle &&
        this.androidAccountType == other.androidAccountType &&
        this.androidAccountName == other.androidAccountName &&
        this.middleName == other.middleName &&
        this.prefix == other.prefix &&
        this.suffix == other.suffix &&
        this.birthday == other.birthday &&
        this.note == other.note &&
        DeepCollectionEquality.unordered().equals(this.phones, other.phones) &&
        DeepCollectionEquality.unordered().equals(this.emails, other.emails) &&
        DeepCollectionEquality.unordered().equals(this.postalAddresses, other.postalAddresses) &&
        DeepCollectionEquality.unordered().equals(this.socialProfiles, other.socialProfiles);
  }

  @override
  int get hashCode {
    return hashObjects([
      this.company,
      this.displayName,
      this.familyName,
      this.givenName,
      this.identifier,
      this.jobTitle,
      this.androidAccountType,
      this.androidAccountName,
      this.middleName,
      this.prefix,
      this.suffix,
      this.birthday,
      this.note,
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
        this.city == other.city &&
        this.country == other.country &&
        this.label == other.label &&
        this.postcode == other.postcode &&
        this.region == other.region &&
        this.street == other.street;
  }

  @override
  int get hashCode {
    return hashObjects([
      this.label,
      this.street,
      this.city,
      this.country,
      this.region,
      this.postcode,
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
    if (this.street != null) {
      finalString += this.street!;
    }
    if (this.city != null) {
      if (finalString.isNotEmpty) {
        finalString += ", " + this.city!;
      } else {
        finalString += this.city!;
      }
    }
    if (this.region != null) {
      if (finalString.isNotEmpty) {
        finalString += ", " + this.region!;
      } else {
        finalString += this.region!;
      }
    }
    if (this.postcode != null) {
      if (finalString.isNotEmpty) {
        finalString += " " + this.postcode!;
      } else {
        finalString += this.postcode!;
      }
    }
    if (this.country != null) {
      if (finalString.isNotEmpty) {
        finalString += ", " + this.country!;
      } else {
        finalString += this.country!;
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
    return other is Item && this.label == other.label && this.value == other.value;
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
        this.label == other.label &&
        this.urlString == other.urlString &&
        this.username == other.username &&
        this.service == other.service;
  }

  @override
  int get hashCode => hashObjects([label, urlString, username, service]);
}

enum AndroidAccountType { facebook, google, whatsapp, other }
