import UIKit
import Combine

enum StudentListControllerOutputMessage {
    case studentSelected(Student)
}

final class StudentListController: UIViewController {
    
    private var nextStudentID: Int = 11
    private let _outputPublisher = PassthroughSubject<StudentListControllerOutputMessage, Never>()
    
    var outputPublisher: AnyPublisher<StudentListControllerOutputMessage, Never> {
        _outputPublisher.eraseToAnyPublisher()
    }

    private var students: [Student] = []
    
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
    
    private func loadStudents() {
        let path = "/Users/adrianahryhoryshyna/Desktop/XCode projects/Homework3/Homework3/students.json"
        students = StudentParcer.shared.parseStudents(from: path)
        tableView.reloadData()
        }
    
    override func viewDidLoad() {
            super.viewDidLoad()
            setupView()
            loadStudents()
        }
        
    private func setupView() {
        let headerLabel = UILabel()
        headerLabel.text = "Students"
        headerLabel.font = .systemFont(ofSize: 24, weight: .bold)
        headerLabel.textAlignment = .center
        headerLabel.backgroundColor = .white
        headerLabel.frame = CGRect(x: 0, y: 0, width: tableView.frame.width, height: 30)
        tableView.tableHeaderView = headerLabel
        
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)
        
        tableView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.bottom.equalToSuperview()
        }
        
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(didTapAddButton))
        // help of 2 tutorials from Youtube and some Indian dude
        navigationItem.rightBarButtonItem = addButton
    }
    // божепамажи
    @objc private func didTapAddButton() {
        presentStudentForm()
    }
    
    private func presentStudentForm(student: Student? = nil) {
       let alertController = UIAlertController(title: student == nil ? "Add Student" : "Edit Student",
                                               message: nil, preferredStyle: .alert)
       
       alertController.addTextField { textField in
           textField.placeholder = "Name"
           textField.text = student?.name
       }
       
       alertController.addTextField { textField in
           textField.placeholder = "Age"
           textField.keyboardType = .numberPad
           if let age = student?.age {
               textField.text = "\(age)"
           }
       }
       
       let saveAction = UIAlertAction(title: "Save", style: .default) { _ in
           guard let name = alertController.textFields?[0].text,
                 let ageText = alertController.textFields?[1].text,
                 let age = Int(ageText) else { return }
           
           if let student = student {
               self.editStudent(student, name: name, age: age)
           } else {
               self.addStudent(name: name, age: age)
           }
       }
       
       let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
       
       alertController.addAction(saveAction)
       alertController.addAction(cancelAction)
       
       present(alertController, animated: true)
    }

   private func addStudent(name: String, age: Int) {
       let newStudent = Student(id: nextStudentID, name: name, age: age, subjects: [],
                                address: nil, scores: nil, hasScholarship: nil, graduationYear: nil)
       nextStudentID += 1
       students.append(newStudent)
       tableView.reloadData()
   }

   private func editStudent(_ student: Student, name: String, age: Int) {
       if let index = students.firstIndex(where: { $0.id == student.id }) {
           students[index].name = name
           students[index].age = age
           tableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
       }
   }

}

extension StudentListController: UITableViewDelegate, UITableViewDataSource {
    
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let student = students[indexPath.row]
        _outputPublisher.send(.studentSelected(student))
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle,
                   forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            students.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }

}
