import UIKit

class AvailableWorkshop: NSObject, Codable{
    var id : String
    var workshop_id : String
    var campus_id : Int
    var start_time : Date
    var end_time : Date
    
    init(id: String, workshop_id: String, campus_id : Int,start_time: Date, end_time : Date) {
        self.id = id
        self.workshop_id = workshop_id
        self.campus_id = campus_id
        self.start_time = start_time
        self.end_time = end_time
        
    }

}

// Campus_id
// 1
// (número)
// End_time
// 5 de noviembre de 2021, 11:00:00 UTC-6
// Start_time
// 1 de noviembre de 2021, 07:00:00 UTC-6
// Workshop_id
// "A"
// id
// "A0001"
