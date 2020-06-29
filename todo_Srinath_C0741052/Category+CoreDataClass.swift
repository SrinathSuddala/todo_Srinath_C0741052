import Foundation
import CoreData

@objc(Category)
public class Category: NSManagedObject {
    
    @nonobjc public class func fetchRequest(with title: String) -> NSFetchRequest<Category> {
        let fetch = NSFetchRequest<Category>(entityName: "Category")
        fetch.predicate = NSPredicate(format: "title == %@", argumentArray: [title])
        
        return fetch
    }

}
