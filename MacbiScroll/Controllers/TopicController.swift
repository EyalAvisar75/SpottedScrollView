//
//  TopicController.swift
//  MacbiScroll
//
//  Created by eyal avisar on 08/07/2021.
//  Copyright © 2021 eyal avisar. All rights reserved.
//

import UIKit

class TopicController: UIViewController {

    //Properties
    
    var topic = ""
    var isGreen = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        let label = UILabel(frame: CGRect(x: view.bounds.width / 2 - 50, y: view.bounds.height / 2 - 30, width: 100, height: 60))
        
        label.text = topic
        
        if isGreen {
            view.backgroundColor = .green
        }
        else {
            view.backgroundColor = .blue
        }
        
        view.addSubview(label)
    }
    

    

}
