import UIKit

class ResultsSheet: UIViewController, UITableViewDataSource, UITableViewDelegate {
    private let tableView = UITableView()
    private var results: [CalcResult] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        loadResults()
    }

    func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.frame = view.bounds
        tableView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(tableView)
    }

    func loadResults() {
        results = MainPresenter().fetchResults()
        tableView.reloadData()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        results.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let result = results[indexPath.row]
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
        let expr = result.expression ?? ""
        let res = result.result ?? ""
        cell.textLabel?.text = "\(expr) = \(res)"
        if let date = result.createdAt {
            cell.detailTextLabel?.text = DateFormatter.localizedString(from: date, dateStyle: .short, timeStyle: .short)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath)
    -> UISwipeActionsConfiguration? {

        let deleteAction = UIContextualAction(style: .destructive, title: "Удалить") { [weak self] _, _, completion in
            guard let self = self else { return }
            let resultToDelete = self.results[indexPath.row]
            let context = CoreDataManager.shared.context
            context.delete(resultToDelete)
            try? context.save()
            self.results.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            completion(true)
        }
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
    
}
