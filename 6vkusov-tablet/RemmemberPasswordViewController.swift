//
//  RemmemberPasswordViewController.swift
//  6vkusov-tablet
//
//  Created by Alexandr Zanko on 2/27/17.
//  Copyright © 2017 Alexandr Zanko. All rights reserved.
//

import UIKit

class RemmemberPasswordViewController: BaseViewController, UITextFieldDelegate, LoadJson {
    
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var sendButton: UIButton!
    private var textFieldActive:UITextField?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initViews()
        let theTap = UITapGestureRecognizer(target: self, action: #selector(scrollViewTapped))
        self.view.addGestureRecognizer(theTap)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textFieldActive = textField
    }
    
    func keyboardWillShow(notification: NSNotification) {
        
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            
            if let field = textFieldActive {
                let delta:CGFloat = 100
                let fieldHeight = field.frame.height
                let fieldYPosition = field.frame.origin.y
                let viewHeight = view.frame.height
                let viewYposition = view.frame.origin.y
                let keyboardH = keyboardSize.height
                let distance = viewHeight - (fieldYPosition + fieldHeight + delta) - keyboardH - viewYposition
                if distance < 0{
                    self.view.frame.origin.y += distance
                }
            }
        }
        
    }
    
    func keyboardWillHide(notification: NSNotification) {
        self.view.frame.origin.y = 0
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
    private func sendHashToTheServer(email:String){
        var dict = Dictionary<String,AnyObject>()
        dict["email"]  = email as AnyObject
        dict["key"]  = REST_URL.KEY.rawValue as AnyObject
        JsonHelperLoad(url: REST_URL.SF_RESET_PASSWORD.rawValue, params: dict, act: self, sessionName: nil).startSession()
    }
    
    func loadComplete(obj: Dictionary<String, AnyObject>?, sessionName: String?) {
        if let request = obj {
            if let status = request["status"] as? String{
                if status == "successful" {
                    let vc = self.navigationController?.viewControllers[1] as! LoginViewController
                    vc.message.text = "Вам на почту \(request["email"] as! String) отправлена ссылка для восстановления пароля"
                    self.sendButton.isEnabled = true
                    let _ = self.navigationController?.popViewController(animated: true)
                    self.sendButton.isEnabled = true
                }else{
                    alertShow(textError: request["message"] as! String)
                    self.sendButton.isEnabled = true
                }
            }
        }
    }
    
    
    
    func scrollViewTapped(recognizer: UIGestureRecognizer) {
        self.view.endEditing(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func sendButtonPressed(_ sender: Any) {
        let email = self.email.text
        self.sendButton.isEnabled = false
        
        if(!Validator.email(email: email!)){
            let alert = UIAlertController(title: "Ошибка", message: "Не верный формат email", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }else{
            sendHashToTheServer(email: email!)
        }
    }
    
    private func initViews(){
        
        email.delegate = self
        sendButton.layer.cornerRadius = 5.0
        
        let attributes = [
            NSForegroundColorAttributeName: UIColor.lightGray
        ]
        email.attributedPlaceholder = NSAttributedString(string: "Email", attributes:attributes)
        email.returnKeyType = UIReturnKeyType.done
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    

}
