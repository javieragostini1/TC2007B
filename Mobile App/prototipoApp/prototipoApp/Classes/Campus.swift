import UIKit

class Campus: NSObject, Codable{
    var id : String
    var name : String
    
    init(id: String, name: String) {
        self.id = id
        self.name = name
        
    }

}
