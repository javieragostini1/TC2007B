//
//  ViewControllerWorkshopStudents.swift
//  prototipoApp
//
//  Created by Alumno on 02/11/21.
//

import UIKit

class ViewControllerWorkshopStudents: UIViewController, UITableViewDataSource, UITableViewDelegate, FirebaseDataProtocol {
    
    var awId : String?
    var prevView : ViewControllerWorkshopCampus!
    var aWorkshop : AvailableWorkshop!
    var selectedCampus : Campus!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var reportBtn: UIButton!
    var enrolledStudents : [EnrolledWorkshop] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dbHandler.protocolDelegate = self
        dbHandler.getInfoFromDB()
        // Do any additional setup after loading the view.
        //tableView.layer.cornerRadius = 10
        //tableView.layer.borderWidth = 1
        //tableView.layer.borderColor = UIColor.black.cgColor
        
        reportBtn.layer.cornerRadius = 10
        
        //view.backgroundColor = UIColor(red: 240/255, green: 236/255, blue: 232/255, alpha: 1)
        
        headerView.backgroundColor = UIColor.white
        
        let bottomLine = CALayer()
        bottomLine.frame = CGRect(x: 0, y: headerView.frame.height-1, width: view.frame.width-16, height: 1)
        bottomLine.backgroundColor = UIColor.black.cgColor
        headerView.layer.addSublayer(bottomLine)
        
        let idLbl = UILabel()
        idLbl.frame = CGRect.init(x: 8, y:0, width: headerView.frame.width, height: headerView.frame.height-1)
        idLbl.text = "Estudiantes"
        idLbl.font = .systemFont(ofSize: headerView.frame.height*0.8, weight: .bold)
        
        headerView.addSubview(idLbl)
        
        /*
        let bottomLine = CALayer()
        bottomLine.frame = CGRect(x: 0, y: headerView.frame.height-1, width: view.frame.width-16, height: 1)
        bottomLine.backgroundColor = UIColor.black.cgColor
        headerView.layer.addSublayer(bottomLine)
        
        let nameLbl = UILabel()
        nameLbl.frame = CGRect.init(x: 10, y:0, width: headerView.frame.width/2, height: tableView.sectionHeaderHeight)
        nameLbl.text = "Estudiante"
        nameLbl.font = .systemFont(ofSize: 23)
        
        let gradeLbl = UILabel()
        gradeLbl.frame = CGRect.init(x: view.frame.width/8*5+10-12, y:0, width: headerView.frame.width/8, height: tableView.sectionHeaderHeight)
        gradeLbl.text = "Cal."
        gradeLbl.font = .systemFont(ofSize: 23)
        
        let statusLbl = UILabel()
        statusLbl.frame = CGRect.init(x: view.frame.width/9*7+10-12, y:0, width: headerView.frame.width/9, height: tableView.sectionHeaderHeight)
        statusLbl.text = "Acr."
        statusLbl.font = .systemFont(ofSize: 23)
        
        headerView.addSubview(nameLbl)
        headerView.addSubview(gradeLbl)
        headerView.addSubview(statusLbl)
        */
    }
    
    override func viewDidAppear(_ animated: Bool) {
        dbHandler.getInfoFromDB()
    }
    
    
    // MARK: - Navigation
    
    override func didMove(toParent parent: UIViewController?) {
        super.willMove(toParent: parent)
        if parent == nil {
            if userData.type == "Administrator" {
                UIView.animate(withDuration: 0.1){
                    self.prevView.tableView.deselectRow(at: self.prevView.tableView.indexPathForSelectedRow!, animated: true)
                }
            }
        }
    }
    

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "selectedStudent" {
            let nextView = segue.destination as! ViewControllerStudentInfo
            nextView.prevView = self
            
            let idx = tableView.indexPathForSelectedRow!.row
            
            let infoStudent = dbHandler.students!.filter({return $0.id == enrolledStudents[idx].student_id})[0]
            nextView.eWInfo = enrolledStudents[idx]
            nextView.name = infoStudent.name + " " + infoStudent.last_name
            nextView.id = infoStudent.id
            nextView.grade = String(enrolledStudents[idx].grade)
            nextView.status = enrolledStudents[idx].status 
        } else if segue.identifier == "infoCourse" {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd/MM/YYYY"
            
            let nextView = segue.destination as! ViewControllerWorkshopInfo
            
            let infoAvailableWorkshop = dbHandler.availableWorkshops!.filter({return $0.id == awId})[0]
            let infoWorkshop = dbHandler.workshops!.filter({return $0.id == infoAvailableWorkshop.workshop_id})[0]
            
            nextView.title = infoAvailableWorkshop.id
            nextView.name = infoWorkshop.name
            nextView.grade = "false"
            nextView.date = "Fecha:   " + dateFormatter.string(from: infoAvailableWorkshop.start_time) + " - " + dateFormatter.string(from: infoAvailableWorkshop.end_time)
            nextView.workshopImg = UIImage(named: "test")
            nextView.desc = infoWorkshop.desc
            
        }
        let backItem = UIBarButtonItem()
        navigationItem.backBarButtonItem = backItem
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    
    //MARK:- UITableViewDataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView.init(frame: CGRect.init(x: 0, y:0, width: tableView.frame.width, height: tableView.sectionHeaderHeight))
        headerView.backgroundColor = UIColor.white
        
/*
        let bottomLine = CALayer()
        bottomLine.frame = CGRect(x: 0, y: headerView.frame.height-1, width: headerView.frame.width, height: 1)
        bottomLine.backgroundColor = UIColor.black.cgColor
        headerView.layer.addSublayer(bottomLine)
*/
        
        let nameLbl = UILabel()
        nameLbl.frame = CGRect.init(x: 10, y:0, width: headerView.frame.width/5*3-10, height: tableView.sectionHeaderHeight)
        nameLbl.text = "Estudiante"
        nameLbl.font = .systemFont(ofSize: 23)
        
/*
        let gradeLbl = UILabel()
        gradeLbl.frame = CGRect.init(x: headerView.frame.width/8*5+10, y:0, width: headerView.frame.width/8, height: tableView.sectionHeaderHeight)
        gradeLbl.text = "Cal."
        gradeLbl.font = .systemFont(ofSize: 23)
        gradeLbl.textAlignment = .center
*/
        let statusLbl = UILabel()
        statusLbl.frame = CGRect.init(x: headerView.frame.width/5*3, y:0, width: headerView.frame.width/5*2, height: tableView.sectionHeaderHeight)
        statusLbl.text = "Acreditado"
        statusLbl.font = .systemFont(ofSize: 23)
        statusLbl.textAlignment = .center

        headerView.addSubview(nameLbl)
        headerView.addSubview(statusLbl)
        

        return headerView
    }
 
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return (view.frame.width-16)/8
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return enrolledStudents.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TableViewCellStudents
        
        let studentInfo = dbHandler.students!.filter({return $0.id == enrolledStudents[indexPath.row].student_id})[0]
        
        let height = (view.frame.width-16)/8
        let width = view.frame.width-16
        
        cell.nameLbl.text = studentInfo.name + " " + studentInfo.last_name
        if enrolledStudents[indexPath.row].status {
            cell.statusLbl.text = "Si"
        } else {
            cell.statusLbl.text = "No"
        }
        cell.statusLbl.textAlignment = .center
        
        
        cell.nameLbl.frame = CGRect.init(x: 10, y:0, width: width/5*3-10, height: height-6)

    
        cell.statusLbl.frame = CGRect.init(x: width/5*3, y:0, width: width/5*2, height: height-6)
        
        
        
        return cell
    }
    
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
    
    @IBAction func generarReporte(_ sender: UIButton) {
        var csvString = "Matricula, Nombre Completo, Campus, Clave Campus, Clave Taller, Nombre Taller, Calificacion, Acreditado, Nomina Coordinador, Nombre Coordinador\n"
        
        let rows = enrolledStudents.count
        
        var students : [Student] = []
        
        for i in enrolledStudents {
            students.append(dbHandler.students!.filter({return $0.id == i.student_id}).first!)
        }
        
        let workshop = dbHandler.workshops!.filter({return $0.id == aWorkshop.workshop_id}).first!
        
        let coordinator = dbHandler.coordinators!.filter({return $0.campus_id == selectedCampus.id}).first!
        
        for i in 0..<rows{
            let dataString = "\(students[i].id), \(students[i].name + " " + students[i].last_name), \(selectedCampus.id), \(selectedCampus.name), \(aWorkshop.id), \(workshop.name), \(enrolledStudents[i].grade), \(enrolledStudents[i].status), \(coordinator.id), \(coordinator.name + " " + coordinator.last_name)\n"
            print(dataString)
            csvString = csvString.appending(dataString)
        }
        
        shareFile(from: csvString)
        
    }
    
    //MARK:- FirebaseDataProtocol
    
    func refresh() {
        enrolledStudents = dbHandler.enrolledWorkshops!.filter({return $0.aWorkshop_id == awId!})
        
        aWorkshop = dbHandler.availableWorkshops!.filter({return $0.id == awId!}).first!
        selectedCampus = dbHandler.campus!.filter({return $0.id == aWorkshop!.campus_id}).first!
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
