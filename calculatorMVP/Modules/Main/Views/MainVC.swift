import UIKit

class MainVC: UIViewController {
    var presenter: MainPresenterProtocol = MainPresenter()
    let helper = Helpers.shared

    lazy var calcLabel: UILabel = {
        let label = UILabel()
        label.text = presenter.calculatorLabel
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = .white
        label.layer.cornerRadius = 10
        label.layer.masksToBounds = true
        label.font = UIFont.systemFont(ofSize: 28, weight: .medium)
        label.textAlignment = .right
        return label
    }()

    lazy var numBtns: [UIButton] = {
        (0...9).map { num in
            helper.createCalcBtn(
                title: "\(num)",
                bgCol: .lightGray,
                action: { [weak self] in
                    self?.presenter.addNumber("\(num)")
                    self?.calcLabel.text = self?.presenter.calculatorLabel
                }
            )
        }
    }()

    let digitsLayout: [[Int?]] = [
        [7, 8, 9],
        [4, 5, 6],
        [1, 2, 3],
        [0]
    ]
    
    let sideBtnsLayout: [[Int]] = [
        [0, 1],
        [2, 3],
        [4, 5],
        [6]
    ]

    var sideBtns: [UIButton] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.systemBlue.withAlphaComponent(0.5)
        view.addSubview(calcLabel)
        
        NSLayoutConstraint.activate([
            calcLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            calcLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            calcLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            calcLabel.heightAnchor.constraint(equalToConstant: 50),
        ])

        let buttonSize: CGFloat = 60
        let spacing: CGFloat = 16

        let sideBtnConfigs: [(String, UIColor, () -> Void)] = [
            ("C", .systemRed, { [weak self] in
                self?.presenter.reset()
                self?.calcLabel.text = self?.presenter.calculatorLabel
            }),
            ("←", .orange, { [weak self] in
                self?.presenter.delLast()
                self?.calcLabel.text = self?.presenter.calculatorLabel
            }),
            ("÷", .orange, { [weak self] in
                self?.presenter.addOp(op: "/")
                self?.calcLabel.text = self?.presenter.calculatorLabel
            }),
            ("×", .orange, { [weak self] in
                self?.presenter.addOp(op: "*")
                self?.calcLabel.text = self?.presenter.calculatorLabel
            }),
            ("−", .orange, { [weak self] in
                self?.presenter.addOp(op: "-")
                self?.calcLabel.text = self?.presenter.calculatorLabel
            }),
            ("+", .orange, { [weak self] in
                self?.presenter.addOp(op: "+")
                self?.calcLabel.text = self?.presenter.calculatorLabel
            }),
            ("=", .systemGreen, { [weak self] in
                self?.presenter.result()
                self?.calcLabel.text = self?.presenter.calculatorLabel
            })
        ]
        
        for cfg in sideBtnConfigs {
            let btn = helper.createCalcBtn(title: cfg.0, bgCol: cfg.1, action: cfg.2)
            sideBtns.append(btn)
            view.addSubview(btn)
            btn.translatesAutoresizingMaskIntoConstraints = false
        }

        for (rowIdx, row) in sideBtnsLayout.enumerated() {
            for (colIdx, btnIdx) in row.enumerated() {
                let btn = sideBtns[btnIdx]

                if row.count == 1 {
                    NSLayoutConstraint.activate([
                        btn.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
                        btn.topAnchor.constraint(equalTo: calcLabel.bottomAnchor, constant: CGFloat(rowIdx) * (buttonSize + spacing) + 32),
                        btn.widthAnchor.constraint(equalToConstant: CGFloat(buttonSize * 2 + spacing)),
                        btn.heightAnchor.constraint(equalToConstant: buttonSize)
                    ])
                } else {
                    NSLayoutConstraint.activate([
                        btn.widthAnchor.constraint(equalToConstant: buttonSize),
                        btn.heightAnchor.constraint(equalToConstant: buttonSize),
                        btn.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16 - CGFloat(1 - colIdx) * (buttonSize + spacing)),
                        btn.topAnchor.constraint(equalTo: calcLabel.bottomAnchor, constant: CGFloat(rowIdx) * (buttonSize + spacing) + 32)
                    ])
                }
            }
        }

        for (rowIdx, row) in digitsLayout.enumerated() {
            for (colIdx, numOpt) in row.enumerated() {
                guard let num = numOpt else { continue }
                let btn = numBtns[num]
                view.addSubview(btn)
                btn.translatesAutoresizingMaskIntoConstraints = false
                if row.count == 1 {
                    NSLayoutConstraint.activate([
                        btn.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
                        btn.topAnchor.constraint(equalTo: calcLabel.bottomAnchor, constant: CGFloat(rowIdx) * (buttonSize + spacing) + 32),
                        btn.heightAnchor.constraint(equalToConstant: buttonSize),
                        btn.widthAnchor.constraint(equalToConstant: CGFloat(buttonSize + spacing) * 3 - 16)
                    ])
                } else {
                    NSLayoutConstraint.activate([
                        btn.widthAnchor.constraint(equalToConstant: buttonSize),
                        btn.heightAnchor.constraint(equalToConstant: buttonSize),
                        btn.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: CGFloat(colIdx) * (buttonSize + spacing) + 16),
                        btn.topAnchor.constraint(equalTo: calcLabel.bottomAnchor, constant: CGFloat(rowIdx) * (buttonSize + spacing) + 32)
                    ])
                }
            }
        }
        let historyButton = UIButton(type: .system)
            historyButton.backgroundColor = .white
            historyButton.layer.cornerRadius = 10
            historyButton.setTitleColor(.black, for: .normal)
            historyButton.translatesAutoresizingMaskIntoConstraints = false
            historyButton.setTitle("История", for: .normal)
            historyButton.addTarget(self, action: #selector(showHistory), for: .touchUpInside)
            view.addSubview(historyButton)
        
        NSLayoutConstraint.activate([
            historyButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            historyButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            historyButton.heightAnchor.constraint(equalToConstant: 50),
            historyButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -80)
        ])
    }
    
    @objc func showHistory() {
        let sheetVC = ResultsSheet()
        if let sheet = sheetVC.sheetPresentationController {
            sheet.detents = [.medium(), .large()]
            sheet.preferredCornerRadius = 16
        }
        present(sheetVC, animated: true)
    }
}
