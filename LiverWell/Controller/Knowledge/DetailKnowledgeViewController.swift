//
//  DetailKnowledgeViewController.swift
//  LiverWell
//
//  Created by 徐若芸 on 2019/4/8.
//  Copyright © 2019 Jo Hsu. All rights reserved.
//

import UIKit

class DetailKnowledgeViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var contentLabel: UILabel!
    
    var knowledge: Knowledge?
    
    var isMarked: Bool = false
    
    @IBAction func backBtnPressed(_ sender: UIButton) {
        
//        dismiss(animated: true)
        
        self.navigationController?.popViewController(animated: true)
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleLabel.text = knowledge?.title
        
        contentLabel.text = knowledge?.content
        
//        self.navigationController?.isNavigationBarHidden = true

    }

}
