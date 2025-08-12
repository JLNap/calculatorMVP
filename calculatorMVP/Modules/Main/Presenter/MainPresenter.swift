import UIKit
import CoreData

protocol MainPresenterProtocol {
    var calculatorLabel: String { get }
    func addNumber(_ number: String)
    func delLast()
    func addOp(op: String)
    func result()
    func reset()
}

class MainPresenter: MainPresenterProtocol {
    var calculatorLabel: String = ""
    
    func addNumber(_ number: String) {
        calculatorLabel += number
    }
    
    func delLast() {
        if !calculatorLabel.isEmpty {
            calculatorLabel.removeLast()
            if calculatorLabel.isEmpty {
                calculatorLabel = ""
            }
        }
    }
    
    func addOp(op: String) {
        calculatorLabel += op
    }
    
    func calculateExpression(_ expression: String) -> String {
        let expr = NSExpression(format: expression)
        if let result = expr.expressionValue(with: nil, context: nil) as? NSNumber {
            return String(describing: result)
        }
        return "Ошибка"
    }
    
    func result() {
        let res = calculateExpression(calculatorLabel)
        saveCalcResult(expression: calculatorLabel, result: res)
        calculatorLabel = res
    }
    
    func reset() {
        calculatorLabel = ""
    }
    
    func saveCalcResult(expression: String, result: String) {
        let context = CoreDataManager.shared.context
        let newEntry = CalcResult(context: context)
        newEntry.expression = expression
        newEntry.result = result
        newEntry.createdAt = Date()
        try? context.save()
    }
    
    func fetchResults() -> [CalcResult] {
        let context = CoreDataManager.shared.context
        let request: NSFetchRequest<CalcResult> = CalcResult.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "createdAt", ascending: false)]
        return (try? context.fetch(request)) ?? []
    }
    
}
