//
//  ViewControllerHomeAdministrator.swift
//  prototipoApp
//
//  Created by Alumno on 02/11/21.
//

import UIKit
import FirebaseAuth

class ViewControllerHomeAdministrator: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIPopoverPresentationControllerDelegate, FirebaseDataProtocol {
    
    @IBOutlet weak var collectionView: UICollectionView!
    //@IBOutlet weak var multiCampusReportBtn: UIButton!
    
    private let refreshControl = UIRefreshControl()
    private let reuseIdentifier = "cell"
    private let itemsPerRow : CGFloat = 2
    private let sectionInsets = UIEdgeInsets(
        top: 20.0,
        left: 15.0,
        bottom: 20.0,
        right: 15.0
    )
    

    override func viewDidLoad() {
        super.viewDidLoad()
        dbHandler.getInfoFromDB()
        dbHandler.protocolDelegate = self
        
        if #available(iOS 10.0, *) {
            collectionView.refreshControl = refreshControl
        } else {
            collectionView.addSubview(refreshControl)
        }
        refreshControl.tintColor = UIColor(red:0.25, green:0.72, blue:0.85, alpha:1.0)
        refreshControl.attributedTitle = NSAttributedString(string: "Cargando datos", attributes: .none)

        
        refreshControl.addTarget(self, action: #selector(refreshControlData(_:)), for: .valueChanged)
        // Do any additional setup after loading the view.
        
        //multiCampusReportBtn.layer.cornerRadius = 10
        //multiCampusReportBtn.layer.masksToBounds = true
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
        if segue.identifier == "selectedCourseAdmin" {
            let nextView = segue.destination as! ViewControllerWorkshopCampus
            nextView.wId = dbHandler.workshops![collectionView.indexPathsForSelectedItems!.first!.item].id
            nextView.title = dbHandler.workshops![collectionView.indexPathsForSelectedItems!.first!.item].id
        }
        
        
        if segue.identifier == "logout" {
            let nextView = segue.destination as! ViewControllerLogoutPopover
            nextView.prevView2 = self
            nextView.popoverPresentationController!.delegate = self
        } else {
            let backItem = UIBarButtonItem()
            navigationItem.backBarButtonItem = backItem
        }
    }
    
    // MARK: - UICollectionViewDataSource
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dbHandler.workshops!.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! CollectionViewCellWorkshopAdmin
        
        cell.workshopId.text = dbHandler.workshops![indexPath.item].id
        cell.nameLbl.text = dbHandler.workshops![indexPath.item].name
        cell.workshopImage.image = UIImage(named: "Tec")!.alpha(0.75)
        
        cell.workshopId.backgroundColor = UIColor.white
        
        cell.workshopId.layer.shadowColor = UIColor.black.cgColor
        cell.workshopId.layer.shadowOffset = .zero
        cell.workshopId.layer.shadowRadius = 3
        cell.workshopId.layer.shadowOpacity = 0.5
        cell.workshopId.layer.masksToBounds = false
        cell.workshopId.layer.shadowPath = UIBezierPath(roundedRect: cell.workshopId.bounds, cornerRadius: 0).cgPath

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
        
        cell.nameLbl.font = .systemFont(ofSize: availableWidth*0.12)
        cell.workshopId.font = .systemFont(ofSize: cell.workshopId.frame.height*0.65)

        return cell
    }

    // MARK:- UICollectionViewDelegateFlowLayout
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
        let availableWidth = collectionView.frame.width - paddingSpace
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
    
    //MARK:- FirebaseDataProtocol
    
    func refresh() {
        self.refreshControl.endRefreshing()
        collectionView.reloadData()
    }
    
    func presentErrorAlert() {
        dbHandler = DatabaseHandler()
        let alert = UIAlertController(title: "Error", message: "Hubo un error al cargar los datos", preferredStyle: .alert)
        let accion = UIAlertAction(title: "Reintentar", style: .cancel, handler: nil)
        alert.addAction(accion)
        self.present(alert, animated: true, completion: dbHandler.getInfoFromDB)
    }
    
    //MARK:- UIRefreshControl
    @objc private func refreshControlData(_ sender : Any){
        dbHandler.getInfoFromDB()
        
    }

}
