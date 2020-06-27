import Foundation
import CoreData

@objc(Task)
public class Task: NSManagedObject {
    @nonobjc public class func fetchRequest(with categoryUuid: UUID) -> NSFetchRequest<Task> {
        let fetch = NSFetchRequest<Task>(entityName: "Task")
        fetch.predicate = NSPredicate(format: "category.uuid == %@", argumentArray: [categoryUuid])
        fetch.sortDescriptors = [NSSortDescriptor(key: "dateCreated", ascending: false)]
        
        return fetch
    }
}
