//
//  ScoreModel.swift
//  M1
//
//  Created by Lim Liu on 11/24/21.
//

import Foundation

class ScoreModel {
    static let sc = ScoreModel()
    var answered: Int = 0
    var correct: Int = 0
    var total = 7
    var mcq = [Question]()
    var blk = [Question]()
    
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
        for q in blk {
            q.isAnswered = false
        }
        for q in mcq {
            q.isAnswered = false
        }
        correct = 0
        answered = 0
    }
    
    
}
