//
//  ViewControllerStudentInfo.swift
//  prototipoApp
//
//  Created by Alumno on 02/11/21.
//

import UIKit
import FirebaseFirestore

class ViewControllerStudentInfo: UIViewController {
    
    @IBOutlet weak var nameBackground: UIView!
    @IBOutlet weak var idBackground: UIView!
    @IBOutlet weak var gradeBackground: UIView!
    @IBOutlet weak var statusBackground: UIView!
    
    
    
    var prevView : ViewControllerWorkshopStudents!
    
    var eWInfo : EnrolledWorkshop!
    var name : String!
    var id : String!
    var grade : String!
    var status : Bool!
    
    let db = Firestore.firestore()
    
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var idLbl: UILabel!
    @IBOutlet weak var gradeTxt: UITextField!
    @IBOutlet weak var statusSC: UISegmentedControl!
    @IBOutlet weak var saveBtn: UIButton!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        nameLbl.text = name
        idLbl.text = id
        gradeTxt.text = grade
        
        if status! {
            statusSC.selectedSegmentIndex = 0
        } else {
            statusSC.selectedSegmentIndex = 1
        }

        saveBtn.layer.cornerRadius = 10
        
        nameBackground.backgroundColor = UIColor(white: 0.8, alpha: 0.37)
        nameBackground.layer.masksToBounds = true
        nameBackground.layer.cornerRadius = 10
        
        idBackground.backgroundColor = UIColor(white: 0.8, alpha: 0.37)
        idBackground.layer.masksToBounds = true
        idBackground.layer.cornerRadius = 10
        
        gradeBackground.backgroundColor = UIColor(white: 0.8, alpha: 0.37)
        gradeBackground.layer.masksToBounds = true
        gradeBackground.layer.cornerRadius = 10
        
        statusBackground.backgroundColor = UIColor(white: 0.8, alpha: 0.37)
        statusBackground.layer.masksToBounds = true
        statusBackground.layer.cornerRadius = 10
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        UIView.animate(withDuration: 0.1){
            if let idx = self.prevView.tableView.indexPathForSelectedRow {
                self.prevView.tableView.deselectRow(at: idx, animated: true)
            }
        }
    }

    @IBAction func updateBtn(_ sender: UIButton) {
        sender.isEnabled = false
        
        if (Int(gradeTxt.text!) != nil) && Int(gradeTxt.text!)! >= -1 && Int(gradeTxt.text!)! <= 100{
            var tStatus : Bool! = nil
            if statusSC.selectedSegmentIndex == 0 {
                tStatus = true
            } else {
                tStatus = false
            }
            db.collection("Enrolled_workshop").document(eWInfo.register_id).updateData([
                "Grade": Int(gradeTxt.text!)!,
                "Status" : tStatus!
            ]) { err in
                if let err = err {
                    print("Error writing document: \(err)")
                    let alert = UIAlertController(title: "Error", message: "Hubo un error al calificar la aplicacion", preferredStyle: .alert)
                    let accion = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alert.addAction(accion)
                    self.present(alert, animated: true, completion: nil)
                    sender.isEnabled = true
                } else {
                    print("Document successfully written!")
                    self.navigationController?.popViewController(animated: true)
                }
            }
        } else {
            let alert = UIAlertController(title: "Error", message: "Inserte una calificacion valida", preferredStyle: .alert)
            let accion = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alert.addAction(accion)
            self.present(alert, animated: true, completion: nil)
        }
        
        
    }
    
    @IBAction func closeKeyboard(_ sender: Any) {
        view.endEditing(true)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
