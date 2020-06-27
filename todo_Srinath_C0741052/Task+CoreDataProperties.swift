

import Foundation
import CoreData


extension Task {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Task> {
        return NSFetchRequest<Task>(entityName: "Task")
    }

    @NSManaged public var title: String?
    @NSManaged public var desc: String?
    @NSManaged public var dateCreated: Date?
    @NSManaged public var dueDate: Date?
    @NSManaged public var numberOfDays: Int64
    @NSManaged public var isExpired: Bool
    @NSManaged public var category: Category?

}
