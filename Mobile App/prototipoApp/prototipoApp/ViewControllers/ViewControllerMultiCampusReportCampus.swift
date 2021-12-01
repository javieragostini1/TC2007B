//
//  ViewControllerMultiCampusReportCampus.swift
//  prototipoApp
//
//  Created by Alumno on 02/11/21.
//

import UIKit

class ViewControllerMultiCampusReportCampus: UIViewController, UITableViewDelegate, UITableViewDataSource, FirebaseDataProtocol {

    private let reuseIdentifier = "cell"
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var nextBtn: UIButton!
    
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
        idLbl.text = "Seleccione Campus"
        idLbl.font = .systemFont(ofSize: headerView.frame.height*0.8, weight: .bold)
        
        headerView.addSubview(idLbl)
        
        nextBtn.layer.cornerRadius = 10
        nextBtn.layer.masksToBounds = true
        

    }
    

    
    // MARK: - Navigation
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if tableView.indexPathsForSelectedRows == nil {
            let alert = UIAlertController(title: "Error", message: "Tiene que seleccionar por lo menos un Campus", preferredStyle: .alert)
            let accion = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alert.addAction(accion)
            self.present(alert, animated: true, completion: nil)
            return false
        }
        return true
    }

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        let nextView = segue.destination as! ViewControllerMultiCampusReportWorkshops
        var campus : [Campus] = []

        for tempIdx in tableView.indexPathsForSelectedRows! {
            campus.append(dbHandler.campus![tempIdx.row])
        }
        
        nextView.campus = campus
        
        let backItem = UIBarButtonItem()
        navigationItem.backBarButtonItem = backItem
    }
    
    //MARK:- UITableViewDataSource
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return (view.frame.width-16)/5
    }
    /*
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView.init(frame: CGRect.init(x: 0, y:0, width: tableView.frame.width, height: tableView.sectionHeaderHeight))
        headerView.backgroundColor = UIColor.white
        
        let bottomLine = CALayer()
        bottomLine.frame = CGRect(x: 0, y: headerView.frame.height-1, width: headerView.frame.width, height: 1)
        bottomLine.backgroundColor = UIColor.black.cgColor
        headerView.layer.addSublayer(bottomLine)
        
        let idLbl = UILabel()
        idLbl.frame = CGRect.init(x: 10, y:0, width: headerView.frame.width/4, height: tableView.sectionHeaderHeight)
        idLbl.text = "Clave"
        idLbl.font = .systemFont(ofSize: 23)
        
        let nameLbl = UILabel()
        nameLbl.frame = CGRect.init(x: headerView.frame.width/4+10, y:0, width: headerView.frame.width/4*3, height: tableView.sectionHeaderHeight)
        nameLbl.text = "Nombre"
        nameLbl.font = .systemFont(ofSize: 23)
        
        
        headerView.addSubview(idLbl)
        headerView.addSubview(nameLbl)
        

        return headerView
    }
 */
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dbHandler.campus!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier) as! TableViewCellMultiCampusReportC
        
        let infoCampus = dbHandler.campus![indexPath.row]
        let height = (view.frame.width-16)/5
        let width = view.frame.width-16

        cell.idLbl.text = infoCampus.id
        cell.nameLbl.text = infoCampus.name
        
        
        
        
        //cell.selectedView.layer.borderWidth = 1
        //cell.selectedView.layer.borderColor = UIColor.blue.cgColor
        
        //cell.selectedView.layer.cornerRadius = cell.selectedView.frame.height/2
        
        
        
        cell.idLbl.frame = CGRect(x: 10, y: -3, width: width/3-10, height: height/3*2)
        cell.nameLbl.frame = CGRect(x: 10, y: height/4*2.2-3, width: width-10-width/8, height: height/3)
        cell.selectedView.frame = CGRect(x: width-height/8*3-10, y: -3, width: width/8, height: height)
        
        cell.idLbl.font = UIFont.systemFont(ofSize: cell.idLbl.frame.height/2, weight: .bold)
        cell.nameLbl.font = UIFont.systemFont(ofSize: cell.nameLbl.frame.height*0.75)
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! TableViewCellMultiCampusReportC
        
        UIView.animate(withDuration: 0.2){
            cell.selectedView.backgroundColor = UIColor(red: 56/255, green: 132/255, blue: 1.0, alpha: 1.0)
        }
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! TableViewCellMultiCampusReportC
        
        UIView.animate(withDuration: 0.2){
            cell.selectedView.backgroundColor = .white
        }
    }

    //MARK:- FirebaseDataProtocol
    
    func refresh() {
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
