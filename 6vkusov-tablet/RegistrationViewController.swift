//
//  RegistrationViewController.swift
//  6vkusov-mobile
//
//  Created by Alexandr Zanko on 2/24/17.
//  Copyright © 2017 Alexandr Zanko. All rights reserved.
//

import UIKit

class RegistrationViewController: BaseViewController, UITextFieldDelegate, LoadJson {
    
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var passwordConfirm: UITextField!
    @IBOutlet weak var promo: UITextField!
    @IBOutlet weak var newsBtn: CheckBox!
    @IBOutlet weak var agreeBtn: CheckBox!
    @IBOutlet weak var regBtn: UIButton!
    @IBOutlet weak var licenseBtn: UIButton!
    @IBOutlet weak var backToLoginBtn: UIButton!

    private var textFieldActive:UITextField?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initViews()
        let theTap = UITapGestureRecognizer(target: self, action: #selector(scrollViewTapped))
        self.view.addGestureRecognizer(theTap)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func scrollViewTapped(recognizer: UIGestureRecognizer) {
        self.view.endEditing(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textFieldActive = textField
    }
    
    func keyboardWillShow(notification: NSNotification) {
        
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            
            if let field = textFieldActive {
                let delta:CGFloat = 40
                let fieldHeight = field.frame.height
                let fieldYPosition = field.frame.origin.y
                let viewHeight = view.frame.height
                let viewYposition = view.frame.origin.y
                let keyboardH = keyboardSize.height
                let distance = viewHeight - (fieldYPosition + fieldHeight + delta) - keyboardH - viewYposition
                if distance < 0 {
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
    
    @IBAction func registrationPressed(_ sender: Any) {
        let name = self.name.text
        let email = self.email.text
        let password = self.password.text
        let passwordConfirm = self.passwordConfirm.text
        let promo = self.promo.text
        let newsBtn = self.newsBtn.isChecked ? 1:2
        regBtn.isEnabled = false
        if(!Validator.minLength(password: name!,length: 2)){
            let alert = UIAlertController(title: "Ошибка", message: "Слишком короткое имя", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            self.regBtn.isEnabled = true
            return
        }else if(!Validator.nameLiterals(name: name!)){
            let alert = UIAlertController(title: "Ошибка", message: "Имя должно состоять только из букв", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            self.regBtn.isEnabled = true
            return
        }else if(!Validator.email(email: email!)){
            let alert = UIAlertController(title: "Ошибка", message: "Не верный формат email", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            self.regBtn.isEnabled = true
            return
        }else if(!Validator.minLength(password: password!,length: 6)){
            let alert = UIAlertController(title: "Ошибка", message: "Пороль должен состоять не менее чем из 6 символов", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            self.regBtn.isEnabled = true
            return
        }else if(password != passwordConfirm){
            let alert = UIAlertController(title: "Ошибка", message: "Пороли не совпадают", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            self.regBtn.isEnabled = true
            return
        }else if(!Validator.maxLength(password: name!,length: 128)){
            let alert = UIAlertController(title: "Ошибка", message: "Слишком длинное имя", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            self.regBtn.isEnabled = true
            return
        }else if(!Validator.maxLength(password: password!,length: 128)){
            let alert = UIAlertController(title: "Ошибка", message: "Слишком длинный пароль", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            self.regBtn.isEnabled = true
            return
        }else if(promo!.length != 0 && !Validator.nameLiteralsAndNumbers(name: promo!)){
            let alert = UIAlertController(title: "Ошибка", message: "Промокод может состоять только из букв и/или цифр", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            self.regBtn.isEnabled = true
            return
        }else if(!Validator.maxLength(password: promo!,length: 128)){
            let alert = UIAlertController(title: "Ошибка", message: "Слишком длинный промокод", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }else if(!self.agreeBtn.isChecked){
            let alert = UIAlertController(title: "Ошибка", message: "Подтвердите согласие с условием пользовательского соглашения", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            self.regBtn.isEnabled = true
            return
        }else{
            sendHashToTheServer(email: email!,password: password!,name: name!,promo: promo!,newsBtn: newsBtn);
        }
        
    }
    
    private func sendHashToTheServer(email:String,password:String,name:String,promo:String,newsBtn:Int){
        var dict = Dictionary<String,AnyObject>()
        dict["key"]  = REST_URL.KEY.rawValue as AnyObject
        dict["email"] = email as AnyObject
        dict["password"]  = password as AnyObject
        dict["name"]  = name as AnyObject
        dict["news"]  = String(newsBtn) as AnyObject
        if promo != "" {
            dict["promo"]  = promo as AnyObject
        }
        JsonHelperLoad(url: REST_URL.SF_REGISTRATION.rawValue, params: dict, act: self, sessionName: "registration").startSession()
    }
    
    func loadComplete(obj: Dictionary<String, AnyObject>?, sessionName: String?) {
        if let response = obj {
            if (sessionName == "registration"){
                let status = response["status"] as! String
                if status == "successful" {
                    let vc = self.navigationController?.viewControllers[1] as! LoginViewController
                    vc.message.text = "Вы успешно зарегистрированы, Вам на почту отправлена ссылка для активации"
                    self.regBtn.isEnabled = true
                    let _ = self.navigationController?.popViewController(animated: true)
                    self.regBtn.isEnabled = true
                }else{
                    alertShow(textError: response["message"] as! String)
                    self.regBtn.isEnabled = true
                }
            }
        }else{
            alertShow(textError: "Ошибка соединения ...")
            self.regBtn.isEnabled = true
        }
    }
    
    @IBAction func backToLoginPressed(_ sender: Any) {
        _ = navigationController?.popViewController(animated: true)
    }
    
    private func initViews(){
        name.delegate = self
        email.delegate = self
        password.delegate = self
        passwordConfirm.delegate = self
        promo.delegate = self
        regBtn.layer.cornerRadius = 5.0
        let attributes = [NSForegroundColorAttributeName: UIColor.lightGray]
        name.attributedPlaceholder = NSAttributedString(string: "Имя", attributes:attributes)
        email.attributedPlaceholder = NSAttributedString(string: "Email", attributes:attributes)
        password.attributedPlaceholder = NSAttributedString(string: "Пароль", attributes:attributes)
        passwordConfirm.attributedPlaceholder = NSAttributedString(string: "Повторить пароль", attributes:attributes)
        promo.attributedPlaceholder = NSAttributedString(string: "Промокод (не обязательно)", attributes:attributes)
        
        name.returnKeyType = UIReturnKeyType.done
        email.returnKeyType = UIReturnKeyType.done
        password.returnKeyType = UIReturnKeyType.done
        passwordConfirm.returnKeyType = UIReturnKeyType.done
        promo.returnKeyType = UIReturnKeyType.done
    }
    

}
