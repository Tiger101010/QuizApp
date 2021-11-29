//
//  Question.swift
//  M1
//
//  Created by Lim Liu on 11/23/21.
//

import Foundation
import UIKit


class Question {
    var question : String
    var answer : String
    let choices : [String]
    var isAnswered : Bool
    var isCorrect : Bool
    var date: String
    var img: UIImage?
    
    init(q : String, ans : String, choices : [String]) {
        self.question = q
        self.answer = ans
        self.choices = choices
        self.isAnswered = false
        self.isCorrect = false
        img = nil
        
        let dateTime = Date()
        let formatter = DateFormatter()
        formatter.timeStyle = .medium
        formatter.dateStyle = .long
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        self.date = formatter.string(from: dateTime)
    }
    
    func updateTime() {
        let dateTime = Date()
        let formatter = DateFormatter()
        formatter.timeStyle = .medium
        formatter.dateStyle = .long
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        self.date = formatter.string(from: dateTime)
    }
}
