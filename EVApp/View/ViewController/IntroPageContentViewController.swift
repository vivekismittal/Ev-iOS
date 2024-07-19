//
//  SlideViewController.swift
//  EVApp
//
//  Created by Brijesh Bhardwaj on 16/05/23.
//

import UIKit

class IntroPageContentViewController: UIViewController {
    @IBOutlet weak var imgSlide: UIImageView!
    @IBOutlet weak var lblText: UILabel!
    
    @IBOutlet weak var lblText3: UILabel!
    @IBOutlet weak var lbltext2: UILabel!
    var index: Int = -1
    var currentIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.setHidesBackButton(true, animated: true)
        self.slider()
    }
    
@objc func slider(){
    if self.index == 0{
        self.imgSlide.image = UIImage(named: "car")
        self.lblText.text = "Book a charge point"
        self.lbltext2.text =  "&"
        self.lblText3.text = "Charge Your Vehicle"
    }else if index == 1{
        self.imgSlide.image = UIImage(named: "img2")
        self.lblText.text = "Pay online in few clicks"
        self.lbltext2.text =  ""
        self.lblText3.text = ""
    }else if index == 2{
        self.imgSlide.image = UIImage(named: "img3")
        self.lblText.text = "Search"
        self.lbltext2.text =  "&"
        self.lblText3.text = "Locate Charge Stations"
    }else if index == 3{
        self.imgSlide.image = UIImage(named: "img4")
        self.lblText.text = "Scan Barcode"
        self.imgSlide.image = UIImage(named: "img3")
        self.lbltext2.text =  "&"
        self.lblText3.text = "Start charging"
    }
    }
}
