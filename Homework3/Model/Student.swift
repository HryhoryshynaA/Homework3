import Foundation
import UIKit

struct Students: Codable {
    let students: [Student]
}

struct Student: Codable {
    var id: Int
    var name: String
    var age: Int?
    var subjects: [String]?
    var address: Address?
    var scores: [String: Int?]?
    var hasScholarship: Bool?
    var graduationYear: Int?
}

struct Address: Codable {
    let street: String?
    let city: String?
    let postalCode: String?
}
struct Scores: Codable {
    let math: Int?
    let physics: Int?
    let chemistry: Int?
    let literature: Int?
    let history: Int?
    let philosophy: Int?
    let biology: Int?
    let computerScience: Int?

    enum CodingKeys: String, CodingKey {
        case math = "Math"
        case physics = "Physics"
        case chemistry = "Chemistry"
        case literature = "Literature"
        case history = "History"
        case philosophy = "Philosophy"
        case biology = "Biology"
        case computerScience = "Computer Science"
    }
}
