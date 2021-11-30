//
//  ViewControllerMultiCampusReportPeriods.swift
//  prototipoApp
//
//  Created by Alumno on 19/11/21.
//

import UIKit

class ViewControllerMultiCampusReportPeriods: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    private let reuseIdentifier = "cell"
    @IBOutlet weak var generateReportBtn: UIButton!
    @IBOutlet weak var headerView: UIView!
    var campus : [Campus]!
    var workshops : [Workshop]!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dbHandler.protocolDelegate = nil
        
        // Do any additional setup after loading the view.
        
        let bottomLine = CALayer()
        bottomLine.frame = CGRect(x: 0, y: headerView.frame.height-1, width: view.frame.width-16, height: 1)
        bottomLine.backgroundColor = UIColor.black.cgColor
        headerView.layer.addSublayer(bottomLine)
        
        let idLbl = UILabel()
        idLbl.frame = CGRect.init(x: 8, y:0, width: headerView.frame.width, height: headerView.frame.height-1)
        idLbl.text = "Seleccione Periodos"
        idLbl.font = .systemFont(ofSize: headerView.frame.height*0.8, weight: .bold)
        
        headerView.addSubview(idLbl)
        
        generateReportBtn.layer.cornerRadius = 10
        generateReportBtn.layer.masksToBounds = true
    }
    
    // MARK:- Report Generator
    func shareFile(from csvString : String){
        let fileManager = FileManager.default
        do {
            let path = try fileManager.url(for: .documentDirectory, in: .allDomainsMask, appropriateFor: nil, create: false)
            print(path.absoluteURL)
            let fileURL = path.appendingPathComponent("reporteCampus.csv")
            try csvString.write(to: fileURL, atomically: true, encoding: .utf8)
            
            let activityVC = UIActivityViewController(activityItems: [fileURL], applicationActivities: nil)
            activityVC.popoverPresentationController?.sourceView = self.view
            self.present(activityVC, animated: true, completion: nil)
            print("File created sucessfully")
        } catch {
            print("Error creating file")
        }
    }
    
    @IBAction func generateReport(_ sender: UIButton) {
        var periods : [PreviousPeriod] = []
        
        if tableView.indexPathsForSelectedRows == nil {
            let alert = UIAlertController(title: "Error", message: "Tiene que seleccionar por lo menos un Periodo", preferredStyle: .alert)
            let accion = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alert.addAction(accion)
            self.present(alert, animated: true, completion: nil)
        } else {
            for tempdIdx in tableView.indexPathsForSelectedRows! {
                
                if tempdIdx.section == 0 {
                    periods.append(PreviousPeriod(name: dbHandler.currentPeriod!, id: ""))
                } else {
                    periods.append(dbHandler.previousPeriods![tempdIdx.row])
                }
            }
            var csvString = "Matricula, Nombre Completo, Campus, Clave Campus, Clave Taller, Nombre Taller, Calificacion, Acreditado, Nomina Coordinador, Nombre Coordinador\n"
            
            for tempC in campus{
                for tempW in workshops {
                    for tempP in periods {
                        let aWorkshop_ = dbHandler.availableWorkshops!.filter({return $0.campus_id == tempC.id && $0.workshop_id == tempW.id && $0.period == tempP.name}).first
                        
                        if let aWorkshop = aWorkshop_ {
                            let enrolledStudents = dbHandler.enrolledWorkshops!.filter({return $0.aWorkshop_id == aWorkshop.id})
                            
                            let rows = enrolledStudents.count
                            
                            var students : [Student] = []
                            
                            for i in enrolledStudents {
                                students.append(dbHandler.students!.filter({return $0.id == i.student_id}).first!)
                            }
                            
                            let workshop = dbHandler.workshops!.filter({return $0.id == aWorkshop.workshop_id}).first!
                            
                            let coordinator = dbHandler.coordinators!.filter({return $0.campus_id == tempC.id}).first!
                            
                            for i in 0..<rows{
                                let dataString = "\(students[i].id), \(students[i].name + " " + students[i].last_name), \(tempC.id), \(tempC.name), \(aWorkshop.id), \(workshop.name), \(enrolledStudents[i].grade), \(enrolledStudents[i].status), \(coordinator.id), \(coordinator.name + " " + coordinator.last_name)\n"
                                print(dataString)
                                csvString = csvString.appending(dataString)
                            }
                        }
                    }
                }
            }
            
            shareFile(from: csvString)
        }

        


        
    }
    
    
    // MARK:- UITableViewDataSource
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.frame.width/6
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        tableView.frame.width/7
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let titleView = UIView()
        
        titleView.frame = CGRect(x: 0, y: 0, width: tableView.frame.width, height: tableView.sectionHeaderHeight)
                
        let titleLbl = UILabel()
        
        titleLbl.frame = CGRect(x: 0, y: 0, width: tableView.frame.width, height: tableView.frame.width/7)
        
        if section == 0 {
            titleLbl.text = "Periodo Actual"
        } else {
            titleLbl.text = "Periodos Previos"
        }
        titleLbl.font = UIFont.systemFont(ofSize: titleLbl.frame.height*0.5, weight: .bold)

        titleView.addSubview(titleLbl)
        
        return titleView
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            return dbHandler.previousPeriods!.count

        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier) as! TableViewCellMultiCampusReportP
        let height = tableView.frame.width/6

        if indexPath.section == 0 {
            cell.nameLbl.text = dbHandler.currentPeriod!
        } else {
            cell.nameLbl.text = dbHandler.previousPeriods![indexPath.row].name
        }
        
        cell.nameLbl.frame = CGRect(x: 10, y: -3, width: cell.frame.width-10-tableView.frame.width/8, height: height)
        cell.selectedView.frame = CGRect(x: tableView.frame.width-height/8*3-10, y: -3, width: tableView.frame.width/8, height: height)
        
        cell.nameLbl.font = UIFont.systemFont(ofSize: cell.nameLbl.frame.height*0.3)
        
        
        return cell
    }

    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! TableViewCellMultiCampusReportP
        
        UIView.animate(withDuration: 0.2){
            cell.selectedView.backgroundColor = UIColor(red: 56/255, green: 132/255, blue: 1.0, alpha: 1.0)
        }
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! TableViewCellMultiCampusReportP
        
        UIView.animate(withDuration: 0.2){
            cell.selectedView.backgroundColor = .white
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
