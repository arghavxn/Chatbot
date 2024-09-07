import Foundation

struct ConversationDelegate {
    private var context: [String: Any] = [:]
    private var questionCount = 0
    private let dateFormatter: DateFormatter
    private let timeFormatter: DateFormatter
    
    init() {
        dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        dateFormatter.timeStyle = .none
        
        timeFormatter = DateFormatter()
        timeFormatter.dateStyle = .none
        timeFormatter.timeStyle = .short
    }
    
    mutating func responseTo(question: String) -> String {
           let lowerQuestion = question.lowercased()
           questionCount += 1
        
        // Date and Time
        if lowerQuestion.contains("what day is it") || lowerQuestion.contains("what's the date") {
            return "Today is \(dateFormatter.string(from: Date())). How can I assist you today?"
        }
        if lowerQuestion.contains("what time is it") {
            return "The current time is \(timeFormatter.string(from: Date())). Is there anything specific you'd like to know or discuss?"
        }
        
        // Greeting with time awareness
        if lowerQuestion.contains("hello") || lowerQuestion.contains("hi") {
            let hour = Calendar.current.component(.hour, from: Date())
            var greeting: String
            switch hour {
            case 5..<12: greeting = "Good morning"
            case 12..<17: greeting = "Good afternoon"
            case 17..<22: greeting = "Good evening"
            default: greeting = "Hello"
            }
            return questionCount == 1 ? "\(greeting)! I'm excited to chat with you. What would you like to talk about?" : "\(greeting) again! Always nice to greet you. What's on your mind?"
        }
        
        // Personal questions
        if lowerQuestion.contains("your name") {
            return "I'm ChatBot, your friendly AI conversation partner. It's a pleasure to meet you on this fine \(dateFormatter.string(from: Date()))!"
        }
        if lowerQuestion.contains("how are you") {
            return "As an AI, I don't have feelings, but I'm functioning well and always eager to learn. It's a beautiful \(getDayPeriod()) here in the digital world. How are you doing? Is there something specific you'd like to discuss?"
        }
        
        // Capabilities
        if lowerQuestion.contains("what can you do") || lowerQuestion.contains("your capabilities") {
            return "I'm designed to engage in a wide range of conversations! I can discuss topics like science, history, philosophy, arts, and more. I can also help with problem-solving, answer questions, or just chat casually. Plus, I'm always up to date with the current time and date. What interests you most?"
        }
        
        // Knowledge domains
        if lowerQuestion.contains("history") {
            context["topic"] = "history"
            return "History is fascinating! I can discuss various periods and events, from ancient civilizations to modern times. Any specific era or event you're curious about?"
        }
        if lowerQuestion.contains("science") {
            context["topic"] = "science"
            return "Science is a vast and exciting field! I can talk about physics, biology, chemistry, astronomy, and more. What area of science intrigues you the most?"
        }
        if lowerQuestion.contains("technology") {
            context["topic"] = "technology"
            return "Technology is rapidly evolving! We could discuss AI, blockchain, quantum computing, or any other tech trends. What aspect of technology would you like to explore?"
        }
        if lowerQuestion.contains("philosophy") {
            context["topic"] = "philosophy"
            return "Philosophy offers deep insights into existence and knowledge. We could discuss ethics, metaphysics, epistemology, or famous philosophers. What philosophical question intrigues you?"
        }
        if lowerQuestion.contains("art") || lowerQuestion.contains("literature") {
            context["topic"] = "arts"
            return "The world of arts and literature is rich and diverse! We could talk about famous paintings, literary movements, or specific artists and authors. What aspect of arts or literature interests you?"
        }
        
        // Current events
        if lowerQuestion.contains("news") || lowerQuestion.contains("current events") {
            return "While I don't have real-time access to current events, I can discuss general trends and major historical events up to my last update. As of \(dateFormatter.string(from: Date())), what specific area of current events are you interested in?"
        }
        
        // Philosophical questions
        if lowerQuestion.contains("meaning of life") {
            return "The meaning of life is a profound question that has puzzled philosophers for centuries. Some find meaning in happiness, others in duty or love. What do you think gives life meaning?"
        }
        
        // Jokes
        if lowerQuestion.contains("tell") && lowerQuestion.contains("joke") {
            let jokes = [
                "Why don't scientists trust atoms? Because they make up everything!",
                "Why did the scarecrow win an award? He was outstanding in his field!",
                "Why don't eggs tell jokes? They'd crack each other up!",
                "Why did the math book look so sad? Because it had too many problems."
            ]
            return jokes.randomElement() ?? "I'm afraid my joke generator is feeling a bit shy right now. How about you tell me a joke instead?"
        }
        
        // Context-aware responses
        if let topic = context["topic"] as? String {
            if lowerQuestion.contains("tell me more") {
                switch topic {
                case "history":
                    return "In history, we can explore how past events shape our present. From the rise and fall of empires to revolutionary ideas, there's always more to uncover. Any specific historical period or event you'd like to dive into?"
                case "science":
                    return "Science is all about discovery and understanding our world. We could discuss recent breakthroughs, fundamental theories, or the scientific method itself. What aspect of science would you like to explore further?"
                case "technology":
                    return "Technology is constantly evolving, shaping how we live and work. We could discuss emerging tech trends, ethical considerations, or the impact of technology on society. What tech topic intrigues you most?"
                case "philosophy":
                    return "Philosophy encourages us to question and ponder deep ideas. We could explore theories of knowledge, debates on free will, or ethical dilemmas. Which philosophical concept would you like to delve into?"
                case "arts":
                    return "The arts reflect and shape our culture in profound ways. We could discuss artistic movements, interpretation of art, or the role of creativity in society. What aspect of arts or literature would you like to explore more?"
                default:
                    return "I'd be happy to dive deeper into our topic. What specific aspect would you like to know more about?"
                }
            }
        }
        
        // Help or clarification
        if lowerQuestion.contains("help") || lowerQuestion.contains("confused") {
            return "No problem at all! I'm here to help. Feel free to ask me about any topic you're interested in, or if you're not sure where to start, we could discuss current trends in technology, explore a period in history, or ponder some philosophical questions. What sounds interesting to you?"
        }
        
        // Farewell
        if lowerQuestion.contains("bye") || lowerQuestion.contains("goodbye") {
            return "It's been a pleasure chatting with you! I've enjoyed our conversation and hope you found it interesting. Feel free to come back anytime you want to explore more ideas or just have a friendly chat. Take care!"
        }
        
        // Default responses for unrecognized inputs
        let defaultResponses = [
                    "That's an intriguing point! Could you elaborate a bit more? I'd love to understand your perspective better.",
                    "Interesting question! It touches on some complex ideas. To help me give a more accurate response, could you provide a bit more context?",
                    "That's a thought-provoking topic! There are many angles we could explore here. Is there a specific aspect you're most curious about?",
                    "You've raised an interesting point! While I don't have a definitive answer, I'd be happy to discuss various perspectives on this. What are your thoughts?",
                    "That's a fascinating area to explore! While it's beyond my current knowledge base, I'm always eager to learn. Could you share what you know about this?"
                ]
                
                return defaultResponses.randomElement() ?? "You've got me thinking! Could you rephrase or expand on your question? I want to make sure I understand and provide the best response possible."
            }
    
    private func getDayPeriod() -> String {
        let hour = Calendar.current.component(.hour, from: Date())
        switch hour {
        case 5..<12: return "morning"
        case 12..<17: return "afternoon"
        case 17..<22: return "evening"
        default: return "night"
        }
    }
}
