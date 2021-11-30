import UIKit

class Student: NSObject, Codable{
    var id : String
    var name : String
    var last_name : String
    var campus_id : String
    var current_period : Int
    
    init(id: String, name: String, last_name: String, campus_id : String, current_period : Int) {
        self.id = id
        self.name = name
        self.last_name = last_name
        self.campus_id = campus_id
        self.current_period = current_period
        
    }

}
