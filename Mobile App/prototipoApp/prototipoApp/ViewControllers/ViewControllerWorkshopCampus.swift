//
//  ViewControllerWorkshopCampus.swift
//  prototipoApp
//
//  Created by Alumno on 02/11/21.
//

import UIKit

class ViewControllerWorkshopCampus: UIViewController, UITableViewDelegate, UITableViewDataSource, FirebaseDataProtocol {
    
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var tableView: UITableView!
    private let reuseIdentifier = "cell"
    var wId : String?
    var aWorkshops : [AvailableWorkshop] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dbHandler.protocolDelegate = self
        dbHandler.getInfoFromDB()
             
        
        
        // Do any additional setup after loading the view.
        
        
        
        let bottomLine = CALayer()
        bottomLine.frame = CGRect(x: 0, y: headerView.frame.height-1, width: view.frame.width-16, height: 1)
        bottomLine.backgroundColor = UIColor.black.cgColor
        headerView.layer.addSublayer(bottomLine)
        
        let idLbl = UILabel()
        idLbl.frame = CGRect.init(x: 8, y:0, width: headerView.frame.width, height: headerView.frame.height-1)
        idLbl.text = "Campus"
        idLbl.font = .systemFont(ofSize: headerView.frame.height*0.8, weight: .bold)
        
        /*
        let nameLbl = UILabel()
        nameLbl.frame = CGRect.init(x: headerView.frame.width/4+10, y:0, width: headerView.frame.width/4*3, height: tableView.sectionHeaderHeight)
        nameLbl.text = "Nombre"
        nameLbl.font = .systemFont(ofSize: 23)
        */
        
        headerView.addSubview(idLbl)
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        dbHandler.getInfoFromDB()
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == "selectedCampusAdmin" {
            let nextView = segue.destination as! ViewControllerWorkshopStudents
            let idx = tableView.indexPathForSelectedRow!.row
            let infoCampus = dbHandler.campus!.filter({return $0.id == aWorkshops[idx].campus_id}).first!
            nextView.awId = dbHandler.availableWorkshops!.filter({return $0.workshop_id == wId! && $0.campus_id == infoCampus.id}).first!.id
            nextView.prevView = self
            nextView.title = dbHandler.availableWorkshops!.filter({return $0.workshop_id == wId! && $0.campus_id == infoCampus.id}).first!.id
        }
        let backItem = UIBarButtonItem()
        navigationItem.backBarButtonItem = backItem
    }
    
    // MARK:- UITableViewDataSource
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return (view.frame.width-16)/5
    }
        
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return aWorkshops.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier) as! TableViewCellCampus
        let infoCampus = dbHandler.campus!.filter({return $0.id == aWorkshops[indexPath.row].campus_id}).first!
        let studentCount = dbHandler.enrolledWorkshops!.filter({return $0.aWorkshop_id == aWorkshops[indexPath.item].id}).count
        
        cell.idLbl.text = infoCampus.id
        cell.nameLbl.text = infoCampus.name
        cell.studentCount.text = "Inscritos: " + String(studentCount)
        
        let width = view.frame.width-16
        let height = (view.frame.width-16)/5
        
        cell.idLbl.frame = CGRect(x: 10, y: -3, width: width/3-10, height: height/3*2)
        cell.nameLbl.frame = CGRect(x: 10, y: height/4*2.2-3, width: width-10, height: height/3)
        cell.studentCount.frame = CGRect(x: width/3*2, y: 0, width: width/3, height: height/4*2-6)
        
        cell.idLbl.font = UIFont.systemFont(ofSize: cell.idLbl.frame.height/2, weight: .bold)
        cell.nameLbl.font = UIFont.systemFont(ofSize: cell.nameLbl.frame.height*0.75)
        cell.studentCount.font = UIFont.systemFont(ofSize: cell.nameLbl.frame.height*0.75)
        cell.studentCount.layer.cornerRadius = 10
        cell.studentCount.layer.masksToBounds = true
        cell.studentCount.layer.maskedCorners = .layerMinXMaxYCorner

        cell.studentCount.layer.borderWidth = 1
        
        //cell.backgroundColor = .black
        
        return cell
    }

    //MARK:- FirebaseDataProtocol
    
    func refresh() {
        aWorkshops = dbHandler.availableWorkshops!.filter({return $0.workshop_id == wId!})
        tableView.reloadData()
    }
    
    func presentErrorAlert() {
        dbHandler = DatabaseHandler()
        let alert = UIAlertController(title: "Error", message: "Hubo un error al cargar los datos", preferredStyle: .alert)
        let accion = UIAlertAction(title: "Reintentar", style: .cancel, handler: nil)
        alert.addAction(accion)
        self.present(alert, animated: true, completion: dbHandler.getInfoFromDB)
    }

}
