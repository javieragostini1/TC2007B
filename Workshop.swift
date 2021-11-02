import UIKit

class Workshop: NSObject, Codable{
    var id : String
    var name : String
    var description : String
    var image : String
    
    func getImage() -> UIImage{
      let img = UIImage(named: image)
      return img 
    }

    init(id: String, name: String, description: String, image : String) {
        self.id = id
        self.name = name
        self.description = description
        self.image = image
        
    }


}
