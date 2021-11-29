//
//  ListDataSource.swift
//  M1
//
//  Created by Lim Liu on 11/26/21.
//

import UIKit

class ListDataSource: NSObject{
    
}

extension ListDataSource: UITableViewDataSource {
    static let questionListCellIdentifier = "QuestionListCell"

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ScoreModel.sc.blk.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Self.questionListCellIdentifier, for: indexPath)
                as? ListCell else {
            fatalError("Unable to dequeue Cell")
        }
        let q = ScoreModel.sc.blk[indexPath.row]
        cell.configure(question: q.question, answer: q.answer, date: q.date)
        tableView.reloadRows(at: [indexPath], with: .none)

        return cell
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let blkQuestion = ScoreModel.sc.blk[sourceIndexPath.item]
        ScoreModel.sc.blk.remove(at: sourceIndexPath.item)
        ScoreModel.sc.blk.insert(blkQuestion, at: destinationIndexPath.item)
    
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if(editingStyle == .delete)
        {
            ScoreModel.sc.blk.remove(at: indexPath.item)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            ScoreModel.sc.total -= 1
        }
    }
    

}


/*
 func tableView(_ tableView : UITableView, numberOfRowsInSection section: Int) -> Int {
     return Score.sI.fib.count
 }
 
 func tableView(_ tableView : UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
     let cell = FIBQandATable.dequeueReusableCell(withIdentifier: "cell", for: indexPath as IndexPath) as! TableViewCell
     let item = Score.sI.fib[indexPath.row]
     cell.qsLabelCell.text = item.question
     cell.ansLabelCell.text = item.answer
     return cell
    
 }
 
 
 func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
     let FIBQAtemp = Score.sI.fib[sourceIndexPath.item]
     Score.sI.fib.remove(at: sourceIndexPath.item)
     Score.sI.fib.insert(FIBQAtemp, at: destinationIndexPath.item)
 
 }

 func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
     if(editingStyle == .delete)
     {
         Score.sI.fib.remove(at: indexPath.item)
         FIBQandATable.deleteRows(at: [indexPath], with: .automatic)
     }
 }
 
 
 @IBAction func editAction(_ sender: UIBarButtonItem) {
     self.FIBQandATable.isEditing = !self.FIBQandATable.isEditing
     sender.title = (self.FIBQandATable.isEditing) ? "Done" : "Edit"
 }
 */
