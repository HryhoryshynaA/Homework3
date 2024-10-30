import UIKit
import Combine

enum ScoresTableControllerOutputMessage {
    case subjectSelected(String)
}

class ScoresTableViewController: NSObject, UITableViewDataSource, UITableViewDelegate {
    private var scores: [(subject: String, grade: Int)] = []
    
    private let _outputPublisher = PassthroughSubject<ScoresTableControllerOutputMessage, Never>()
    var outputPublisher: AnyPublisher<ScoresTableControllerOutputMessage, Never> {
        _outputPublisher.eraseToAnyPublisher()
    }

    init(scores: [(subject: String, grade: Int)]) {
        self.scores = scores
    }
    
    func updateScores(_ newScores: [(subject: String, grade: Int)]) {
        self.scores = newScores
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return scores.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ScoreCell", for: indexPath)
        let score = scores[indexPath.row]
        cell.selectionStyle = .none
        cell.textLabel?.text = "\(score.subject): \(score.grade)"
        cell.backgroundColor = .lightGray
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedSubject = scores[indexPath.row].subject
        _outputPublisher.send(.subjectSelected(selectedSubject))
    }
}
