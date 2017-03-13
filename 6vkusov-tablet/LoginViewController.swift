//
//  LoginViewController.swift
//  6vkusov-tablet
//
//  Created by Alexandr Zanko on 2/25/17.
//  Copyright © 2017 Alexandr Zanko. All rights reserved.
//

import UIKit

class LoginViewController: BaseViewController, UITextFieldDelegate, LoadJson {
    
    
    @IBOutlet weak var message: UILabel!
    @IBOutlet weak var vkBtn: UIButton!
    @IBOutlet weak var facebookBtn: UIButton!
    @IBOutlet weak var odnoklasnikiBtn: UIButton!
    @IBOutlet weak var googleBtn: UIButton!
    
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    
    @IBOutlet weak var registrationBtn: UIButton!
    
    private var textFieldActive:UITextField?


    override func viewDidLoad() {
        super.viewDidLoad()
        initViews()
        let theTap = UITapGestureRecognizer(target: self, action: #selector(scrollViewTapped))
        self.view.addGestureRecognizer(theTap)

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        // Do any additional setup after loading the view.
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textFieldActive = textField
    }
    
    func keyboardWillShow(notification: NSNotification) {
        
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            
            if let field = textFieldActive {
                let delta:CGFloat = 130
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

    
    func loadComplete(obj: Dictionary<String, AnyObject>?, sessionName: String?) {
        if let response = obj {
            if (sessionName == "login"){
                let code = response["code"] as! Int
                if code == 1 {
                    do {
                        let data = try JSONSerialization.data(withJSONObject: response, options: [])
                        let json = String(data: data, encoding: .utf8)
                        let store = Singleton.currentUser().getStore()
                        store?.setStringValueStorage(key: (store?.APP_PROFILE)!, value: json!)
                        let vc = self.navigationController?.viewControllers.first as! MainViewController
                        vc.lunchscreen.isHidden = false
                        Singleton.currentUser().initStore(vc: vc)
                        self.registrationBtn.isEnabled = true
                        let _ = self.navigationController?.popViewController(animated: true)
                    } catch let error as NSError {
                        print("Error Server \(error)")
                        self.registrationBtn.isEnabled = true
                    }
                }else{
                    alertShow(textError: response["message"] as! String)
                    self.registrationBtn.isEnabled = true
                }
            }
        }else{
            alertShow(textError: "Ошибка соединения ...")
            self.registrationBtn.isEnabled = true
        }
    }

    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func scrollViewTapped(recognizer: UIGestureRecognizer) {
        self.view.endEditing(true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func registrationPressed(_ sender: Any) {
        let email = self.email.text
        let password = self.password.text
        registrationBtn.isEnabled = false
        if(!Validator.email(email: email!)){
            alertShow(textError: "Не верный формат email")
            registrationBtn.isEnabled = true
            return
        }else if(!Validator.minLength(password: password!,length: 6)){
            alertShow(textError: "Пороль должен состоять не менее чем из 6 символов")
            registrationBtn.isEnabled = true
            return
        }else if(!Validator.maxLength(password: password!,length: 128)){
            alertShow(textError: "Слишком длинный пароль")
            registrationBtn.isEnabled = true
            return
        }else{
            sendHashToTheServer(email: email!,password: password!)
        }
    }
    
    private func sendHashToTheServer(email:String,password:String){
        let dict = ["email":email, "password":password]
        let url = "https://6vkusov.by/api/login"
        JsonHelperLoad(url: url, params: dict, act: self, sessionName: "login").startSession()
    }
    
    @IBAction func vkPressed(_ sender: Any) {
        
    }
    
    @IBAction func facebookPressed(_ sender: Any) {
        
    }
    
    @IBAction func odnoklassnikiPressed(_ sender: Any) {
        
    }
    
    @IBAction func googlePressed(_ sender: Any) {
        
    }
    
    
    private func initViews(){
        
        email.delegate = self
        password.delegate = self
        
        registrationBtn.layer.cornerRadius = 5.0
        vkBtn.layer.cornerRadius = 5.0
        facebookBtn.layer.cornerRadius = 5.0
        odnoklasnikiBtn.layer.cornerRadius = 5.0
        googleBtn.layer.cornerRadius = 5.0

        let attributes = [
            NSForegroundColorAttributeName: UIColor.lightGray
        ]
        email.attributedPlaceholder = NSAttributedString(string: "Email", attributes:attributes)
        password.attributedPlaceholder = NSAttributedString(string: "Пароль", attributes:attributes)
    
        email.returnKeyType = UIReturnKeyType.done
        password.returnKeyType = UIReturnKeyType.done
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
