import UIKit

class ConversationViewController: UITableViewController {

    var questionAnswerer = ConversationDelegate()
    let conversationSource = ConversationDataSource()

    private let thinkingTime: TimeInterval = 2
    fileprivate var isThinking = false
    
    fileprivate func respondToQuestion(_ questionText: String) {
        isThinking = true
        let countBefore = conversationSource.messageCount
        conversationSource.add(question: questionText)
        let count = conversationSource.messageCount
        var questionPath: IndexPath?
        if count != countBefore {
            questionPath = IndexPath(row: count - 1, section: ConversationSection.history.rawValue)
        }
        tableView.insertRows(at: [questionPath, ConversationSection.thinkingPath].compactMap { $0 }, with: .bottom)
        tableView.scrollToRow(at: ConversationSection.askPath, at: .bottom, animated: true)
        DispatchQueue.main.asyncAfter(deadline: .now() + thinkingTime) {
            self.isThinking = false
            let answer = self.questionAnswerer.responseTo(question: questionText)
            let countBefore = self.conversationSource.messageCount
            self.conversationSource.add(answer: answer)
            let count = self.conversationSource.messageCount
            self.tableView.beginUpdates()
            if count != countBefore {
                self.tableView.insertRows(at: [IndexPath(row:count - 1, section: ConversationSection.history.rawValue)], with: .fade)
            }
            self.tableView.deleteRows(at: [ConversationSection.thinkingPath], with: .fade)
            self.tableView.endUpdates()
            self.tableView.scrollToRow(at: ConversationSection.askPath, at: .bottom, animated: true)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        edgesForExtendedLayout = [.top]
    }
}

extension ConversationViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let text = textField.text, !text.isEmpty else {
            return false
        }
        
        if isThinking {
            return false
        }
        
        textField.text = nil
        respondToQuestion(text)
        return false
    }
}

extension ConversationViewController {
    fileprivate enum ConversationSection: Int {
        case history = 0
        case thinking = 1
        case ask = 2
        
        static var sectionCount: Int {
            return self.ask.rawValue + 1
        }
        
        static var allSections: IndexSet {
            return IndexSet(integersIn: 0..<sectionCount)
        }
        
        static var askPath: IndexPath {
            return IndexPath(row: 0, section: self.ask.rawValue)
        }
        
        static var thinkingPath: IndexPath {
            return IndexPath(row: 0, section: self.thinking.rawValue)
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return ConversationSection.sectionCount
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch ConversationSection(rawValue: section)! {
        case .history:
            return conversationSource.messageCount
        case .thinking:
            return isThinking ? 1 : 0
        case .ask:
            return 1
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch ConversationSection(rawValue: indexPath.section)! {
        case .history:
            let message = conversationSource.messageAt(index: indexPath.row)
            let identifier = message.type == .question ? "Question" : "Answer"
            let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! ConversationCell
            cell.configureWithMessage(message)
            return cell
        case .thinking:
            let cell = tableView.dequeueReusableCell(withIdentifier: "Thinking", for: indexPath) as! ThinkingCell
            cell.thinkingImage.startAnimating()
            return cell
        case .ask:
            let cell = tableView.dequeueReusableCell(withIdentifier: "Ask", for: indexPath) as! AskCell
            if cell.textField.delegate == nil {
                cell.textField.becomeFirstResponder()
                cell.textField.delegate = self
            }
            return cell
        }
    }
}

extension ConversationViewController {
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50.0
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
