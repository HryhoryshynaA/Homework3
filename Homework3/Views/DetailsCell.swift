import UIKit
import SnapKit
import Combine

class DetailsCell: UIStackView {
    
    private let profileImages = ["profile1", "profile2", "profile3", "profile4", "profile5",
                                 "profile6", "profile7", "profile8", "profile9", "profile10"]
    
    private let shadowView: UIView = {
        let view = UIView()
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.4
        view.layer.shadowOffset = CGSize(width: 0, height: 7)
        view.layer.shadowRadius = 5
        view.clipsToBounds = false
        return view
    }()
    
    private let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 20
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 32, weight: .heavy)
        return label
    }()
    
    private let ageLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20)
        return label
    }()
    
    private let addressLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20)
        return label
    }()
    
    private let scholarshipStatusView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 16
        view.clipsToBounds = true
        return view
    }()
    
    private let scoresTableView = ScoresTableView()
    private var scoresTableController: ScoresTableViewController?
    
    var subjectSelectedPublisher: AnyPublisher<String, Never>? {
        scoresTableController?.outputPublisher
            .compactMap { message in
                switch message {
                case .subjectSelected(let subject):
                    return subject
                }
            }
            .eraseToAnyPublisher()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupLayout()
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
        setupLayout()
    }
    
    private func setupView() {
        axis = .vertical
        spacing = 8
        alignment = .fill
        distribution = .fillProportionally

        addSubview(shadowView)
        shadowView.addSubview(profileImageView)
        shadowView.addSubview(scholarshipStatusView)
        
        addSubview(nameLabel)
        addSubview(ageLabel)
        addSubview(addressLabel)
        addSubview(scoresTableView)
    }
    
    private func setupLayout() {
        
        shadowView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().offset(20)
        }
        
        profileImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.width.height.equalTo(350)
        }

        scholarshipStatusView.snp.makeConstraints {
            $0.bottom.trailing.equalTo(profileImageView).inset(8)
            $0.width.height.equalTo(32)
        }
        
        nameLabel.snp.makeConstraints {
            $0.top.equalTo(shadowView.snp.bottom).offset(10)
            $0.leading.equalTo(shadowView)
        }

        scholarshipStatusView.snp.makeConstraints {
            $0.bottom.trailing.equalTo(profileImageView).inset(8)
            $0.width.height.equalTo(32)
        }
        
        ageLabel.snp.makeConstraints {
            $0.top.equalTo(nameLabel.snp.bottom).offset(4)
            $0.leading.equalTo(nameLabel)
        }
        
        addressLabel.snp.makeConstraints {
            $0.top.equalTo(ageLabel.snp.bottom).offset(4)
            $0.leading.equalTo(nameLabel)
        }
        
        scoresTableView.snp.makeConstraints {
            $0.top.equalTo(addressLabel.snp.bottom).offset(10)
            $0.leading.trailing.equalToSuperview().inset(0)
            $0.height.equalTo(100)
        }
    }
    
    func setupCell(with student: Student) {
        if student.id <= profileImages.count {
            profileImageView.image = UIImage(named: profileImages[student.id - 1])
        } else {
            profileImageView.image = UIImage(named: "defaultProfile")
        }
        
        nameLabel.text = student.name
        ageLabel.text = student.age != nil ? "Age: \(student.age!)" : "Age: N/A"
        addressLabel.text = "Address: " + (student.address.map { getAddress($0) } ?? "N/A")
        if let hasScholarship = student.hasScholarship {
            scholarshipStatusView.backgroundColor = hasScholarship ? .green : .red
        } else {
            scholarshipStatusView.backgroundColor = .black
        }
        let scores = student.scores?.compactMap { (subject, grade) -> (String, Int)? in
            guard let grade = grade else { return nil }
            return (subject, grade)
        } ?? []
        if scoresTableController == nil {
            scoresTableController = ScoresTableViewController(scores: scores)
            scoresTableView.dataSource = scoresTableController
            scoresTableView.delegate = scoresTableController
        } else {
            scoresTableController?.updateScores(scores)
        }
        
        let tableHeight = scores.count * 44
        scoresTableView.snp.updateConstraints {
            $0.height.equalTo(tableHeight)
        }
    }
    
    private func getAddress(_ address: Address) -> String {
        var addressComponents = [String]()
        
        if let street = address.street {
            addressComponents.append(street)
        }
        if let city = address.city {
            addressComponents.append(city)
        }
        if let postalCode = address.postalCode {
            addressComponents.append(postalCode)
        }
        
        return addressComponents.isEmpty ? "N/A" : addressComponents.joined(separator: ", ")
    }

}

// #if DEBUG
// import SwiftUI
//
// struct DetailsCell_Previews: PreviewProvider {
//
//    static func makeDetailsCell() -> DetailsCell {
//        let cell = DetailsCell()
//        
//        let student = Student(
//            id: 1,
//            name: "Adriana",
//            age: 18,
//            subjects: ["English", "Apple Development", "Network Concepts"],
//            address: Address(street: "Mykoly Shpaka", city: "Kyiv", postalCode: "20000"),
//            scores: ["English": 100, "Apple Development": 95, "Network Concepts": 100, "Math": 100]
//            hasScholarship: true,
//            graduationYear: 2027
//        )
//        
//        cell.setupCell(with: student)
//        return cell
//    }
//
//    static var previews: some View {
//        UIViewControllerPreview {
//            let controller = UIViewController()
//            let detailsCell = makeDetailsCell()
//            
//            controller.view.addSubview(detailsCell)
//            detailsCell.snp.makeConstraints { make in
//                make.edges.equalTo(controller.view.safeAreaLayoutGuide)
//            }
//            return controller
//        }
//        .frame(width: 375, height: 600)
//    }
// }
//
// struct UIViewControllerPreview<ViewController: UIViewController>: UIViewControllerRepresentable {
//    let viewController: ViewController
//
//    init(_ builder: @escaping () -> ViewController) {
//        viewController = builder()
//    }
//
//    func makeUIViewController(context: Context) -> ViewController {
//        viewController
//    }
//
//    func updateUIViewController(_ uiViewController: ViewController, context: Context) {}
// }
//
// #endif
