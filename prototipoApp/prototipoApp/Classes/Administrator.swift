import UIKit

class Administrator: NSObject, Codable{
    var id : String
    var name : String
    var last_name : String
    
    init(id: String, name: String, last_name: String) {
        self.id = id
        self.name = name
        self.last_name = last_name
        
    }

}
