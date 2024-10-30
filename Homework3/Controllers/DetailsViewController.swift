import UIKit
import Combine

final class DetailsViewController: UIViewController {
    
    private let detailsCell = DetailsCell()
    private var student: Student
    private var cancellables = Set<AnyCancellable>()
    let subjectPublisher = PassthroughSubject<String, Never>()

    init(student: Student) {
        self.student = student
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupView()
        detailsCell.setupCell(with: student)
        
        detailsCell.subjectSelectedPublisher?
            .sink { [weak self] subject in
                self?.subjectPublisher.send(subject)
            }
            .store(in: &cancellables)
    }

    private func setupView() {
        view.addSubview(detailsCell)
        detailsCell.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide).inset(16)
        }
    }
}
