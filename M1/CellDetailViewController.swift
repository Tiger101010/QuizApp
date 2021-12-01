//
//  CellDetailViewController.swift
//  M1
//
//  Created by Lim Liu on 11/27/21.
//

import UIKit

class CellDetailViewController : UIViewController, UITextFieldDelegate {
    
    private var prevEditStatus: Bool = false
    
    @IBOutlet weak var questionText: UITextField!
    @IBOutlet weak var answerText: UITextField!
    @IBOutlet weak var dateText: UILabel!
    
    @IBOutlet weak var uploadImgBtn: UIBarButtonItem!
    @IBOutlet weak var deleteImgBtn: UIBarButtonItem!
    @IBOutlet weak var drawBtn: UIBarButtonItem!
    @IBOutlet weak var imgView: UIImageView!
    
    var question: Question = Question(q: "Question Here", ans: "Answer Here", choices: [""])
    var index: Int = ScoreModel.sc.blk.count
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.setRightBarButton(editButtonItem, animated: false)
        if index != ScoreModel.sc.blk.count {
            question = ScoreModel.sc.blk[index]
        }
        if(question.img != nil) {
            self.imgView.image = question.loadImg()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        questionText.text =  question.question
        answerText.text =  question.answer
        dateText.text = question.date
        
        enableBtns(enabled: false)
        
        if index != ScoreModel.sc.blk.count {
            if(question.img != nil) {
                self.imgView.image = question.loadImg()
            }
        }
        //setEditing(false, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier{
            case "Draw":
                setEditing(false, animated: true)
                question.question = questionText.text ?? "Question Here"
                question.answer = answerText.text ?? "Answer Here"
                let drawViewController = segue.destination as! DrawViewController
                drawViewController.loadView()
                drawViewController.index = index
                drawViewController.drawView.finishedLines = question.drawing
                drawViewController.question = question
            default:
                preconditionFailure("Unexpected segue identifier.")
            }
    }
    
    @IBAction func uploadImg(_ sender: Any) {
        ImagePickerManager().pickImage(self){ image in
            self.imgView.image = image
            self.question.saveImg(img: image)
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
        drawBtn.isEnabled = enabled
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
            reset()
            ScoreModel.sc.save()
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func reset() {
        print("reset start")
        guard let viewControllers = self.tabBarController?.viewControllers else {print("failed"); return}
        for viewController in viewControllers {
            if let controller = viewController as? UINavigationController {
                if let blkController = controller.viewControllers.first as? BLKViewController{
                    print(type(of: blkController))
                    ScoreModel.sc.reset()
                    
                    blkController.loadView()
                    blkController.viewDidLoad()
                }
                if let mcqController = controller.viewControllers.first as? MCQViewController{
                    print(type(of: mcqController))
                    
                    mcqController.loadView()
                    mcqController.viewDidLoad()
                }
            }
        }
        print("done")
    }
}

