import UIKit

final class Helpers {
    static let shared = Helpers()
    private init() { }
    
    func createCalcBtn(title: String, bgCol: UIColor, action: @escaping () -> Void) -> UIButton {
        let btn = UIButton(type: .system)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.layer.cornerRadius = 10
        btn.backgroundColor = bgCol
        btn.setTitle(title, for: .normal)
        btn.setTitleColor(.black, for: .normal)
        btn.addAction(UIAction { _ in
            action()
        }, for: .touchUpInside)
        
        return btn
    }
    
    
}
