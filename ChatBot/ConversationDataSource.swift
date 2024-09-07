import Foundation

class ConversationDataSource {
    private var messages: [Message] = [openingLine]
    
    var messageCount: Int {
        return messages.count
    }
    
    func add(question: String) {
        let message = Message(date: Date(), text: question, type: .question)
        messages.append(message)
        print("Added question: \(question)")
    }
    
    func add(answer: String) {
        let message = Message(date: Date(), text: answer, type: .answer)
        messages.append(message)
        print("Added answer: \(answer)")
    }
    
    func messageAt(index: Int) -> Message {
        return messages[index]
    }
}
