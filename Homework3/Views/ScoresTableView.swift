import UIKit
import SnapKit

class ScoresTableView: UITableView {
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        setupTableView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupTableView()
    }
    
    private func setupTableView() {
        register(UITableViewCell.self, forCellReuseIdentifier: "ScoreCell")
        backgroundColor = .lightGray
        isScrollEnabled = false
    }
}
