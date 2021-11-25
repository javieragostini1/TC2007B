import UIKit

class Coordinator: NSObject, Codable{
    var id : String
    var name : String
    var last_name : String
    var campus_id : Int
    
    init(id: String, name: String, last_name: String, campus_id : Int) {
        self.id = id
        self.name = name
        self.last_name = last_name
        self.campus_id = campus_id
        
    }

}

// Campus_id
// 1
// Id
// "L02345678"
// Last_name
// "Vecchi"
// Name
// "Facundo"
