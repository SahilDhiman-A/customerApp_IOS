//
//  SRViewController.swift
//  SpectraNet
//
//  Created by Yugasalabs-28 on 23/07/2019.
//  Copyright © 2019 Bhoopendra. All rights reserved.
//

import UIKit
import ObjectMapper
import RealmSwift

class ChatBotViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate {
    
    var realm:Realm? = nil
    var userCurrentData:Results<UserCurrentData>? = nil
    var messages:[ChatMessage] = []
    
    @IBOutlet weak var chatTableView: UITableView!
    @IBOutlet var searchBTN: UIButton!
    @IBOutlet var messageTextField: UITextField!
    @IBOutlet var messageView: UIView!
    @IBOutlet weak var marginBottomMessageView: NSLayoutConstraint!
    
    //MARK: View controller life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        realm = try? Realm()
        setupKeyboardDismissRecognizer()
        self.chatTableView.rowHeight = UITableView.automaticDimension;
        self.chatTableView.estimatedRowHeight = 44.0;
        
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        
        
    }
    
    //MARK: TextField delegate
    @objc func textFieldDidChange(_ textField: UITextField)
    {
        if textField.text!.isEmpty
        {
//            searchBTN.isHidden = true
//            serachImage.isHidden = true
//            serachImage.image = UIImage(named: "filterarrow")
//            searchBTN.isSelected = false
        }
        else
        {
//            searchBTN.isHidden = false
//            serachImage.isHidden = false
        }
    }
   
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        textField.resignFirstResponder();
        return true;
    }
   
    //MARK: Table View delegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return self.messages.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let message = self.messages[indexPath.row]
        if message.type == .User {
            var cell : ChatUserMessageCell? = (chatTableView.dequeueReusableCell(withIdentifier: TableViewCellName.chatUserMessageCell) as! ChatUserMessageCell)
            
            if cell == nil
            {
                cell = ChatUserMessageCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: TableViewCellName.chatUserMessageCell)
            }
            cell?.messageLabel.text = message.message
            return cell!
        } else {
            var cell : ChatBotMessageCell? = (chatTableView.dequeueReusableCell(withIdentifier: TableViewCellName.chatBotMessageCell) as! ChatBotMessageCell)
            
            if cell == nil
            {
                cell = ChatBotMessageCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: TableViewCellName.chatBotMessageCell)
            }
            cell?.messageLabel.text = message.message
            return cell!
        }
    }
    
  //MARK: Button Actions
   @IBAction func backClicked(_ sender: Any)
    {
        self.navigationController?.popViewController(animated: true)
    }

    @IBAction func sendClicked(_ sender: Any)
    {
        if self.messageTextField.text ?? "" != "" {
            messages.append(ChatMessage(message: self.messageTextField.text!, type: .User))
            self.chatTableView.beginUpdates()
            self.chatTableView.insertRows(at: [IndexPath(row: self.messages.count - 1, section: 0)], with: .automatic)
            self.chatTableView.endUpdates()
            self.chatTableView.scrollToBottom()
            self.getBotReply()
        }
    }
    
    func getBotReply() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5, execute: {
            let lastMessage = self.messages.last
            let _lastMessage = lastMessage?.message ?? ""
            self.messages.append(ChatMessage(message: _lastMessage + " \ndummy reply", type: .Bot))
            self.chatTableView.beginUpdates()
            self.chatTableView.insertRows(at: [IndexPath(row: self.messages.count - 1, section: 0)], with: .automatic)
            self.chatTableView.endUpdates()
            self.chatTableView.scrollToBottom()
        })
    }
}

extension ChatBotViewController {
    @objc func keyboardWillShow(notification: NSNotification) {
        if ((notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue) != nil {
            if marginBottomMessageView.constant == 5 {
                if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
                    let keyboardRectangle = keyboardFrame.cgRectValue
                    let keyboardHeight = keyboardRectangle.height
                    UIView.animate(withDuration: 0.7, animations: {
//                        self.chatTableView.reloadData()
                        
                        print("keyboard height ---- \(keyboardHeight)")
                        self.marginBottomMessageView.constant = keyboardHeight
                    })
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                        self.chatTableView.scrollToBottom()
                    })
                }
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if ((notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue) != nil {
            if marginBottomMessageView.constant != 5 {
                UIView.animate(withDuration: 0.7, animations: {
//                    self.chatTableView.reloadData()
                    self.marginBottomMessageView.constant = 5
                })
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                    self.chatTableView.scrollToBottom()
                })
            }
        }
    }
}
