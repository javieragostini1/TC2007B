//
//  PreviousPeriod.swift
//  prototipoApp
//
//  Created by Alumno on 19/11/21.
//

import UIKit

class PreviousPeriod: NSObject, Codable {
    var name : String
    var id : String
    
    init(name : String, id: String){
        self.name = name
        self.id = id
    }
}
