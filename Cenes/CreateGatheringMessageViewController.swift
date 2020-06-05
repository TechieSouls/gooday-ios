//
//  CreateGatheringMessageViewController.swift
//  Deploy
//
//  Created by Cenes_Dev on 20/04/2019.
//  Copyright © 2019 Cenes Pvt Ltd. All rights reserved.
//

import UIKit

protocol MessageProtocol: class {
    func messageDonePressed(message: String);
}

class CreateGatheringMessageViewController: UIViewController, UITextViewDelegate {

    @IBOutlet weak var eventDescription: UITextView!
    
    @IBOutlet weak var charaterCountLabel: UILabel!
    
    var messageProtocolDelete: MessageProtocol!;
    var descriptionMsg: String = "";
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = themeColor;
        
        // Do any additional setup after loading the view.
        eventDescription.text = descriptionMsg;
        
        eventDescription.becomeFirstResponder();
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let currentText = textView.text ?? ""
        guard let stringRange = Range(range, in: currentText) else { return false }
        
        if (text.count > 1) {
            print(text.count);
            var textToAdd = "";
            if ((currentText.count + text.count) > 150) {
                let existingCharacterCount = currentText.count;
                let remainingCharacters = 150 - existingCharacterCount;
                textToAdd = String(text.prefix(upTo: String.Index.init(encodedOffset: remainingCharacters)));
                print(textToAdd.count);
            }
            descriptionMsg = currentText + textToAdd;
            textView.text = currentText + textToAdd;
            charaterCountLabel.text = "\(150 - descriptionMsg.count) Characters Remain";
            return false

        } else {
            descriptionMsg = currentText.replacingCharacters(in: stringRange, with: text)
            charaterCountLabel.text = "\(150 - descriptionMsg.count) Characters Remain";
            return descriptionMsg.count < 150
        }
        return true
    }
    
    @IBAction func cancelButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil);
    }
    
    @IBAction func doneButtonPressed(_ sender: Any) {
        messageProtocolDelete.messageDonePressed(message: descriptionMsg);
        self.dismiss(animated: true, completion: nil);
    }
}
