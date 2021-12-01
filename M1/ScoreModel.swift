//
//  ScoreModel.swift
//  M1
//
//  Created by Lim Liu on 11/24/21.
//

import Foundation

class ScoreModel: ObservableObject {
    static let sc = ScoreModel()
    var answered: Int = 0
    var correct: Int = 0
    var total = 7
    @Published var mcq = [Question]()
    @Published var blk = [Question]()
    
    private static var documentsFolder: URL {
        do {
            return try FileManager.default.url(for: .documentDirectory,
                                               in: .userDomainMask,
                                               appropriateFor: nil,
                                               create: false)
        } catch {
            fatalError("Can't find documents directory.")
        }
    }
    private static var mcqFileURL: URL {
        return documentsFolder.appendingPathComponent("quiz_mcq.data")
    }
    private static var blkFileURL: URL {
        return documentsFolder.appendingPathComponent("quiz_blk.data")
    }
    
    init() {
        var questions: [String] = ["What is 7+7?","What is 1+1?","What is 2+2?"]
        var answer : [String] = ["14","2","4"]
        var choices: [[String]] = [["1","2","14"],["4","5","2","21"],["5","4","9"]]
        
        for i in 0...2 {
            let q = Question(q: questions[i], ans: answer[i], choices: choices[i])
            mcq.append(q)
        }
        
        questions = ["What is 7+6?","What is 1+0?","What is 2+1?","What is 2+7?"]
        answer = ["13","1","3","9"]
        choices = [["13"], ["1"], ["3"],[""]]
        
        for i in 0...3 {
            let q = Question(q: questions[i], ans: answer[i], choices: choices[i])
            blk.append(q)
        }
    }
    
    func load() {
        print("loading...")
        DispatchQueue.global(qos: .background).async { [weak self] in
            guard let mcqData = try? Data(contentsOf: Self.mcqFileURL) else {return}
            guard let blkData = try? Data(contentsOf: Self.blkFileURL) else {return}
            
            guard let mcqDecode = try? JSONDecoder().decode([Question].self, from: mcqData) else {
                fatalError("Can't decode saved mcq data.")
            }
            guard let blkDecode = try? JSONDecoder().decode([Question].self, from: blkData) else {
                fatalError("Can't decode saved blk data.")
            }
            DispatchQueue.main.async {
                self?.mcq = mcqDecode
            }
            DispatchQueue.main.async {
                self?.blk = blkDecode
            }
        }
    }
    
    func save() {
        print("saving...")
        DispatchQueue.global(qos: .background).async { [weak self] in
            guard let mcq = self?.mcq else { fatalError("Self out of scope") }
            guard let blk = self?.blk else { fatalError("Self out of scope") }
            
            guard let mcqData = try? JSONEncoder().encode(mcq) else { fatalError("Error encoding data") }
            do {
                let outfile = Self.mcqFileURL
                try mcqData.write(to: outfile)
            } catch {
                fatalError("Can't write to file")
            }
            
            guard let blkData = try? JSONEncoder().encode(blk) else { fatalError("Error encoding data") }
            do {
                let outfile = Self.blkFileURL
                try blkData.write(to: outfile)
            } catch {
                fatalError("Can't write to file")
            }
        }
    }
    
    func getMCQQues(index: Int) -> String{
        return ScoreModel.sc.mcq[index].question
    }
    
    func getBLKQues(index: Int) -> String{
        return ScoreModel.sc.blk[index].question
    }
    
    func answerMCQ(index: Int, answer: String) -> Bool{
        mcq[index].isAnswered = true
        answered += 1
        if(answer == mcq[index].answer) {
            mcq[index].isCorrect = true
            correct += 1
            return true
        } else {
            mcq[index].isCorrect = false
            return false
        }
    }
    
    func answerBLK(index: Int, answer: String) -> Bool {
        blk[index].isAnswered = true
        answered += 1
        if(answer == blk[index].answer) {
            blk[index].isCorrect = true
            correct += 1
            return true
        } else {
            blk[index].isCorrect = false
            return false
        }
    }
    
    func reset() {
        total = 0
        for q in blk {
            total += 1
            q.isAnswered = false
        }
        for q in mcq {
            q.isAnswered = false
            total += 1
        }
        correct = 0
        answered = 0
    }
    
    func addQuestion(q: Question) {
        if(q.question != "") {
            self.blk.append(q)
            total += 1
            reset()
        }
        save()
    }
    
    func modifyQuestion(index: Int, q: Question) {
        q.updateTime()
        self.blk[index] = q
        reset()
        save()
    }
    
    
}
