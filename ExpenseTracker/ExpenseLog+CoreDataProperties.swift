import Foundation
import CoreData


extension ExpenseLog : Identifiable {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ExpenseLog> {
        return NSFetchRequest<ExpenseLog>(entityName: "ExpenseLog")
    }
    
    static func fetchAllCategoriesTotalAmountSum(context: NSManagedObjectContext, completion: @escaping ([(sum: Double, category: Category)]) -> ()) {
            let keypathAmount = NSExpression(forKeyPath: \ExpenseLog.total)
            let expression = NSExpression(forFunction: "sum:", arguments: [keypathAmount])
            
            let sumDesc = NSExpressionDescription()
            sumDesc.expression = expression
            sumDesc.name = "sum"
            sumDesc.expressionResultType = .decimalAttributeType
            
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: ExpenseLog.entity().name ?? "ExpenseLog")
            request.returnsObjectsAsFaults = false
            request.propertiesToGroupBy = ["category"]
            request.propertiesToFetch = [sumDesc, "category"]
            request.resultType = .dictionaryResultType
            
            context.perform {
                do {
                    let results = try request.execute()
                    let data = results.map { (result) -> (Double, Category)? in
                        guard
                            let resultDict = result as? [String: Any],
                            let amount = resultDict["sum"] as? Double, amount > 0,
                            let categoryKey = resultDict["category"] as? String,
                            let category = Category(rawValue: categoryKey) else {
                                return nil
                        }
                        return (amount, category)
                    }.compactMap { $0 }
                    completion(data)
                } catch let error as NSError {
                    print((error.localizedDescription))
                    completion([])
                }
            }
            
        }
    
    static func predicate(with categories: [Filters]) -> NSPredicate? {
        var predicates = [NSPredicate]()
        if !categories.isEmpty {
            let today = Date()
            let categoriesString = categories.map { $0.rawValue }
            if categoriesString[0] == "Last Week" {
                let lastWeek = today.datesOfWeek(weekOffset: -1)
                predicates.append(NSPredicate(format: "date >= %@ && date <= %@", lastWeek[0] as CVarArg, lastWeek[lastWeek.endIndex-1] as CVarArg))
            } else {
                predicates.append(NSPredicate(format: "date >= %@ && date <= %@", today.startOfPrevMonth() as CVarArg, today.endOfPrevMonth() as CVarArg))
            }
        }
        if predicates.isEmpty {
            return nil
        } else {
            return NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
        }
        }

    @NSManaged public var title: String
    
    @NSManaged public var category: String
    
    var expenseCategory: Category {
            set {
                category = newValue.rawValue
            }
            get {
                Category(rawValue: category) ?? .other
            }
        }
    
    var dateText: String {
        Utility.dateFormatter.string(from: date)
    }
    
    @NSManaged public var date: Date
    
    @NSManaged public var total: Float
    
    @NSManaged public var id: UUID?

}
