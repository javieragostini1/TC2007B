//
//  DatabaseHandler.swift
//  prototipoApp
//
//  Created by Alumno on 02/11/21.
//

import UIKit

import FirebaseFirestore

protocol FirebaseDataProtocol {
    func refresh()
    func presentErrorAlert()
}

class DatabaseHandler: NSObject {
    
    var protocolDelegate : FirebaseDataProtocol?
    
    let db = Firestore.firestore()
    
    var queryCompletion : [Bool] = [false, false, false, false, false, false, false, false, false]
    
    var campus : [Campus]? = []
    var workshops : [Workshop]? = []

    var adminstrators : [Administrator]? = []
    var coordinators : [Coordinator]? = []
    var students : [Student]? = []

    var availableWorkshops : [AvailableWorkshop]? = []
    var enrolledWorkshops : [EnrolledWorkshop]? = []
    
    var currentPeriod : String?
    var previousPeriods : [PreviousPeriod]? = []
    
    func init_(){
        db.settings.isPersistenceEnabled = false
    }
    
    private func checkCompletion(){
        if queryCompletion.allSatisfy({$0}) {
            protocolDelegate?.refresh()
            queryCompletion = queryCompletion.map{_ in false}
        }
    }
    
    
    
    func getInfoFromDB() {
        
        
        db.collection("Campus").getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                    self.protocolDelegate?.presentErrorAlert()
                    return
                } else {
                    self.campus = []
                    for document in querySnapshot!.documents {
                        //print("\(document.documentID) => \(document.data())")
                        let cId = document.data()["Id"]! as! String
                        let cName = document.data()["Name"]! as! String
                        let newCampus = Campus(id: cId, name: cName)
                        self.campus!.append(newCampus)
                        // print(self.campus.count)
                    }
                    self.queryCompletion[0] = true
                    self.campus!.sort(by: {$0.id < $1.id})
                    self.checkCompletion()
                    
                }
        }
        
        db.collection("Workshop").getDocuments() { (querySnapshot, err) in
                if let err = err {
                    self.protocolDelegate?.presentErrorAlert()
                    print("Error getting documents: \(err)")
                    return
                } else {
                    self.workshops = []
                    for document in querySnapshot!.documents {
                        //print("\(document.documentID) => \(document.data())")
                        let wDesc = document.data()["Description"]! as! String
                        let wId = document.data()["Id"]! as! String
                        let wImg = document.data()["Image"]! as! String
                        let wName = document.data()["Name"]! as! String
                        let wReq = (document.data()["Requirement"]! as! NSString).intValue
                        let newWorkshop = Workshop(id: wId, name: wName, desc: wDesc, image: wImg, requierment: Int(wReq))
                        self.workshops!.append(newWorkshop)
                        //print(self.workshops.count)
                    }
                    self.queryCompletion[1] = true
                    self.workshops!.sort(by: {$0.id < $1.id})
                    self.checkCompletion()

                }
        }
        
        let currPeriodRef = db.collection("Period")
        currPeriodRef.whereField("Current_period", isEqualTo: true)
            .getDocuments() { (querySnapshot, err) in
                if let err = err {
                    self.protocolDelegate?.presentErrorAlert()
                    print("Error getting documents: \(err)")
                    return
                } else {
                    for document in querySnapshot!.documents {
                        //print("\(document.documentID) => \(document.data())")
                        self.currentPeriod = (document.data()["Name"] as! String)
                    }
                    self.queryCompletion[2] = true
                    self.getWorkshops()
                    self.checkCompletion()

                }
        }
        
//        self.currentPeriod = "AGO-NOV 2021"
        
        let prevPeriodRef = db.collection("Period")
        prevPeriodRef.whereField("Current_period", isEqualTo: false)
            .getDocuments() { (querySnapshot, err) in
                if let err = err {
                    self.protocolDelegate?.presentErrorAlert()
                    print("Error getting documents: \(err)")
                    return
                } else {
                    self.previousPeriods = []
                    for document in querySnapshot!.documents {
                        //print("\(document.documentID) => \(document.data())")
                        let pName = document.data()["Name"]! as! String
                        let pId = document.data()["Id"]! as! String
                        let newPreviousPeriod = PreviousPeriod(name: pName, id: pId)
                        self.previousPeriods!.append(newPreviousPeriod)
                        //print(self.previousPeriods.count)

                    }
                    self.queryCompletion[3] = true
                    self.previousPeriods!.sort(by: {$0.id < $1.id})
                    self.checkCompletion()

                }
        }
        
//        self.workshops = [
//            Workshop(id: "w01", name: "Liderazgo Positivo y Transformacion Personal", desc: "Transformar su vida y aumentar tu riqueza y capital psicologico, con el fin de tener mayor exito estudiantil, lograr una mayor influencia en su contexto y cambiar el entorno", image: "nil", requierment: 1),
//            Workshop(id: "w02", name: "Mis habilidades y motivaciones ", desc: "Reconocimiento de habilidades, destrezas, fortalezas. FODA. GATO", image: "nil", requierment: 2),
//            Workshop(id: "w03", name: "Mis emociones", desc: "Que son las emociones? Emociones, biologia de la salud. Importancia de las emociones. Identification de emociones. Tipos de emociones. Inteligencia emocional.", image: "nil", requierment: 3),
//            Workshop(id: "w04", name: "Mis relaciones", desc: "Desarrollo de empatia. (Competencias emocionales e interpersonales). Tipos de relaciones. Aspectos importantes en las relaciones. Limites personales. Mis relaciones interpersonales. Mapa de mis relaciones.", image: "nil", requierment: 4),
//            Workshop(id: "w05", name: "Mis areas de oportunidad", desc: "Metamomento. Expresion de emociones. Posiciones ante la comunicacion de emociones. La inteligencia emocional y la comunicacion asertiva. Regulation de emociones. Desarrollo de resolution de conflictos (El piano inteligente-emocional)", image: "nil", requierment: 5),
//            Workshop(id: "w06", name: "Mis metas", desc: "Esferas/dimensiones de la persona. Equilibrio para lograr el bienestar. *PFP. Metodologia SMART. Desarrollo de plan de action y toma de decisiones.", image: "nil", requierment: 6)
//        ]
        
        let adminRef = db.collection("Users")
        adminRef.whereField("Role", isEqualTo: "Administrator")
            .getDocuments() { (querySnapshot, err) in
                if let err = err {
                    self.protocolDelegate?.presentErrorAlert()
                    print("Error getting documents: \(err)")
                    return
                } else {
                    self.adminstrators = []
                    for document in querySnapshot!.documents {
                        //print("\(document.documentID) => \(document.data())")
                        let aId = document.data()["Id"]! as! String
                        let aName = document.data()["Name"]! as! String
                        let aLastName = document.data()["Last_name"]! as! String
                        let newAdmin = Administrator(id: aId, name: aName, last_name: aLastName)
                        self.adminstrators!.append(newAdmin)
                        //print(self.adminstrators.count)
                    }
                    self.queryCompletion[4] = true
                    self.adminstrators!.sort(by: {$0.id < $1.id})
                    self.checkCompletion()

                }
        }
        
        
        let coordRef = db.collection("Users")
        coordRef.whereField("Role", isEqualTo: "Coordinator")
            .getDocuments() { (querySnapshot, err) in
                if let err = err {
                    self.protocolDelegate?.presentErrorAlert()
                    print("Error getting documents: \(err)")
                    return
                } else {
                    self.coordinators = []
                    for document in querySnapshot!.documents {
                        //print("\(document.documentID) => \(document.data())")
                        let cId = document.data()["Id"]! as! String
                        let cName = document.data()["Name"]! as! String
                        let cLastName = document.data()["Last_name"]! as! String
                        let cCampus = document.data()["Campus_id"] as! String
                        let newCoord = Coordinator(id: cId, name: cName, last_name: cLastName, campus_id: cCampus)
                        self.coordinators!.append(newCoord)
                        //print(self.coordinators.count)

                    }
                    self.queryCompletion[5] = true
                    self.coordinators!.sort(by: {$0.id < $1.id})
                    self.checkCompletion()

                }
        }
        
        
        let studentRef = db.collection("Users")
        studentRef.whereField("Role", isEqualTo: "Student")
            .getDocuments() { (querySnapshot, err) in
                if let err = err {
                    self.protocolDelegate?.presentErrorAlert()
                    print("Error getting documents: \(err)")
                    return
                } else {
                    self.students = []

                    for document in querySnapshot!.documents {
                        //print("\(document.documentID) => \(document.data())")
                        let sId = document.data()["Id"]! as! String
                        let sName = document.data()["Name"]! as! String
                        let sLastName = document.data()["Last_name"]! as! String
                        let sCampus = document.data()["Campus_id"] as! String
                        let sPeriod = (document.data()["Current_period"]! as! NSString).intValue
                        let newStudent = Student(id: sId, name: sName, last_name: sLastName, campus_id: sCampus, current_period: Int(sPeriod))
                        self.students!.append(newStudent)
                        //print(self.students.count)

                    }
                    self.queryCompletion[6] = true
                    self.students!.sort(by: {$0.id < $1.id})
                    self.checkCompletion()

                }
        }
        
//        self.previousPeriods = [
//            PreviousPeriod(name: "ENE-ABR 2021"),
//            PreviousPeriod(name: "MAY-AGO 2021"),
//            PreviousPeriod(name: "AGO-NOV 2021")
//        ]
        
        
       
    
    }

    
    //MARK:- Workshops
    
    private func getWorkshops() {
        let userType = userData.type!
        if (userType == "Student") {
            let aWorkshopRef = db.collection("Available_workshop")
            aWorkshopRef
                .whereField("Campus_id", isEqualTo: userData.campusId!)
                .whereField("Period", isEqualTo: currentPeriod!)
                .getDocuments() { (querySnapshot, err) in
                    if let err = err {
                        self.protocolDelegate?.presentErrorAlert()
                        print("Error getting documents: \(err)")
                        return
                    } else {
                        self.availableWorkshops = []
                        for document in querySnapshot!.documents {
                            //print("\(document.documentID) => \(document.data())")
                            let aWId = document.data()["Id"]! as! String
                            let aWWId = document.data()["Workshop_id"]! as! String
                            let aWCampus = document.data()["Campus_id"]! as! String
                            let aWStartTime = (document.data()["Start_time"] as! Timestamp).dateValue()
                            let aWEndTime = (document.data()["End_time"] as! Timestamp).dateValue()
                            let aWPeriod = document.data()["Period"]! as! String
                            let newAvailableWorkshop = AvailableWorkshop(id: aWId, workshop_id: aWWId, campus_id: aWCampus, start_time: aWStartTime, end_time: aWEndTime, period: aWPeriod)
                            self.availableWorkshops!.append(newAvailableWorkshop)
                            //print(self.availableWorkshops.count)

                        }
                        self.queryCompletion[7] = true
                        self.availableWorkshops!.sort(by: {$0.id < $1.id})
                        self.checkCompletion()

                    }
            }
            
           
            let eWorkshopRef = db.collection("Enrolled_workshop")
            eWorkshopRef.whereField("Student_id", isEqualTo: userData.id!)
                .getDocuments() { (querySnapshot, err) in
                    if let err = err {
                        self.protocolDelegate?.presentErrorAlert()
                        print("Error getting documents: \(err)")
                        return
                    } else {
                        self.enrolledWorkshops = []
                        for document in querySnapshot!.documents {
                            //print("\(document.documentID) => \(document.data())")
                            let eAWId = document.data()["AWorkshop_id"]! as! String
                            let registerId = document.data()["Register_id"]! as! String
                            let sId = document.data()["Student_id"]! as! String
                            let st = document.data()["Status"] as! Bool
                            let gr = document.data()["Grade"] as! Int
                            let newEnrolledWorkshop = EnrolledWorkshop(aWorkshop_id: eAWId, register_id: registerId, student_id: sId, status: st, grade: gr)
                            self.enrolledWorkshops!.append(newEnrolledWorkshop)
                            //print(self.enrolledWorkshops!.count)

                        }
                        self.queryCompletion[8] = true
                        self.enrolledWorkshops!.sort(by: {$0.register_id < $1.register_id})
                        self.checkCompletion()

                    }
            }
            
        } else if (userType == "Coordinator") {
            
            let aWorkshopRef = db.collection("Available_workshop")
            aWorkshopRef
                .whereField("Campus_id", isEqualTo: userData.campusId!)
                .whereField("Period", isEqualTo: currentPeriod!)
                .getDocuments() { (querySnapshot, err) in
                    if let err = err {
                        self.protocolDelegate?.presentErrorAlert()
                        print("Error getting documents: \(err)")
                        return
                    } else {
                        self.availableWorkshops = []
                        for document in querySnapshot!.documents {
                            //print("\(document.documentID) => \(document.data())")
                            let aWId = document.data()["Id"]! as! String
                            let aWWId = document.data()["Workshop_id"]! as! String
                            let aWCampus = document.data()["Campus_id"]! as! String
                            let aWStartTime = (document.data()["Start_time"] as! Timestamp).dateValue()
                            let aWEndTime = (document.data()["End_time"] as! Timestamp).dateValue()
                            let aWPeriod = document.data()["Period"]! as! String
                            let newAvailableWorkshop = AvailableWorkshop(id: aWId, workshop_id: aWWId, campus_id: aWCampus, start_time: aWStartTime, end_time: aWEndTime, period: aWPeriod)
                            self.availableWorkshops!.append(newAvailableWorkshop)
                            //print(self.availableWorkshops.count)
                        }
                        self.queryCompletion[7] = true
                        self.availableWorkshops!.sort(by: {$0.id < $1.id})
                        self.checkCompletion()

                    }
            }
            
            db.collection("Enrolled_workshop").getDocuments() { (querySnapshot, err) in
                    if let err = err {
                        self.protocolDelegate?.presentErrorAlert()
                        print("Error getting documents: \(err)")
                        return
                    } else {
                        self.enrolledWorkshops = []
                        var tempEW : [EnrolledWorkshop] = []
                        for document in querySnapshot!.documents {
                            //print("\(document.documentID) => \(document.data())")
                            let eAWId = document.data()["AWorkshop_id"]! as! String
                            let registerId = document.data()["Register_id"]! as! String
                            let sId = document.data()["Student_id"]! as! String
                            let st = document.data()["Status"] as! Bool
                            let gr = document.data()["Grade"] as! Int
                            let newEnrolledWorkshop = EnrolledWorkshop(aWorkshop_id: eAWId, register_id: registerId, student_id: sId, status: st, grade: gr)
                            tempEW.append(newEnrolledWorkshop)
                            //print(self.enrolledWorkshops!.count)

                        }
                        
                        for temp in tempEW {
                            let temp1 = self.availableWorkshops!.filter({return $0.id == temp.aWorkshop_id}).first
                            if let temp2 = temp1 {
                                if temp2.campus_id == userData.campusId {
                                    self.enrolledWorkshops!.append(temp)
                                    //print(temp.register_id)
                                }
                            }
                        }
                        
                        self.queryCompletion[8] = true
                        self.enrolledWorkshops!.sort(by: {$0.register_id < $1.register_id})
                        self.checkCompletion()

                    }
            }
            
           
        } else {
            
            db.collection("Available_workshop")
                .whereField("Period", isEqualTo: currentPeriod!)
                .getDocuments() { (querySnapshot, err) in
                    if let err = err {
                        self.protocolDelegate?.presentErrorAlert()
                        print("Error getting documents: \(err)")
                        return
                    } else {
                        self.availableWorkshops = []
                        for document in querySnapshot!.documents {
                            //print("\(document.documentID) => \(document.data())")
                            let aWId = document.data()["Id"]! as! String
                            let aWWId = document.data()["Workshop_id"]! as! String
                            let aWCampus = document.data()["Campus_id"]! as! String
                            let aWStartTime = (document.data()["Start_time"] as! Timestamp).dateValue()
                            let aWEndTime = (document.data()["End_time"] as! Timestamp).dateValue()
                            let aWPeriod = document.data()["Period"]! as! String
                            let newAvailableWorkshop = AvailableWorkshop(id: aWId, workshop_id: aWWId, campus_id: aWCampus, start_time: aWStartTime, end_time: aWEndTime, period: aWPeriod)
                            self.availableWorkshops!.append(newAvailableWorkshop)
                            //print(self.availableWorkshops.count)
                        }
                        self.queryCompletion[7] = true
                        self.availableWorkshops!.sort(by: {$0.id < $1.id})
                        self.checkCompletion()

                    }
            }
            
            db.collection("Enrolled_workshop").getDocuments() { (querySnapshot, err) in
                    if let err = err {
                        self.protocolDelegate?.presentErrorAlert()
                        print("Error getting documents: \(err)")
                        return
                    } else {
                        self.enrolledWorkshops = []
                        for document in querySnapshot!.documents {
                            //print("\(document.documentID) => \(document.data())")
                            let eAWId = document.data()["AWorkshop_id"]! as! String
                            let registerId = document.data()["Register_id"]! as! String
                            let sId = document.data()["Student_id"]! as! String
                            let st = document.data()["Status"] as! Bool
                            let gr = document.data()["Grade"] as! Int
                            let newEnrolledWorkshop = EnrolledWorkshop(aWorkshop_id: eAWId, register_id: registerId, student_id: sId, status: st, grade: gr)
                            self.enrolledWorkshops!.append(newEnrolledWorkshop)
                            //print(self.enrolledWorkshops!.count)
                        }
                        self.queryCompletion[8] = true
                        self.enrolledWorkshops!.sort(by: {$0.register_id < $1.register_id})
                        self.checkCompletion()

                    }
            }
        }
    }
}

