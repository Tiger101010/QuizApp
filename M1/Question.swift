//
//  Question.swift
//  M1
//
//  Created by Lim Liu on 11/23/21.
//

import Foundation
import UIKit


class Question: Codable {
    var question : String
    var answer : String
    let choices : [String]
    var isAnswered : Bool
    var isCorrect : Bool
    var date: String
    var img: CodableImage?
    var drawing = [Line]()
    
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
    
    func saveImg(img: UIImage){
        let uiImg = CodableImage(img: img)
        self.img = uiImg
    }
    
    func loadImg()->UIImage? {
        guard let tempImg = self.img else {return nil}
        return UIImage(data: tempImg.img)
    }
}
