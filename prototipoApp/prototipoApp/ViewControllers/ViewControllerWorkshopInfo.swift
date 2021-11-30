//
//  ViewControllerWorkshopInfo.swift
//  prototipoApp
//
//  Created by Alumno on 02/11/21.
//

import UIKit
import FirebaseFirestore
import FirebaseCore

class ViewControllerWorkshopInfo: UIViewController {
    
    let db = Firestore.firestore()
    
    private var fontSize: CGFloat = 26, margin: CGFloat = 5
    private var numberOfLines: CGFloat = 2
    
    var workshop_id : String!
    var AWId : String!
    
    var name : String!
    var grade : String!
    var date : String!
    var workshopImg : UIImage!
    var desc : String!
    
    
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var gradeLbl: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var workshopImage: UIImageView!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var registerBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dbHandler.protocolDelegate = nil
        registerBtn.layer.cornerRadius = 10
        registerBtn.layer.masksToBounds = true
        gradeLbl.layer.cornerRadius = 10
        gradeLbl.layer.masksToBounds = true
        dateLbl.layer.cornerRadius = 10
        dateLbl.layer.masksToBounds = true
        descriptionTextView.layer.cornerRadius = 10
        descriptionTextView.layer.masksToBounds = true
        
        // Do any additional setup after loading the view.
        
        if userData.type == "Coordinator" || userData.type == "Administrator" {
            gradeLbl.isHidden = true
            registerBtn.isHidden = true
        } else {
            if grade != nil {
                if grade != "-1" {
                    gradeLbl.text = grade! + " %"
                } else {
                    gradeLbl.isHidden = true
                }
                //gradeLbl.backgroundColor = UIColor(hue: CGFloat((Float(grade!)!-5.0)/360), saturation: 1.0, brightness: 1.0, alpha: 1.0)
                
                registerBtn.isHidden = true
            } else {
                gradeLbl.isHidden = true
            }
        }
        nameLbl.text = name!
        dateLbl.text = " " + date!
        workshopImage.image = workshopImg!.alpha(0.75)
        descriptionTextView.text = desc!
        
        
        
        if title!.count > 10 && title!.count < 17 {
            fontSize = 45
            numberOfLines = 1
            margin = 0
        }
        
        dateLbl.font = UIFont.systemFont(ofSize: descriptionTextView.frame.width/15)
        descriptionTextView.font = UIFont.systemFont(ofSize: descriptionTextView.frame.width/15)
        
        //navigationController?.navigationBar.largeTitleTextAttributes = [.font: UIFont.systemFont(ofSize:(fontSize + margin) * numberOfLines)]
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
    }
    
    
    @IBAction func registerBtn(_ sender: UIButton) {
        sender.isEnabled = false
        
        let start = AWId.index(AWId.startIndex, offsetBy: 2)
        let end = AWId.index(AWId.startIndex, offsetBy: 5)
        let range = start..<end

        let newRegisterId = "ew" + String(AWId[range]) + userData.id!
        
        db.collection("Enrolled_workshop").document(newRegisterId).setData([
            "AWorkshop_id": AWId!,
            "Grade": -1,
            "Register_id": newRegisterId,
            "Status" : false,
            "Student_id" : userData.id!
        ]) { err in
            if let err = err {
                print("Error writing document: \(err)")
                sender.isEnabled = true
            } else {
                self.navigationController?.popViewController(animated: true)
                print("Document successfully written!")
            }
        }
        
    }
    
    func updateTextFont(textView : UITextView) {
            if (textView.text.isEmpty || textView.bounds.size.equalTo(CGSize.zero)) {
                return
            }

        let textViewSize = textView.frame.size
        let fixedWidth = textViewSize.width
        let expectSize = textView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat(MAXFLOAT)))

        var expectFont = textView.font
        if (expectSize.height > textViewSize.height) {
            while (textView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat(MAXFLOAT))).height > textViewSize.height) {
                expectFont = textView.font!.withSize(textView.font!.pointSize - 1)
                textView.font = expectFont
            }
        }
        else {
            while (textView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat(MAXFLOAT))).height < textViewSize.height) {
                expectFont = textView.font
                textView.font = textView.font!.withSize(textView.font!.pointSize + 1)
            }
            textView.font = expectFont
        }
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
