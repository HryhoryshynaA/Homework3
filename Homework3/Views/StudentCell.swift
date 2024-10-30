import Foundation
import UIKit
import SnapKit

class StudentCell: UITableViewCell {
    
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
    
    private let studentsLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.text = "Students"
        label.textAlignment = .center
        return label
    }()
    
    private let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 30
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .heavy)
        return label
    }()
    
    private let ageLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        return label
    }()
    
    private let averageScoreLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        return label
    }()
    
    private let scholarshipStatusView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 7
        view.clipsToBounds = true
        return view
    }()
    
    private let scholarshipLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        return label
    }()
    
    public static let identifier = "student"
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupView()
        setupLayout()
    }
    
    init() {
        super.init(style: .default, reuseIdentifier: StudentCell.identifier)

        setupView()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        nameLabel.text = nil
        ageLabel.text = nil
        averageScoreLabel.text = nil
    }
    
    private func setupLayout() {
        shadowView.snp.makeConstraints {
            $0.top.leading.equalToSuperview().inset(10)
            $0.width.height.equalTo(60)
        }

        profileImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        nameLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(10)
            $0.leading.equalTo(shadowView.snp.trailing).offset(10)
            $0.trailing.equalToSuperview().inset(10)
        }
        
        ageLabel.snp.makeConstraints {
            $0.top.equalTo(nameLabel.snp.bottom).offset(6)
            $0.leading.equalTo(nameLabel)
        }
        
        averageScoreLabel.snp.makeConstraints {
            $0.leading.equalTo(ageLabel.snp.trailing).offset(12)
            $0.bottom.equalTo(ageLabel)
        }
        
        scholarshipLabel.snp.makeConstraints {
            $0.top.equalTo(averageScoreLabel.snp.bottom).offset(6)
            $0.leading.equalTo(nameLabel)
            $0.centerY.equalTo(scholarshipStatusView)
        }

        scholarshipStatusView.snp.makeConstraints {
            $0.leading.equalTo(scholarshipLabel.snp.trailing).offset(6)
            $0.centerY.equalTo(scholarshipLabel)
            $0.width.equalTo(14)
            $0.height.equalTo(14)
        }

    }

    private func setupView() {
        addSubview(shadowView)
        shadowView.addSubview(profileImageView)
        addSubview(nameLabel)
        addSubview(ageLabel)
        addSubview(averageScoreLabel)
        addSubview(scholarshipLabel)
        addSubview(scholarshipStatusView)
    }
    
    func setupCell(with student: Student) {
        if student.id <= profileImages.count {
            let randomImageName = profileImages[student.id - 1]
            profileImageView.image = UIImage(named: randomImageName)
        } else {
            profileImageView.image = UIImage(named: "defaultProfile")
        }
        nameLabel.text = student.name
        ageLabel.text = student.age != nil ? "Age: \(student.age!)" : "Age: N/A"
        if let scores = student.scores, !scores.isEmpty {
            averageScoreLabel.text = "Score: \(calculateAverageScore(scores))"
        } else {
            averageScoreLabel.text = "Score: N/A"
        }
        scholarshipLabel.text = "Scholarship"
        if let hasScholarship = student.hasScholarship {
            scholarshipStatusView.backgroundColor = hasScholarship ? .green : .red
        } else {
            scholarshipStatusView.backgroundColor = .black
        }
    }

    private func calculateAverageScore(_ scores: [String: Int?]?) -> Int {
        guard let scores = scores else { return 0 }
        let validScores = scores.values.compactMap { $0 }
        let total = validScores.reduce(0, +)
        let count = validScores.count
        return count > 0 ? total / count : 0
    }

}

// #if DEBUG
//
// import SwiftUI
//
// struct StudentCell_Previews: PreviewProvider {
//
//    static func makeCell() -> StudentCell {
//        let cell = StudentCell()
//        
//        cell.setupCell(with: .init(id: 1, name: "Adriana", age: 18, subjects:
//           ["English", "Apple Development"], address: (Address.init(street: "Mekoly Shpaka",
//           city: "Kyiv", postalCode: "20000")), scores: ["English": 100, "Apple Development": 95],
//           hasScholarship: true, graduationYear: 2027))
//
//        return cell
//    }
//    
//    static var previews: some View {
//        Group {
//            makeCell()
//                .asPreview()
//                .frame(height: 150)
//        }
//    }
// }
//
// extension UIViewController {
//    @available(iOS 13, *)
//    private struct Preview: UIViewControllerRepresentable {
//        var viewController: UIViewController
//
//        func makeUIViewController(context: Context) -> UIViewController {
//            viewController
//        }
//
//        func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
//            // No-op
//        }
//    }
//
//    @available(iOS 13, *)
//    func asPreview() -> some View {
//        Preview(viewController: self)
//    }
// }
//
//
// extension UIView {
//    @available(iOS 13, *)
//    private struct Preview: UIViewRepresentable {
//        var view: UIView
//
//        func makeUIView(context: Context) -> UIView {
//            view
//        }
//
//        func updateUIView(_ view: UIView, context: Context) {
//            // No-op
//        }
//    }
//
//    @available(iOS 13, *)
//    func asPreview() -> some View {
//        Preview(view: self)
//    }
// }
//
//
// #endif
