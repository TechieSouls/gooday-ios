//
//  PhonebookService.swift
//  Cenes
//
//  Created by Macbook on 05/09/18.
//  Copyright © 2018 Cenes Pvt Ltd. All rights reserved.
//

import Foundation
import Contacts

class PhonebookService {
    
    /**
     * Funcrion to get the permission from user to fetch the contacts
     */
    class func getContacts() -> [CNContact] { //  ContactsFilter is Enum find it below
        
        let contactStore = CNContactStore()
        let keysToFetch = [
            CNContactFormatter.descriptorForRequiredKeys(for: .fullName),
            CNContactPhoneNumbersKey,
            CNContactEmailAddressesKey,
            CNContactThumbnailImageDataKey] as [Any]
        
        var allContainers: [CNContainer] = []
        do {
            allContainers = try contactStore.containers(matching: nil)
        } catch {
            print(error)
        }
        
        var results: [CNContact] = []
        
        for container in allContainers {
            let fetchPredicate = CNContact.predicateForContactsInContainer(withIdentifier: container.identifier)
            
            do {
                let containerResults = try contactStore.unifiedContacts(matching: fetchPredicate, keysToFetch: keysToFetch as! [CNKeyDescriptor])
                results.append(contentsOf: containerResults)
            } catch {
                print(error)
            }
        }
        print(results.count, "countsssss")
        return results
    }
    
    class func phoneNumberWithContryCode() -> [[String: String]] {
        
        let contacts = PhonebookService.getContacts() // here calling the getContacts methods
        var arrPhoneNumbers = [[String: String]]()
        for contact in contacts {
            var MccNamVar = "";
            for ContctNumVar: CNLabeledValue in contact.phoneNumbers {
                if let fulMobNumVar  = ContctNumVar.value as? CNPhoneNumber {
                    //let countryCode = fulMobNumVar.value(forKey: "countryCode") get country code
                    MccNamVar = (fulMobNumVar.value(forKey: "digits") as? String)!
            print(MccNamVar+"  "+contact.givenName+"  #"+contact.middleName+" *"+contact.familyName+"\n");
                    if(!MccNamVar.contains("#") && MccNamVar.count > 8){
                        var phoneNumberObj = [String:String]();
                        let givenNameVar = contact.givenName+" "+contact.familyName
                        phoneNumberObj[MccNamVar] = givenNameVar
                        arrPhoneNumbers.append(phoneNumberObj);
                    }
                }
            }
            
           /* var keyExists = false;
            for phoneNumObj in arrPhoneNumbers {
                if (phoneNumObj[MccNamVar] != nil) {
                    keyExists = true;
                    break;
                }
            }
            
            if (MccNamVar.count < 8 || keyExists) {
               // continue;
            }*/
            
        }
        print(arrPhoneNumbers);
        return arrPhoneNumbers ; // here array has all contact numbers.
    }
    
    class func getPermissionForContacts() {
        let contactStore = CNContactStore()
        let keysToFetch = [
            CNContactFormatter.descriptorForRequiredKeys(for: .fullName),
            CNContactPhoneNumbersKey,
            CNContactEmailAddressesKey,
            CNContactThumbnailImageDataKey] as [Any]
        
        var allContainers: [CNContainer] = []
        do {
            allContainers = try contactStore.containers(matching: nil)
        } catch {
            print(error)
        }
    }
}
