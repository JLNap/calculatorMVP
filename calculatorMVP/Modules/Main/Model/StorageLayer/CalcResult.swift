import Foundation
import CoreData

@objc(CalcResult)
public class CalcResult: NSManagedObject {
    @NSManaged public var expression: String?
    @NSManaged public var result: String?
    @NSManaged public var createdAt: Date?
}

extension CalcResult {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<CalcResult> {
        return NSFetchRequest<CalcResult>(entityName: "CalcResult")
    }
}

extension CalcResult: Identifiable {}
