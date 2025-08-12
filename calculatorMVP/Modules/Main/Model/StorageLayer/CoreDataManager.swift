import CoreData

class CoreDataManager {
    static let shared = CoreDataManager()
    let container: NSPersistentContainer

    private init() {
        container = NSPersistentContainer(name: "calculatorMVP")
        container.loadPersistentStores { (_, error) in
            if let error = error {
                fatalError("Core Data error \(error)")
            }
        }
    }

    var context: NSManagedObjectContext { container.viewContext }
}
