import Flutter
import UIKit
import Contacts
import ContactsUI

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
        case "getPlatformVersion":
            result("iOS " + UIDevice.current.systemVersion)
        case "addContact":
            guard let args = call.arguments as? [String: Any],
                  let contactData = args["contact"] as? [String: Any?] else {
                result(FlutterError(code: "INVALID_ARGUMENT", message: "Invalid contact data", details: nil))
                return
            }
            addContact(contactData: contactData)
        default:
            result(FlutterMethodNotImplemented)
        }
    }

    private func addContact(contactData: [String: Any?]) {
        let contact = CNMutableContact()

        contact.givenName = contactData["givenName"] as? String ?? ""
        contact.middleName = contactData["middleName"] as? String ?? ""
        contact.familyName = contactData["familyName"] as? String ?? ""
        contact.namePrefix = contactData["prefix"] as? String ?? ""
        contact.nameSuffix = contactData["suffix"] as? String ?? ""
        contact.organizationName = contactData["company"] as? String ?? ""
        contact.jobTitle = contactData["jobTitle"] as? String ?? ""
        contact.note = contactData["note"] as? String ?? ""

        if let birthdayString = contactData["birthday"] as? String {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            if let birthdayDate = dateFormatter.date(from: birthdayString) {
                contact.birthday = Calendar.current.dateComponents([.year, .month, .day], from: birthdayDate)
            }
        }

        if let phones = contactData["phones"] as? [[String: String]] {
            contact.phoneNumbers = phones.map {
                CNLabeledValue(label: $0["label"] ?? "", value: CNPhoneNumber(stringValue: $0["value"] ?? ""))
            }
        }

        if let emails = contactData["emails"] as? [[String: String]] {
            contact.emailAddresses = emails.map {
                CNLabeledValue(label: $0["label"] ?? "", value: $0["value"] as NSString? ?? "")
            }
        }

        if let postalAddresses = contactData["postalAddresses"] as? [[String: String]] {
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

        if let socialProfiles = contactData["socialProfiles"] as? [[String: String]] {
            contact.socialProfiles = socialProfiles.map {
                let profile = CNSocialProfile(urlString: $0["urlString"],
                                              username: $0["username"],
                                              userIdentifier: $0["userIdentifier"],
                                              service: $0["service"])
                return CNLabeledValue(label: $0["label"] ?? "", value: profile)
            }
        }

        DispatchQueue.main.async {
            let contactViewController = CNContactViewController(forNewContact: contact)
            contactViewController.delegate = self

            if let rootViewController = UIApplication.shared.windows.first?.rootViewController {
                let navigationController = UINavigationController(rootViewController: contactViewController)
                rootViewController.present(navigationController, animated: true, completion: nil)
                self.result?(true)
            } else {
                self.result?(FlutterError(code: "NO_ROOTVC", message: "Unable to find root view controller", details: nil))
            }
        }
    }

    public func contactViewController(_ viewController: CNContactViewController, didCompleteWith contact: CNContact?) {
        viewController.dismiss(animated: true) {
            if let contact = contact {
                self.result?(contact.identifier)
            } else {
                self.result?(nil)
            }
        }
    }
}
