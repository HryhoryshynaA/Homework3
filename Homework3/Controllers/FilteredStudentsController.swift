import UIKit
import Combine

final class FilteredStudentsController: UIViewController {
    
    private let students: [Student]
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(StudentCell.self, forCellReuseIdentifier: StudentCell.identifier)
        return tableView
    }()
    
    init(students: [Student]) {
        self.students = students
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
    }
    
    private func setupView() {
        view.backgroundColor = .white
        
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)
        
        tableView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.bottom.equalToSuperview()
        }
        
        let headerLabel = UILabel()
        headerLabel.font = .systemFont(ofSize: 32, weight: .bold)
        headerLabel.textAlignment = .center
        headerLabel.backgroundColor = .white
        headerLabel.frame = CGRect(x: 0, y: 0, width: tableView.frame.width, height: 30)
        tableView.tableHeaderView = headerLabel
    }
}

extension FilteredStudentsController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return students.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: StudentCell.identifier, for: indexPath)
                as? StudentCell else {
            return UITableViewCell()
        }
        cell.setupCell(with: students[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}
