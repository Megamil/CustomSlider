//
//  ViewController.swift
//  SliderCustom
//
//  Created by Eduardo dos santos on 05/03/20.
//  Copyright © 2020 Eduardo dos santos. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var slider: CustomSlider!
    @IBOutlet weak var emoji: UIImageView!
    
    var emoticons: [UIImage] = [#imageLiteral(resourceName: "Emoticon 1"),#imageLiteral(resourceName: "Emoticon 2"),#imageLiteral(resourceName: "Emoticon 3"),#imageLiteral(resourceName: "Emoticon 4"),#imageLiteral(resourceName: "Emoticon 5"),#imageLiteral(resourceName: "Emoticon 6"),#imageLiteral(resourceName: "Emoticon 7"),#imageLiteral(resourceName: "Emoticon 8"),#imageLiteral(resourceName: "Emoticon 9"),#imageLiteral(resourceName: "Emoticon 10")]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        slider.themeRating(view: self.view)
    }
    
    @IBAction func onChangeSlider(_ sender: Any) {
        slider.updateLabelLocation()
        emoji.image = emoticons[slider.indice]
    }
    
}

