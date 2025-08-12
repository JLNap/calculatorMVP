import UIKit

class ViewCreator {
    static func createFoldersView() -> UIViewController {
        let view = MainVC()
        let presenter = MainPresenter()
        view.presenter = presenter
        return view
    }
}
