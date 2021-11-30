import UIKit

class Workshop: NSObject, Codable{
    var id : String
    var name : String
    var desc : String
    var image : String
    var requierment : Int

    init(id: String, name: String, desc: String, image : String, requierment : Int) {
        self.id = id
        self.name = name
        self.desc = desc
        self.image = image
        self.requierment = requierment
    }


}
