//
//  DrawView.swift
//  M1
//
//  Created by Lim Liu on 11/30/21.
//

import UIKit

class DrawView: UIView, UIGestureRecognizerDelegate {
    
    var currentLines = [NSValue: Line]()
    var finishedLines = [Line]()
    var selectedLineIndex: Int? {
        willSet {
            // If new line selected while another line is selected...
            // Hide menu
            if newValue != selectedLineIndex {
                let menu = UIMenuController.shared
                if menu.isMenuVisible {
                    menu.setMenuVisible(false, animated: true)
                }
            }
        }
        
        didSet {
            // If line is deselected...
            // Hide menu
            if selectedLineIndex == nil {
                let menu = UIMenuController.shared
                if menu.isMenuVisible {
                    menu.setMenuVisible(false, animated: true)
                }
            }
        }
    }
    var panRecognizer: UIPanGestureRecognizer!
    var longPressRecognizer: UILongPressGestureRecognizer!
    
    // MARK: - IBInspectables
    var defaultLineColor: UIColor = UIColor.black
    
    @IBInspectable var finishedLineColor: UIColor = UIColor.black {
        didSet {
            setNeedsDisplay()
        }
    }
    
    @IBInspectable var currentLineColor: UIColor = UIColor.red {
        didSet {
            setNeedsDisplay()
        }
    }
    
    @IBInspectable var lineThickness: CGFloat = 10 {
        didSet {
            setNeedsDisplay()
        }
    }
    
    // MARK: - Init
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        // double tap recognizer
        let doubleTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(DrawView.doubleTap(_:)))
        doubleTapRecognizer.numberOfTapsRequired = 2
        doubleTapRecognizer.delaysTouchesBegan = true
        addGestureRecognizer(doubleTapRecognizer)
        
        // tap recognizer
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(DrawView.tap(_:)))
        tapRecognizer.delaysTouchesBegan = true
        tapRecognizer.require(toFail: doubleTapRecognizer)
        addGestureRecognizer(tapRecognizer)
        
        // long press recognizer
        longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(DrawView.longPress(_:)))
        addGestureRecognizer(longPressRecognizer)
        
        // pan recognizer
        panRecognizer = UIPanGestureRecognizer(target: self, action: #selector(DrawView.panLine(_:)))
        panRecognizer.delegate = self
        panRecognizer.cancelsTouchesInView = false
        addGestureRecognizer(panRecognizer)
    }
    
    // MARK: - GestureRecognizers
    
    func deleteAll(action: UIAlertAction) {
        self.selectedLineIndex = nil
        self.currentLines.removeAll()
        self.finishedLines.removeAll()
        setNeedsDisplay()
    }
    
    @objc func doubleTap(_ gestureRecognizer: UIGestureRecognizer) {
        print("Recognized a double tap")
        
        showAlert()
        
    }
    
    @objc func tap(_ gestureRecognizer: UIGestureRecognizer) {
        print("Recognized a tap")
        
        let point = gestureRecognizer.location(in: self)
        selectedLineIndex = indexOfLine(at: point)
        
        // Grab the menu controller
        let menu = UIMenuController.shared
        
        if selectedLineIndex != nil {
            
            // Make DrawView the target of menu item action messages
            becomeFirstResponder()
            
            // Create a new "Delete" UIMenuItem
            let deleteItem = UIMenuItem(title: "Delete", action: #selector(DrawView.deleteLine(_:)))
            let blueItem = UIMenuItem(title: "Blue", action: #selector(DrawView.setLineColorBlue(_:)))
            let redItem = UIMenuItem(title: "Red", action: #selector(DrawView.setLineColorRed(_:)))
            let grayItem = UIMenuItem(title: "Gray", action: #selector(DrawView.setLineColorGray(_:)))
            let orangeItem = UIMenuItem(title: "Orange ", action: #selector(DrawView.setLineColorOrange(_:)))
            menu.menuItems = [deleteItem, blueItem, redItem, grayItem, orangeItem]
            
            // Tell the menu where it should come from,
            // and show it
            let targetRect = CGRect(x: point.x, y: point.y, width: 2, height: 2)
            menu.setTargetRect(targetRect, in: self)
            menu.setMenuVisible(true, animated: true)
        }
        
        setNeedsDisplay()
    }
    
    @objc func longPress(_ gestureRecognizer: UIGestureRecognizer) {
        print("Recognized a long press")
        
        let point = gestureRecognizer.location(in: self)
        selectedLineIndex = indexOfLine(at: point)
        
        if gestureRecognizer.state == .began {
            
        }
        else if gestureRecognizer.state == .ended {
            if selectedLineIndex == nil {
                // Grab the menu controller
                let menu = UIMenuController.shared
                
                // Make DrawView the target of menu item action messages
                becomeFirstResponder()
                
                // Create a new "Delete" UIMenuItem
                let blueItem = UIMenuItem(title: "Blue", action: #selector(DrawView.setDefaultLineColorBlue(_:)))
                let redItem = UIMenuItem(title: "Red", action: #selector(DrawView.setDefaultLineColorRed(_:)))
                let blackItem = UIMenuItem(title: "Black", action: #selector(DrawView.setDefaultLineColorBlack(_:)))
                let orangeItem = UIMenuItem(title: "Orange ", action: #selector(DrawView.setDefaultLineColorOrange(_:)))
                menu.menuItems = [blueItem, redItem, blackItem, orangeItem]
                
                // Tell the menu where it should come from,
                // and show it
                let targetRect = CGRect(x: point.x, y: point.y, width: 2, height: 2)
                menu.setTargetRect(targetRect, in: self)
                menu.setMenuVisible(true, animated: true)
            }
        }
        
        setNeedsDisplay()
    }
    
    @objc func panLine(_ gestureRecognizer: UIPanGestureRecognizer) {
        print("Recognized a pan")
        
        guard longPressRecognizer.state == .changed
        else {
                return
        }
        
        // If a line is selected...
        if let index = selectedLineIndex {
            // When the pan recognizer changes its position...
            if gestureRecognizer.state == .changed {
                // How far has the pan moved?
                let translation = gestureRecognizer.translation(in: self)
                
                // Add the translation to the current beginning and end points of the line
                // Make sure there are no copy and paste typos!
                finishedLines[index].begin.x += translation.x
                finishedLines[index].begin.y += translation.y
                finishedLines[index].end.x += translation.x
                finishedLines[index].end.y += translation.y
                
                gestureRecognizer.setTranslation(CGPoint.zero, in: self)
                
                // Redraw screen
                setNeedsDisplay()
            }
        }
    }
    // MARK: - Responder
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    // MARK: - Draw
    
    func stroke(_ line: Line, color: UIColor?) {
        let path = UIBezierPath()
        path.lineWidth = lineThickness
        path.lineCapStyle = .round
        
        if(color == nil) {
            line.getColor().setStroke()
        } else {
            color?.setStroke()
        }
        path.move(to: line.begin)
        path.addLine(to: line.end)
        path.stroke()
    }
    
    override func draw(_ rect: CGRect) {
        // Draw finished lines in black
        //finishedLineColor.setStroke()
        for line in finishedLines {
            stroke(line, color: nil)
        }
        
        currentLineColor.setStroke()
        for (_, line) in currentLines {
            stroke(line, color: currentLineColor)
        }
        
        if let index = selectedLineIndex {
            UIColor.green.setStroke()
            let selectedLine = finishedLines[index]
            stroke(selectedLine, color: UIColor.green)
        }
    }
    
    /// Returns the index of the Line closest to a given point
    func indexOfLine(at point: CGPoint) -> Int? {
        // Find a line close to point
        // Start from reverse, to prefer the latter drawn lines
        for (index, line) in finishedLines.enumerated().reversed() {
            let begin = line.begin
            let end = line.end
            
            // Check a few points on the line
            for t in stride(from: CGFloat(0), to: 1.0, by: 0.05) {
                let x = begin.x + ((end.x - begin.x) * t)
                let y = begin.y + ((end.y - begin.y) * t)
                
                // If the tapped point is within 10 points, let's return this line
                if hypot(x - point.x, y - point.y) < 10.0 {
                    return index
                }
            }
        }
        
        // If nothing is close enough to the tapped point,
        // then we did not select a line
        return nil
    }
    
    //MARK: - UIMenuController
    
    @objc func deleteLine(_ sender: UIMenuController) {
        // Remove the selected line from the list of finishedLines
        if let index = selectedLineIndex {
            finishedLines.remove(at: index)
            selectedLineIndex = nil
            
            // Redraw everything
            setNeedsDisplay()
        }
    }
    
    @objc func setLineColorBlue(_ sender: UIMenuController) {
        if let index = selectedLineIndex {
            finishedLines[index].setColor(color: UIColor.blue)
            stroke(finishedLines[index], color: nil)
            
            // Redraw everything
            setNeedsDisplay()
        }
    }
    @objc func setLineColorRed(_ sender: UIMenuController) {
        if let index = selectedLineIndex {
            finishedLines[index].setColor(color: UIColor.red)
            stroke(finishedLines[index], color: nil)
            
            // Redraw everything
            setNeedsDisplay()
        }
    }
    @objc func setLineColorGray(_ sender: UIMenuController) {
        if let index = selectedLineIndex {
            finishedLines[index].setColor(color: UIColor.gray)
            stroke(finishedLines[index], color: nil)
            
            // Redraw everything
            setNeedsDisplay()
        }
    }
    @objc func setLineColorOrange(_ sender: UIMenuController) {
        if let index = selectedLineIndex {
            finishedLines[index].setColor(color: UIColor.orange)
            stroke(finishedLines[index], color: nil)
            
            // Redraw everything
            setNeedsDisplay()
        }
    }
    
    @objc func setDefaultLineColorBlue(_ sender: UIMenuController) {
        defaultLineColor = UIColor.blue
    }
    @objc func setDefaultLineColorRed(_ sender: UIMenuController) {
        defaultLineColor = UIColor.red
    }
    @objc func setDefaultLineColorBlack(_ sender: UIMenuController) {
        defaultLineColor = UIColor.black
    }
    @objc func setDefaultLineColorOrange(_ sender: UIMenuController) {
        defaultLineColor = UIColor.orange
    }
    
    // MARK: - Touches
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // Log statement to see the order of events
        print(#function)
        
        for touch in touches {
            let location = touch.location(in: self)
            
            let newLine = Line(begin: location, end: location, color: 4)
            
            let key = NSValue(nonretainedObject: touch)
            currentLines[key] = newLine
        }
        
        setNeedsDisplay()
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        // Log statement to see the order of events
        print(#function)
        
        for touch in touches {
            let key = NSValue(nonretainedObject: touch)
            currentLines[key]?.end = touch.location(in: self)
        }
        
        setNeedsDisplay()
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        // Log statement to see the order of events
        print(#function)
        
        for touch in touches {
            let key = NSValue(nonretainedObject: touch)
            if var line = currentLines[key] {
                line.end = touch.location(in: self)
                line.setColor(color: defaultLineColor)
                finishedLines.append(line)
                currentLines.removeValue(forKey: key)
            }
        }
        
        setNeedsDisplay()
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        // Log statement to see the order of events
        print(#function)
        
        currentLines.removeAll()
        
        setNeedsDisplay()
    }
    
    // MARK: - UIGestureRecognizerDelegate
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
//}


//extension UIView {
    
    var parentViewController: UIViewController? {
        // Starts from next (As we know self is not a UIViewController).
        var parentResponder: UIResponder? = self.next
        while parentResponder != nil {
            if let viewController = parentResponder as? UIViewController {
                return viewController
            }
            parentResponder = parentResponder?.next
        }
        return nil
    }
    
    func showAlert() {
        let alert = UIAlertController(title: "Delete All?", message: "You will delete all the strokes", preferredStyle: UIAlertController.Style.alert)

        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Confirm", style: UIAlertAction.Style.default, handler: deleteAll))
        parentViewController?.present(alert, animated: true, completion: nil)
    }


    
}

extension UIView {
    
    open func takeScreenshot(_ shouldSave: Bool = true) -> UIImage? {
        var screenshotImage :UIImage?
        let layer = UIApplication.shared.keyWindow!.layer
        let scale = UIScreen.main.scale
        UIGraphicsBeginImageContextWithOptions(layer.frame.size, false, scale);
        guard let context = UIGraphicsGetCurrentContext() else {return nil}
        layer.render(in:context)
        screenshotImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        if let image = screenshotImage, shouldSave {
            UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
        }
        return screenshotImage
    }

}
