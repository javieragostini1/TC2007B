//
//  CollectionViewControllerHomeStudentCoordinator.swift
//  prototipoApp
//
//  Created by Alumno on 02/11/21.
//

import UIKit
import FirebaseAuth

class CollectionViewControllerHomeStudentCoordinator: UICollectionViewController, UICollectionViewDelegateFlowLayout, UIPopoverPresentationControllerDelegate, FirebaseDataProtocol {
    
    private let refreshControl = UIRefreshControl()
    private let reuseIdentifier = "cell"
    private let itemsPerRow : CGFloat = 2
    private let sectionInsets = UIEdgeInsets(
        top: 0.0,
        left: 15.0,
        bottom: 25.0,
        right: 15.0
    )
    
    var totalAWorkshops : [AvailableWorkshop] = []
    var totalNAWorkshops : [AvailableWorkshop] = []
    var workshopsATemp = dbHandler.workshops!.filter({return $0.requierment <= userData.current_period!})
    var workshopsNATemp = dbHandler.workshops!.filter({return $0.requierment > userData.current_period!})

    

    override func viewDidLoad() {
        super.viewDidLoad()
        dbHandler.protocolDelegate = self
        dbHandler.getInfoFromDB()
        
        if #available(iOS 10.0, *) {
            collectionView.refreshControl = refreshControl
        } else {
            collectionView.addSubview(refreshControl)
        }
        refreshControl.tintColor = UIColor(red:0.25, green:0.72, blue:0.85, alpha:1.0)
        refreshControl.attributedTitle = NSAttributedString(string: "Cargando datos", attributes: .none)

        
        refreshControl.addTarget(self, action: #selector(refreshControlData(_:)), for: .valueChanged)

    }
    
    override func viewDidAppear(_ animated: Bool) {
        dbHandler.protocolDelegate = self
        dbHandler.getInfoFromDB()
    }

    
    // MARK: - Navigation
    func SignOut(){
        do {
            try Auth.auth().signOut()
            dbHandler = DatabaseHandler()
            userData = UserData()
            print("logout successful")
            dismiss(animated: true, completion: nil)
        } catch {
            print("Error loging out")
        }
    }
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
        if segue.identifier == "selectedCourse" {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd/MM/YYYY"
            
            let nextView = segue.destination as! ViewControllerWorkshopInfo
            
            let indexPath = collectionView.indexPathsForSelectedItems!.first
            
            if indexPath!.section == 0 {
                
                var infoAvailableWorkshop : AvailableWorkshop
                if (userData.type == "Student") {
                    infoAvailableWorkshop = totalAWorkshops[indexPath!.item]

                } else {
                    infoAvailableWorkshop = dbHandler.availableWorkshops![indexPath!.item]
                }
                let infoWorkshop = dbHandler.workshops!.filter({return $0.id == infoAvailableWorkshop.workshop_id})[0]
                
                nextView.title = infoAvailableWorkshop.id
                
                nextView.AWId = totalAWorkshops[collectionView.indexPathsForSelectedItems!.first!.item].id
                
                nextView.name = infoWorkshop.name
                nextView.date = "Fecha:   " + dateFormatter.string(from: infoAvailableWorkshop.start_time) + " - " + dateFormatter.string(from: infoAvailableWorkshop.end_time)
                nextView.workshopImg = UIImage(named: "Tec")
                nextView.desc = infoWorkshop.desc
            } else if indexPath!.section == 1 {
                let infoAWorkshop = dbHandler.availableWorkshops!.filter({return $0.id == dbHandler.enrolledWorkshops![indexPath!.item].aWorkshop_id})[0]
                let infoWorkshop = dbHandler.workshops!.filter({return $0.id == infoAWorkshop.workshop_id})[0]
                
                nextView.title = infoAWorkshop.id
                
                nextView.name = infoWorkshop.name
                nextView.date = "Fecha:   " + dateFormatter.string(from: infoAWorkshop.start_time) + " - " + dateFormatter.string(from: infoAWorkshop.end_time)
                
                nextView.grade = String(dbHandler.enrolledWorkshops![indexPath!.item].grade)
                
                nextView.workshopImg = UIImage(named: "Tec")
                nextView.desc = infoWorkshop.desc
            } else {
                let infoAvailableWorkshop = totalNAWorkshops[indexPath!.item]
                let infoWorkshop = dbHandler.workshops!.filter({return $0.id == infoAvailableWorkshop.workshop_id})[0]
                
                nextView.title = infoAvailableWorkshop.id
                
                nextView.name = infoWorkshop.name
                nextView.date = "Fecha:   " + dateFormatter.string(from: infoAvailableWorkshop.start_time) + " - " + dateFormatter.string(from: infoAvailableWorkshop.end_time)
                nextView.workshopImg = UIImage(named: "Tec")
                nextView.desc = infoWorkshop.desc
                nextView.grade = "-1"
            }
            
        } else if segue.identifier == "selectedCourseCoordinator" {
            let nextView = segue.destination as! ViewControllerWorkshopStudents
            
            let indexPath = collectionView.indexPathsForSelectedItems!.first
            
            let infoAvailableWorkshop = dbHandler.availableWorkshops![indexPath!.item]
            
            nextView.awId = infoAvailableWorkshop.id
            
            nextView.title = infoAvailableWorkshop.id
            
        }
        
        if segue.identifier == "logout" {
            let nextView = segue.destination as! ViewControllerLogoutPopover
            nextView.popoverPresentationController!.delegate = self
            nextView.prevView1 = self
        } else {
            let backItem = UIBarButtonItem()
            navigationItem.backBarButtonItem = backItem
        }
        
        
    }
    

    // MARK: UICollectionViewDataSource
    
    

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        if userData.type == "Student" {
            return 3
        }
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        if section == 0{
            if (userData.type == "Student") {
                return totalAWorkshops.count
            } else {
                return dbHandler.availableWorkshops!.count
            }
            
        } else if section == 1 {
            return dbHandler.enrolledWorkshops!.count
        } else if section == 2 {
            return totalNAWorkshops.count
        }
        return 0
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            let headerCell = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "headerCell", for: indexPath) as! CollectionReusableViewCustom
            
            if indexPath.section == 0 {
                headerCell.sectionNameLbl.text = "Talleres Disponibles "
            } else if indexPath.section == 1 {
                headerCell.sectionNameLbl.text = "Talleres Inscritos "
            } else if indexPath.section == 2 {
                headerCell.sectionNameLbl.text = "Talleres No Disponibles "
            }
            
            return headerCell
        default:
            assert(false, "Invalid element type")
        }
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! CollectionViewCellWorkshop
        cell.gradeLbl.isHidden = true
        if indexPath.section == 0 {
            var infoWorkshop : Workshop
            if (userData.type == "Student") {
                infoWorkshop = dbHandler.workshops!.filter({return $0.id == totalAWorkshops[indexPath.item].workshop_id})[0]
                cell.workshopId.text = totalAWorkshops[indexPath.item].id

            } else {
                infoWorkshop = dbHandler.workshops!.filter({return $0.id == dbHandler.availableWorkshops![indexPath.item].workshop_id})[0]
                cell.workshopId.text = dbHandler.availableWorkshops![indexPath.item].id

            }
            
            cell.nameLbl.text = infoWorkshop.name
        } else if indexPath.section == 1 {
            cell.gradeLbl.isHidden = false
            let infoAWorkshop = dbHandler.availableWorkshops!.filter({return $0.id == dbHandler.enrolledWorkshops![indexPath.item].aWorkshop_id})[0]
            let infoWorkshop = dbHandler.workshops!.filter({return $0.id == infoAWorkshop.workshop_id})[0]
            
            cell.workshopId.text = dbHandler.enrolledWorkshops![indexPath.item].aWorkshop_id
            cell.nameLbl.text = infoWorkshop.name
            if dbHandler.enrolledWorkshops![indexPath.item].grade != -1 {
                cell.gradeLbl.text = String(dbHandler.enrolledWorkshops![indexPath.item].grade) + " %"
                cell.gradeLbl.backgroundColor = .white
            } else {
                cell.gradeLbl.text = "SC"
                cell.gradeLbl.backgroundColor = .white
            }
            
        } else if indexPath.section == 2 {
            let infoWorkshop = dbHandler.workshops!.filter({return $0.id == totalNAWorkshops [indexPath.item].workshop_id})[0]
            
            cell.workshopId.text = totalNAWorkshops[indexPath.item].id
            cell.nameLbl.text = infoWorkshop.name
        }
        
        cell.workshopImage.image = UIImage(named: "Tec")?.alpha(0.75)
        
        cell.workshopId.backgroundColor = UIColor.white
        cell.workshopId.layer.shadowColor = UIColor.black.cgColor
        cell.workshopId.layer.shadowOffset = .zero
        cell.workshopId.layer.shadowRadius = 3
        cell.workshopId.layer.shadowOpacity = 0.5
        cell.workshopId.layer.masksToBounds = false
        cell.workshopId.layer.shadowPath = UIBezierPath(roundedRect: cell.workshopId.bounds, cornerRadius: 0).cgPath
        
        cell.gradeLbl.layer.masksToBounds = true
        cell.gradeLbl.layer.cornerRadius = 10
        cell.gradeLbl.layer.shadowColor = UIColor.black.cgColor
        cell.gradeLbl.layer.shadowOffset = .zero
        cell.gradeLbl.layer.shadowRadius = 3
        cell.gradeLbl.layer.shadowOpacity = 0.5
        cell.gradeLbl.layer.shadowPath = UIBezierPath(roundedRect: cell.gradeLbl.bounds, cornerRadius: 10).cgPath

        cell.contentView.layer.cornerRadius = 5
        cell.contentView.backgroundColor = UIColor.white
        cell.contentView.layer.masksToBounds = true
        
        cell.layer.shadowColor = UIColor.black.cgColor
        cell.layer.shadowOffset = CGSize(width: 1, height: 1)
        cell.layer.shadowRadius = 2.0
        cell.layer.shadowOpacity = 0.5
        cell.layer.masksToBounds = false
        cell.layer.shadowPath = UIBezierPath(roundedRect: cell.bounds, cornerRadius: cell.contentView.layer.cornerRadius).cgPath
        
        let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
        let availableWidth = (collectionView.frame.width - paddingSpace)/itemsPerRow
        
        cell.workshopId.frame = CGRect(x: 0, y: availableWidth*(135/165), width: availableWidth, height: availableWidth*(30/165))
        cell.workshopImage.frame = CGRect(x: 0, y: 0, width: availableWidth, height: availableWidth*(135/165))
        cell.imageMask.frame = CGRect(x: 0, y: 0, width: availableWidth, height: availableWidth*(135/165))
        cell.nameLbl.frame = CGRect(x: 0, y: 0, width: availableWidth, height: availableWidth*(135/165))
        cell.gradeLbl.frame = CGRect(x: availableWidth-availableWidth/3-4, y: 4, width: availableWidth/3, height: 25)
    
        cell.workshopId.font = .systemFont(ofSize: cell.workshopId.frame.height*0.65)
        
        return cell
    }

    // MARK:- UICollectionViewDelegate

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if userData.type == "Student" {
            performSegue(withIdentifier: "selectedCourse", sender: self)
        } else if userData.type == "Coordinator" {
            performSegue(withIdentifier: "selectedCourseCoordinator", sender: self)
        }
    }
    
    // MARK:- UICollectionViewDelegateFlowLayout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
        let availableWidth = view.frame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow
        
        return CGSize(width: widthPerItem, height: widthPerItem)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left
    }

    // MARK:- UIPopoverPresentationControllerDelegate
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
    
    // MARK:- FirebaseDataProtocol
    
    func refresh() {
        totalAWorkshops = []
        totalNAWorkshops = []
        workshopsATemp = dbHandler.workshops!.filter({return $0.requierment <= userData.current_period!})
        workshopsNATemp = dbHandler.workshops!.filter({return $0.requierment > userData.current_period!})
        var limit : Bool! = false
        
        for tempW in workshopsATemp {
            let temp = dbHandler.availableWorkshops!.filter({return $0.workshop_id == tempW.id})
            
            for tempW1 in temp {
                let temp2 = dbHandler.enrolledWorkshops!.filter({return $0.aWorkshop_id == tempW1.id})
                if limit {
                        totalNAWorkshops.append(tempW1)
                        totalNAWorkshops.sort(by: {$0.id < $1.id})
                } else {
                    var hasntCoursed : Bool = false
                    var hasntPassed : Bool = true
                    if temp2.count == 0 {
                        hasntCoursed = true
                    } else {
                        for tempW2 in temp2 {
                            if tempW2.status == true {
                                hasntPassed = false
                                break
                            } else {
                                
                            }
                        }
                    }
                    
                    if hasntCoursed {
                        limit = true
                        totalAWorkshops.append(tempW1)
                    } else {
                        if hasntPassed {
                            limit = true
                            if tempW1.period != dbHandler.currentPeriod!{
                                totalAWorkshops.append(tempW1)
                            }
                        }
                    }
                }
            }
        }
        
        for tempW in workshopsNATemp {
            let temp = dbHandler.availableWorkshops!.filter({return $0.workshop_id == tempW.id})
            totalNAWorkshops.append(contentsOf: temp)
        }
        
        self.refreshControl.endRefreshing()
        collectionView.reloadData()
    }
    
    func presentErrorAlert() {
        let alert = UIAlertController(title: "Error", message: "Hubo un error al cargar los datos", preferredStyle: .alert)
        let accion = UIAlertAction(title: "Reintentar", style: .cancel, handler: nil)
        alert.addAction(accion)
        dbHandler = DatabaseHandler()
        present(alert, animated: true, completion: dbHandler.getInfoFromDB)
    }
    
    //MARK:- UIRefreshControl
    
    @objc private func refreshControlData(_ sender : Any){
        dbHandler.getInfoFromDB()
    }
    
    
    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */

}
