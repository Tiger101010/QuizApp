//
//  ListCell.swift
//  M1
//
//  Created by Lim Liu on 11/26/21.
//
import UIKit

class ListCell: UITableViewCell {

    @IBOutlet var questionLabel: UILabel!
    @IBOutlet var answerLabel: UILabel!

    func configure(question: String, answer: String) {
        questionLabel.text = question
        answerLabel.text = answer
    }
}
