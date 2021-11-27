//
//  Question.swift
//  M1
//
//  Created by Lim Liu on 11/23/21.
//

import Foundation

class Question {
    let question : String
    let answer : String
    let choices : [String]
    var isAnswered : Bool
    var isCorrect : Bool
    
    init(q : String, ans : String, choices : [String]) {
        self.question = q
        self.answer = ans
        self.choices = choices
        self.isAnswered = false
        self.isCorrect = false
    }
    
}
