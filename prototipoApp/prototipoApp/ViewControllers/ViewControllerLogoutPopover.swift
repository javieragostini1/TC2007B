//
//  ViewControllerLogoutPopover.swift
//  prototipoApp
//
//  Created by Facundo on 09/11/21.
//

import UIKit
import FirebaseAuth

class ViewControllerLogoutPopover: UIViewController {
    
    @IBOutlet weak var namesLbl: UILabel!
    @IBOutlet weak var idLbl: UILabel!
    @IBOutlet weak var logoutBtn: UIButton!

    var prevView1 : CollectionViewControllerHomeStudentCoordinator!
    var prevView2 : ViewControllerHomeAdministrator!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let width = presentingViewController!.view!.frame.width/1.5
        let height = width*0.625
        
        preferredContentSize = CGSize(width: width, height: height)
        
        namesLbl.text = userData.names
        idLbl.text = userData.id
        
        //namesLbl.font = .systemFont(ofSize: height*0.32*0.5)
        //idLbl.font = .systemFont(ofSize: height*0.32*0.35)
        logoutBtn.titleLabel!.font = .systemFont(ofSize: height*0.28*0.45)

                                      
        namesLbl.layer.cornerRadius = 10
        namesLbl.layer.masksToBounds = true
        namesLbl.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        namesLbl.backgroundColor = UIColor(white: 0.9, alpha: 0.37)

        idLbl.backgroundColor = UIColor(white: 0.9, alpha: 0.37)
        
        logoutBtn.layer.cornerRadius = 10
        logoutBtn.layer.masksToBounds = true
        logoutBtn.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        
        //print((height*0.36-4)/4-4)
        
        /*
        let bottomLine = CALayer()
        bottomLine.frame = CGRect(x: 0, y: height*0.36, width: width, height: 1)
        bottomLine.backgroundColor = UIColor.black.cgColor
        namesLbl.layer.addSublayer(bottomLine)
        
        let bottomLine1 = CALayer()
        bottomLine1.frame = CGRect(x: 0, y: height*0.72, width: width, height: 1)
        bottomLine1.backgroundColor = UIColor.black.cgColor
        namesLbl.layer.addSublayer(bottomLine1)
        */
        
        namesLbl.frame = CGRect(x: 4, y: 12.5+4, width: width-8, height: height*0.36-4)
        idLbl.frame = CGRect(x: 4, y: height*0.36+12.5, width: width-8, height: height*0.36)
        logoutBtn.frame = CGRect(x: 4, y: height*0.72+12.5, width: width-8, height: height*0.28-4)
        
        
        
        // Do any additional setup after loading the view.
    }

    @IBAction func logoutBtn(_ sender: Any) {
        if prevView1 == nil {
            dismiss(animated: true, completion: prevView2.SignOut)
        } else {
            dismiss(animated: true, completion: prevView1.SignOut)
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
