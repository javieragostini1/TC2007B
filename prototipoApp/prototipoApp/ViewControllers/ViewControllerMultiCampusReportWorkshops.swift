//
//  ViewControllerMultiCampusReportWorkshops.swift
//  prototipoApp
//
//  Created by Alumno on 02/11/21.
//

import UIKit

class ViewControllerMultiCampusReportWorkshops: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var nextBtn: UIButton!
    private let reuseIdentifier = "cell"
    var campus : [Campus]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dbHandler.protocolDelegate = nil
        
        let bottomLine = CALayer()
        bottomLine.frame = CGRect(x: 0, y: headerView.frame.height-1, width: view.frame.width-16, height: 1)
        bottomLine.backgroundColor = UIColor.black.cgColor
        headerView.layer.addSublayer(bottomLine)
        
        let idLbl = UILabel()
        idLbl.frame = CGRect.init(x: 8, y:0, width: headerView.frame.width, height: headerView.frame.height-1)
        idLbl.text = "Seleccione Talleres"
        idLbl.font = .systemFont(ofSize: headerView.frame.height*0.8, weight: .bold)
        
        headerView.addSubview(idLbl)
        // Do any additional setup after loading the view.
        
        nextBtn.layer.cornerRadius = 10
        nextBtn.layer.masksToBounds = true
    }
    

    
    // MARK: - Navigation
    

    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if tableView.indexPathsForSelectedRows == nil {
            let alert = UIAlertController(title: "Error", message: "Tiene que seleccionar por lo menos un Taller", preferredStyle: .alert)
            let accion = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alert.addAction(accion)
            self.present(alert, animated: true, completion: nil)
            return false
        }
        return true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        let nextView = segue.destination as! ViewControllerMultiCampusReportPeriods
        
        var workshops : [Workshop] = []
        
        for tempIdx in tableView.indexPathsForSelectedRows! {
            workshops.append(dbHandler.workshops![tempIdx.row])
        }
        
        nextView.campus = self.campus
        nextView.workshops = workshops
        
        
         let backItem = UIBarButtonItem()
         navigationItem.backBarButtonItem = backItem
    }

    // MARK:- UITableViewDataSource
    
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
        idLbl.frame = CGRect.init(x: 10, y:0, width: headerView.frame.width/6, height: tableView.sectionHeaderHeight)
        idLbl.text = "Clave"
        idLbl.font = .systemFont(ofSize: 23)
        
        let nameLbl = UILabel()
        nameLbl.frame = CGRect.init(x: headerView.frame.width/6+10, y:0, width: headerView.frame.width/6*5, height: tableView.sectionHeaderHeight)
        nameLbl.text = "Nombre"
        nameLbl.font = .systemFont(ofSize: 23)
        
        
        headerView.addSubview(idLbl)
        headerView.addSubview(nameLbl)
        

        return headerView
    }
    */
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        dbHandler.workshops!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier) as! TableViewCellMultiCampusReportW
        
        let infoWorkshop = dbHandler.workshops![indexPath.row]
        let height = (view.frame.width-16)/5
        let width = view.frame.width-16

        cell.idLbl.text = infoWorkshop.id
        cell.nameLbl.text = infoWorkshop.name.replacingOccurrences(of: "\n", with: " ")
        

        cell.idLbl.frame = CGRect(x: 10, y: -3, width: width/3-10, height: height/3*2)
        cell.nameLbl.frame = CGRect(x: 10, y: height/4*2.2-3, width: width-10-width/8, height: height/3)
        cell.selectedView.frame = CGRect(x: width-height/8*3-10, y: -3, width: width/8, height: height)
        
        cell.idLbl.font = UIFont.systemFont(ofSize: cell.idLbl.frame.height/2, weight: .bold)
        cell.nameLbl.font = UIFont.systemFont(ofSize: cell.nameLbl.frame.height*0.6)
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! TableViewCellMultiCampusReportW
        
        UIView.animate(withDuration: 0.2){
            cell.selectedView.backgroundColor = UIColor(red: 56/255, green: 132/255, blue: 1.0, alpha: 1.0)
        }
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! TableViewCellMultiCampusReportW
        
        UIView.animate(withDuration: 0.2){
            cell.selectedView.backgroundColor = .white
        }
    }
}
