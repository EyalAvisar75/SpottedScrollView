//
//  ViewController.swift
//  MacbiScroll
//
//  Created by eyal avisar on 07/07/2021.
//  Copyright © 2021 eyal avisar. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    //MARK: Properties
    
//    var buttonsR1Titles = ["topic 1", "topic 2", "topic 3"]
//    var buttonsR2Titles = ["topic 4", "topic 5", "topic 6", "topic 7"]
//    var buttonsR3Titles = ["topic 8", "topic 9", "topic 10"]
    var buttons: [UIButton] = []
    
    var scroll = UIScrollView(frame: .zero)
    var lastOffset: CGFloat = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        scroll = UIScrollView(frame: view.bounds)
        scroll.backgroundColor = .black
        scroll.contentSize = CGSize(width: view.bounds.width * 2, height: view.bounds.height - 100)
        
        view.addSubview(scroll)
        scroll.delegate = self
        scroll.bounces = false
        
        for index in 0...30 {
            if index % 2 == 1 {
                let buttonR1 = UIButton(frame: CGRect(x: CGFloat(index) * scroll.contentSize.width / 10, y: 50, width: view.bounds.width / 3, height: view.bounds.width / 3))
                
                buttonR1.layer.cornerRadius = buttonR1.bounds.width / 2
//                buttonR1.setTitle(buttonsR1Titles[0], for: .normal)
                var title = "topic\(Int.random(in: 1...100))"
                buttonR1.setTitle(title, for: .normal)
                
                buttonR1.backgroundColor = buttonFormat(sender: buttonR1).isGreen ? .green : .blue
                
//                buttonsR1Titles.remove(at: 0)
                
                buttons.append(buttonR1)
                scroll.addSubview(buttonR1)
                
                addTargetToButton()
                
                let buttonR3 = UIButton(frame: CGRect(x: CGFloat(index) * scroll.contentSize.width / 10, y: view.bounds.height / 3 * 2 + 50, width: view.bounds.width / 3, height: view.bounds.width / 3))
                
                buttonR3.layer.cornerRadius = buttonR3.bounds.width / 2
//                buttonR3.setTitle(buttonsR3Titles[0], for: .normal)
                title = "topic\(Int.random(in: 1...100))"
                buttonR3.setTitle(title, for: .normal)
                
                buttonR3.backgroundColor = buttonFormat(sender: buttonR3).isGreen ? .green : .blue
//                buttonsR3Titles.remove(at: 0)
                
                buttons.append(buttonR3)
                scroll.addSubview(buttonR3)
            }
            else {
                let buttonR2 = UIButton(frame: CGRect(x: CGFloat(index) * scroll.contentSize.width / 10, y: view.bounds.height / 3 + 50, width: view.bounds.width / 3, height: view.bounds.width / 3))
                
                buttonR2.layer.cornerRadius = buttonR2.bounds.width / 2
//                buttonR2.setTitle(buttonsR2Titles[0], for: .normal)
                let title = "topic\(Int.random(in: 1...999))"
                buttonR2.setTitle(title, for: .normal)
                
                buttonR2.backgroundColor = buttonFormat(sender: buttonR2).isGreen ? .green : .blue
                
//                buttonsR2Titles.remove(at: 0)
                
                buttons.append(buttonR2)
                scroll.addSubview(buttonR2)
            }
            
            addTargetToButton()
        }
        
    }
    
    func addTargetToButton() {
        buttons.last!.addTarget(self, action: #selector(pushScreen(sender:)), for: .touchUpInside)
    }
    
    @objc func pushScreen(sender: UIButton) {
        let controller = storyboard?.instantiateViewController(withIdentifier: "Topic") as! TopicController
        
        let results = buttonFormat(sender: sender)
        controller.isGreen = results.isGreen ? true : false
        
        controller.topic = results.text
        
        navigationController?.pushViewController(controller, animated: true)
        
    }
    
    func buttonFormat(sender: UIButton) -> (isGreen: Bool, text: String) {
        let text =  sender.titleLabel?.text! as! String
        let numberStr = String(text.last!)
        let number = Int(numberStr)!
        
        return (number % 3 == 0, text)
    }
    
    func resizeLayer(sender: UIButton, offset: CGFloat) {
        print(offset)
        let enlargeFactor: CGFloat = 10 / 9
        let shrinkFactor: CGFloat = 0.9
        let minRadius: CGFloat = 75
        let maxRadius: CGFloat = 120
        let origin = sender.frame.origin
        
        //initial setup
        
        setupButtons(origin: origin, sender: sender)
        
        if origin.x - offset <= view.bounds.size.width * 0.2 && sender.bounds.width >= minRadius {
            sender.bounds.size.width *= shrinkFactor
            sender.bounds.size.height *= shrinkFactor
        }
        else if origin.x - offset <= view.bounds.width - sender.bounds.width && origin.x - offset > view.bounds.size.width * 0.6 && sender.bounds.width <= maxRadius {
            sender.bounds.size.width *= enlargeFactor
            sender.bounds.size.height *= enlargeFactor
        }
        else if origin.x - offset <= view.bounds.width / 3 && sender.bounds.width <= maxRadius {
            sender.bounds.size.width *= enlargeFactor
            sender.bounds.size.height *= enlargeFactor
        }
        
        sender.layer.cornerRadius = sender.bounds.width / 2
    }
    
    func setupButtons(origin: CGPoint, sender: UIButton) {
        let minRadius: CGFloat = 75
        let maxRadius: CGFloat = 120
        
        if Int(origin.y) == Int((272 / 375) * view.bounds.size.width)  {
            if origin.x == 0 {
                sender.bounds.size.width = minRadius + 5
                sender.bounds.size.height = minRadius + 5
            }
            else if origin.x == view.bounds.width * 0.4 || origin.x == view.bounds.width * 0.8 {
                sender.bounds.size.width = maxRadius
                sender.bounds.size.height = maxRadius
            }
            else {
                sender.bounds.size.width = minRadius
                sender.bounds.size.height = minRadius
            }
        }
        else {
            if origin.x == view.bounds.width * 0.2 || origin.x == view.bounds.width * 0.6 {
                sender.bounds.size.width = maxRadius
                sender.bounds.size.height = maxRadius
            }
        }
        
        sender.layer.cornerRadius = sender.bounds.width / 2
    }
}

extension ViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let maxRadius = 120
        let rows = 3
        let maxOffset = CGFloat(buttons.count * maxRadius / rows) - view.bounds.width
        
        var offset = scrollView.contentOffset.x
        
        offset = offset > maxOffset ? maxOffset : offset
        
        scrollView.contentOffset = CGPoint(x: offset, y: scrollView.contentOffset.y)
        
        for button in buttons {
            resizeLayer(sender: button, offset: offset)
        }
    }
}
