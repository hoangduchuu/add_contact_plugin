import 'package:add_contact_ios/contact_model.dart';

class QrCodeUtils {
  //region contact info
  static Contact? extractContactInfo({required String code}) {
    try {
      if (code.startsWith('BEGIN:VCARD')) {
        return _extractVCard(code);
      } else if (code.startsWith('MECARD:')) {
        return _extractMeCard(code);
      } else {
        return null;
      }
    } on Exception catch (_) {
      return null;
    }
  }

  static Contact _extractVCard(String code) {
    final lines = code.split('\n');
    final contact = Contact();
    String? currentKey;
    String currentValue = '';

    for (var line in lines) {
      if (line.startsWith(' ') && currentKey != null) {
        // This is a continuation of the previous line
        currentValue += line.trim();
      } else {
        // Process the previous key-value pair
        if (currentKey != null) {
          _processVCardField(contact, currentKey, currentValue);
        }

        // Start a new key-value pair
        final parts = line.split(':');
        if (parts.length >= 2) {
          currentKey = parts[0].split(';')[0];
          currentValue = parts.sublist(1).join(':').trim();
        }
      }
    }

    // Process the last key-value pair
    if (currentKey != null) {
      _processVCardField(contact, currentKey, currentValue);
    }

    return contact;
  }

  static void _processVCardField(Contact contact, String key, String value) {
    switch (key) {
      case 'N':
        final nameParts = value.split(';');
        contact.familyName = nameParts.isNotEmpty && nameParts[0].isNotEmpty ? nameParts[0] : null;
        contact.givenName = nameParts.length > 1 && nameParts[1].isNotEmpty ? nameParts[1] : null;
        contact.middleName = nameParts.length > 2 && nameParts[2].isNotEmpty ? nameParts[2] : null;
        contact.prefix = nameParts.length > 3 && nameParts[3].isNotEmpty ? nameParts[3] : null;
        contact.suffix = nameParts.length > 4 && nameParts[4].isNotEmpty ? nameParts[4] : null;
        break;
      case 'FN':
        contact.displayName = value.isNotEmpty ? value : null;
        break;
      case 'ORG':
        contact.company = value.isNotEmpty ? value : null;
        break;
      case 'TITLE':
        contact.jobTitle = value.isNotEmpty ? value : null;
        break;
      case 'TEL':
        contact.phones ??= [];
        String? label = 'other';
        if (key.contains('TYPE=')) {
          final typeMatch = RegExp(r'TYPE=(\w+)').firstMatch(key);
          if (typeMatch != null) {
            label = typeMatch.group(1)?.toLowerCase();
          }
        } else if (key.contains('WORK')) {
          label = 'work';
        } else if (key.contains('CELL')) {
          label = 'mobile';
        } else if (key.contains('FAX')) {
          label = 'fax';
        } else if (key.contains('HOME')) {
          label = 'home';
        }
        contact.phones!.add(Item(label: label, value: value.isNotEmpty ? value : null));
        break;
      case 'EMAIL':
        contact.emails ??= [];
        String? label = 'other';
        if (key.contains('TYPE=')) {
          final typeMatch = RegExp(r'TYPE=(\w+)').firstMatch(key);
          if (typeMatch != null) {
            label = typeMatch.group(1)?.toLowerCase();
          }
        } else if (key.contains('WORK')) {
          label = 'work';
        } else if (key.contains('HOME')) {
          label = 'home';
        }
        contact.emails!.add(Item(label: label, value: value.isNotEmpty ? value : null));
        break;
      case 'ADR':
        final addressParts = value.split(';');
        contact.postalAddresses ??= [];
        String? label = 'other';
        if (key.contains('TYPE=')) {
          final typeMatch = RegExp(r'TYPE=(\w+)').firstMatch(key);
          if (typeMatch != null) {
            label = typeMatch.group(1)?.toLowerCase();
          }
        } else if (key.contains('WORK')) {
          label = 'work';
        } else if (key.contains('HOME')) {
          label = 'home';
        }
        contact.postalAddresses!.add(PostalAddress(
          label: label,
          street: addressParts.length > 2 && addressParts[2].isNotEmpty ? addressParts[2].replaceAll('\\,', ',') : null,
          city: addressParts.length > 3 && addressParts[3].isNotEmpty ? addressParts[3] : null,
          region: addressParts.length > 4 && addressParts[4].isNotEmpty ? addressParts[4] : null,
          postcode: addressParts.length > 5 && addressParts[5].isNotEmpty ? addressParts[5] : null,
          country: addressParts.length > 6 && addressParts[6].isNotEmpty ? addressParts[6] : null,
        ));
        break;
      case 'NOTE':
        contact.note = value.isNotEmpty ? value : null;
        break;
      case 'BDAY':
        try {
          contact.birthday = value.isNotEmpty ? DateTime.parse(value) : null;
        } catch (e) {
          // Invalid date format, ignore
        }
        break;
      case 'URL':
        contact.urlAddresses ??= [];
        String? label = 'other';
        if (key.contains('TYPE=')) {
          final typeMatch = RegExp(r'TYPE=(\w+)').firstMatch(key);
          if (typeMatch != null) {
            label = typeMatch.group(1)?.toLowerCase();
          }
        } else if (key.contains('WORK')) {
          label = 'work';
        } else if (key.contains('HOME')) {
          label = 'home';
        }
        contact.urlAddresses!.add(Item(label: label, value: value.isNotEmpty ? value : null));
        break;
    }
  }

  static Contact _extractMeCard(String code) {
    final fields = code.substring(7).split(';');
    final contact = Contact();

    for (var field in fields) {
      final parts = field.split(':');
      if (parts.length < 2) continue;

      final key = parts[0];
      final value = parts.sublist(1).join(':');

      switch (key) {
        case 'N':
          final nameParts = value.split(',');
          contact.familyName = nameParts.isNotEmpty ? nameParts[0] : null;
          contact.givenName = nameParts.length > 1 ? nameParts[1] : null;
          break;
        case 'TEL':
          contact.phones ??= [];
          contact.phones!.add(Item(value: value.isNotEmpty ? value : null));
          break;
        case 'EMAIL':
          contact.emails ??= [];
          contact.emails!.add(Item(value: value.isNotEmpty ? value : null));
          break;
        case 'ADR':
          contact.postalAddresses ??= [];
          contact.postalAddresses!.add(PostalAddress(
            street: value.isNotEmpty ? value : null,
          ));
          break;
        case 'NOTE':
          contact.note = value.isNotEmpty ? value : null;
          break;
        case 'BDAY':
          try {
            contact.birthday = value.isNotEmpty ? DateTime.parse(value) : null;
          } catch (e) {
            // Invalid date format, ignore
          }
          break;
        case 'ORG':
          contact.company = value.isNotEmpty ? value : null;
          break;
        case 'TITLE':
          contact.jobTitle = value.isNotEmpty ? value : null;
          break;
        case 'URL':
          contact.urlAddresses ??= [];
          contact.urlAddresses!.add(Item(value: value.isNotEmpty ? value : null));
          break;
      }
    }

    return contact;
  }

//endregion contact info
}