import UIKit

class EnrolledWorkshop: NSObject, Codable{
    var available_id : String
    var register_id : String
    var student_id : String
    var status : Bool
    var grade : Int
    
    init(available_id : String, register_id : String, student_id : String, status : Bool, grade : Int) {
        self.available_id = available_id
        self.register_id = register_id
        self.student_id = student_id
        self.status = status
        self.grade = grade
    }

}
