import Foundation
import UIKit
import Combine

final class Coordinator {
    
    let rootViewController: UINavigationController
    
    private var cancellable: Set<AnyCancellable> = []
    
    init(rootViewController: UINavigationController) {
        self.rootViewController = rootViewController
    }
    
    func start() {
        let path = "/Users/adrianahryhoryshyna/Desktop/XCode projects/Homework3/Homework3/students.json"
        let mainViewController = StudentListController(students: StudentParcer.shared.parseStudents(from: path))
        
        mainViewController.outputPublisher
                .sink { [weak self] message in
                    switch message {
                    case .studentSelected(let student):
                        self?.showDetailsViewController(with: student)
                    }
                }
                .store(in: &cancellable)
            
            rootViewController.pushViewController(mainViewController, animated: true)
        }
    
    func showDetailsViewController(with student: Student) {
        let detailsViewController = DetailsViewController(student: student)
        
        detailsViewController.subjectPublisher
            .sink { [weak self] subject in
                self?.showStudentsWithSubject(subject)
            }
            .store(in: &cancellable)
        
        rootViewController.pushViewController(detailsViewController, animated: true)
    }
    
    func showStudentsWithSubject(_ subject: String) {
        let studentsWithSubject = StudentParcer.shared.getStudents(withSubject: subject)
        let filteredStudentListController = FilteredStudentsController(students: studentsWithSubject)
        // spend 3 hours, and only then relized that my logic in StudentList Controller
        // isn't really suitable to be resued
        filteredStudentListController.title = subject
        rootViewController.pushViewController(filteredStudentListController, animated: true)
    }
}
