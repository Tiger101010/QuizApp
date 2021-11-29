//
//  CellDetailViewController.swift
//  M1
//
//  Created by Lim Liu on 11/27/21.
//

import UIKit

class CellDetailViewController : UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var questionText: UITextField!
    @IBOutlet weak var answerText: UITextField!
    @IBOutlet weak var dateText: UILabel!
    
    @IBOutlet weak var uploadImgBtn: UIBarButtonItem!
    @IBOutlet weak var deleteImgBtn: UIBarButtonItem!
    @IBOutlet weak var imgView: UIImageView!
    
    var question: Question = Question(q: "Question Here", ans: "Answer Here", choices: [""])
    var index: Int = ScoreModel.sc.blk.count
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.setRightBarButton(editButtonItem, animated: false)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        questionText.text =  question.question
        answerText.text =  question.answer
        dateText.text = question.date
        
        enableBtns(enabled: false)
        
        if index != ScoreModel.sc.blk.count {
            if(question.img != nil) {
                self.imgView.image = question.img
            }
        }
    }
    
    @IBAction func uploadImg(_ sender: Any) {
        ImagePickerManager().pickImage(self){ image in
            self.imgView.image = image
            self.question.img = image
        }
    }
    
    @IBAction func deleteImg(_ sender: Any) {
        self.imgView.image = nil
        self.question.img = nil
    }
    
    func enableBtns(enabled: Bool) {
        questionText.isEnabled = enabled
        answerText.isEnabled = enabled
        uploadImgBtn.isEnabled = enabled
        deleteImgBtn.isEnabled = enabled
    }
    
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        if editing {
            if index == ScoreModel.sc.blk.count {
                questionText.text = ""
                answerText.text = ""
                dateText.text = question.date
            } else {
                questionText.text = question.question
                answerText.text = question.answer
                dateText.text = question.date
            }
            enableBtns(enabled: true)
        } else {
            question.question = questionText.text ?? "1 + 1 = ?"
            question.answer = answerText.text ?? "2"
            if index == ScoreModel.sc.blk.count {
                ScoreModel.sc.addQuestion(q: question)
            } else {
                ScoreModel.sc.modifyQuestion(index: index, q: question)
            }
            enableBtns(enabled: false)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}

