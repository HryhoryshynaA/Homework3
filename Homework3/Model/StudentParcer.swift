import Foundation

final class StudentParcer {
    
    static let shared = StudentParcer()
    private init() { }
    
    func parseStudents(from jsonFileName: String) -> [Student] {
        let url = URL(fileURLWithPath: jsonFileName)
        
        do {
            let data = try Data(contentsOf: url)
            let studentsList = try JSONDecoder().decode(Students.self, from: data)
            return studentsList.students
        } catch {
            print("Failed to parse JSON with error: \(error)")
            return []
        }
    }
    
    func getStudents(withSubject subject: String) -> [Student] {
        let path = "/Users/adrianahryhoryshyna/Desktop/XCode projects/Homework3/Homework3/students.json"
        let allStudents = parseStudents(from: path)
        let filteredStudents = allStudents.filter { student in
            guard let subjects = student.subjects else { return false }
            return subjects.contains(subject)
        }
        return filteredStudents
    }
}
