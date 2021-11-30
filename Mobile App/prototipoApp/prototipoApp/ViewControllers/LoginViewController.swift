//
//  LoginViewController.swift
//  prototipoApp
//
//  Created by Facundo on 28/11/21.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class LoginViewController: UIViewController {
    
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var userTxt: UITextField!
    @IBOutlet weak var passTxt: UITextField!
    
    var logged : Bool!
    
    var tipoUsuario : String!
    
    var userInfo : [String : Any]!
    
    var role : Int!
    
    let db = Firestore.firestore()
    
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        loginBtn.layer.cornerRadius = 10
        definesPresentationContext = true
        
        if (defaults.string(forKey: "email")) != nil {
            userTxt.text = defaults.string(forKey: "email")
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        loginBtn.isEnabled = true
    }
    
    func SEGUE(role: Int){
        if role == 1 {
            performSegue(withIdentifier: "homeAdmin", sender: self)
        } else {
            performSegue(withIdentifier: "homeStudentCoordinator", sender: self)
        }
    }
    
    func checkUserRole(userID : String) {
//        let adminRef = db.collection("Administrator")
//        let coordRef = db.collection("Coordinator")
//        let studRef = db.collection("Student")
        //print(userID)
        let usersRef = db.collection("Users")
        
        usersRef.whereField("Email", isEqualTo: userID)
            .getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    for document in querySnapshot!.documents {
                        //print("\(document.documentID) => \(document.data())")
                        let rol = document.data()["Role"]! as! String
                        
                        userData.id = (document.data()["Id"]! as! String)
                        userData.names = (document.data()["Name"]! as! String) + " " + (document.data()["Last_name"]! as! String)
                        userData.campusId = (document.data()["Campus_id"]! as! String)
                        userData.current_period = Int(document.data()["Current_period"]! as! String)
                        userData.type = rol
                        
                        if rol == "Administrator" {
                            self.SEGUE(role: 1)
                        } else {
                            self.SEGUE(role: 2)
                        }

                    }
                    
                }
        }
        
        
    }
    
    func getUserId(email : String) {
        
        let usersRef = db.collection("Users")
        
        usersRef.whereField("Email", isEqualTo: email)
            .getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    for document in querySnapshot!.documents {
                        //print("\(document.documentID) => \(document.data())")
                        let rol = document.data()["Role"]!
                        let rolInt : Int!
                        if "\(rol)" == "Administrator" {
                            rolInt = 1
                            self.SEGUE(role: rolInt)
                        } else {
                            rolInt = 2
                            self.SEGUE(role: rolInt)
                        }

                    }
                    
                }
        }
    }

    @IBAction func login(_ sender: UIButton) {
        sender.isEnabled = false
        Auth.auth().signIn(withEmail: userTxt.text!, password: passTxt.text!){ [self]
            (user, error) in
            if error != nil {
                let alert = UIAlertController(title: "Error", message: "Usuario y/o contraseña incorrectos", preferredStyle: .alert)
                let accion = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alert.addAction(accion)
                self.present(alert, animated: true, completion: nil)
                sender.isEnabled = true
            } else {
                print("login succesfull")
                let emailUser = self.userTxt.text
                
                defaults.setValue(emailUser, forKey: "email")
                //let endOfSentence = emailUser!.firstIndex(of: "@")!
                //let idx = emailUser!.index(before: endOfSentence)
                //let matricula = emailUser![...idx]
                //let userId = matricula.uppercased()
                checkUserRole(userID: emailUser!)
            }
        }
    
    }

    @IBAction func closeKeyboard(_ sender: Any) {
        view.endEditing(true)
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    
    

}
