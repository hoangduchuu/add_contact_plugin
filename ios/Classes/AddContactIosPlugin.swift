import Flutter
import UIKit
import Contacts
import ContactsUI

enum ContactOperationResult: String {
    case saved = "saved"
    case cancelled = "cancelled"
    case error = "error"
}

public class AddContactIosPlugin: NSObject, FlutterPlugin, CNContactViewControllerDelegate {
    var result: FlutterResult?

    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "add_contact_ios", binaryMessenger: registrar.messenger())
        let instance = AddContactIosPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        self.result = result
        switch call.method {
        case "addContact":
            guard let args = call.arguments as? [String: Any],
                  let contactData = args["contact"] as? [String: Any?] else {
                result(FlutterError(code: "INVALID_ARGUMENT", message: "Invalid contact data", details: nil))
                return
            }
            addContact(contactData: contactData)
        case "openVCard":
            guard let args = call.arguments as? [String: Any],
                  let vCardData = args["vCard"] as? [String: Any?] else {
                result(FlutterError(code: "INVALID_ARGUMENT", message: "Invalid vCard data", details: nil))
                return
            }
            openVCard(vCardData: vCardData)
        default:
            result(FlutterMethodNotImplemented)
        }
    }

    private func addContact(contactData: [String: Any?]) {
        let contact = createCNContact(from: contactData)
        presentContactViewController(for: contact, isNewContact: true)
    }

    private func openVCard(vCardData: [String: Any?]) {
        let contact = createCNContact(from: vCardData)
        presentContactViewController(for: contact, isNewContact: false)
    }

    private func createCNContact(from data: [String: Any?]) -> CNMutableContact {
        let contact = CNMutableContact()

        contact.givenName = data["givenName"] as? String ?? ""
        contact.middleName = data["middleName"] as? String ?? ""
        contact.familyName = data["familyName"] as? String ?? ""
        contact.namePrefix = data["prefix"] as? String ?? ""
        contact.nameSuffix = data["suffix"] as? String ?? ""
        contact.organizationName = data["company"] as? String ?? ""
        contact.jobTitle = data["jobTitle"] as? String ?? ""
        contact.note = data["note"] as? String ?? ""

        if let urlAddresses = data["urlAddresses"] as? [[String: String]] {
                    contact.urlAddresses = urlAddresses.map {
                        CNLabeledValue(label: $0["label"] ?? "", value: $0["value"] as NSString? ?? "")
                    }
                }

        if let birthdayString = data["birthday"] as? String {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            if let birthdayDate = dateFormatter.date(from: birthdayString) {
                contact.birthday = Calendar.current.dateComponents([.year, .month, .day], from: birthdayDate)
            }
        }

        if let phones = data["phones"] as? [[String: String]] {
            contact.phoneNumbers = phones.map {
                CNLabeledValue(label: $0["label"] ?? "", value: CNPhoneNumber(stringValue: $0["value"] ?? ""))
            }
        }

        if let emails = data["emails"] as? [[String: String]] {
            contact.emailAddresses = emails.map {
                CNLabeledValue(label: $0["label"] ?? "", value: $0["value"] as NSString? ?? "")
            }
        }

        if let postalAddresses = data["postalAddresses"] as? [[String: String]] {
            contact.postalAddresses = postalAddresses.map {
                let address = CNMutablePostalAddress()
                address.street = $0["street"] ?? ""
                address.city = $0["city"] ?? ""
                address.state = $0["region"] ?? ""
                address.postalCode = $0["postcode"] ?? ""
                address.country = $0["country"] ?? ""
                return CNLabeledValue(label: $0["label"] ?? "", value: address)
            }
        }

        if let socialProfiles = data["socialProfiles"] as? [[String: String]] {
            contact.socialProfiles = socialProfiles.map {
                let profile = CNSocialProfile(urlString: $0["urlString"],
                                              username: $0["username"],
                                              userIdentifier: $0["userIdentifier"],
                                              service: $0["service"])
                return CNLabeledValue(label: $0["label"] ?? "", value: profile)
            }
        }

        return contact
    }

    private func presentContactViewController(for contact: CNMutableContact, isNewContact: Bool) {
        DispatchQueue.main.async {
            let contactViewController: CNContactViewController
            if isNewContact {
                contactViewController = CNContactViewController(forNewContact: contact)
            } else {
                contactViewController = CNContactViewController(forUnknownContact: contact)
                contactViewController.contactStore = CNContactStore()
                contactViewController.allowsActions = true
                contactViewController.allowsEditing = false
            }

            contactViewController.delegate = self

            if let rootViewController = UIApplication.shared.windows.first?.rootViewController {
                let navigationController = UINavigationController(rootViewController: contactViewController)
                if !isNewContact {
                    navigationController.navigationBar.topItem?.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(self.cancelContact))
                }
                rootViewController.present(navigationController, animated: true, completion: nil)
            } else {
                self.result?(ContactOperationResult.error.rawValue)
            }
        }
    }

    @objc func cancelContact() {
        if let rootViewController = UIApplication.shared.windows.first?.rootViewController {
            rootViewController.dismiss(animated: true) {
                self.result?(ContactOperationResult.cancelled.rawValue)
            }
        }
    }

    public func contactViewController(_ viewController: CNContactViewController, didCompleteWith contact: CNContact?) {
        viewController.dismiss(animated: true) {
            if contact != nil {
                self.result?(ContactOperationResult.saved.rawValue)
            } else {
                self.result?(ContactOperationResult.cancelled.rawValue)
            }
        }
    }
}