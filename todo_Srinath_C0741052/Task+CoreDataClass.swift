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
    
    @nonobjc public class func fetchRequest(with searchText: String, categoryUuid: UUID) -> NSFetchRequest<Task> {
        let fetch = NSFetchRequest<Task>(entityName: "Task")
        fetch.predicate = NSPredicate(format: "(title contains[c] %@ OR desc contains[c] %@) AND category.uuid == %@", argumentArray: [searchText, searchText, categoryUuid])
        fetch.sortDescriptors = [NSSortDescriptor(key: "dateCreated", ascending: false)]
        
        return fetch
    }
}
