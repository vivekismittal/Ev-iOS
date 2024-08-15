//
//  HelpCenterVC.swift
//  EVApp
//
//  Created by Brijesh Bhardwaj on 01/06/23.
//

import UIKit

class HelpCenterVC: UIViewController {

    @IBOutlet weak var addressView: UIView!
    @IBOutlet weak var writeView: UIView!
    @IBOutlet weak var callView: UIView!
    @IBOutlet weak var chatView: UIView!
    
    var helpTextBody: String{
        "Hey! My name is \(UserAppStorage.userFullName ?? "NA")\nand I need your help......"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        chatView.addShadow()
        callView.addShadow()
        addressView.addShadow()
        writeView.addShadow()
    }
    
    @IBAction func back(_ sender: Any) {
        goBack()
    }
    
    @IBAction func onChatWithUs(_ sender: Any) {
        let whatsAppUrl = URL(string: "https://api.whatsapp.com/send?phone=\(UserAppStorage.helplineNumber)&text=\(helpTextBody)")!
        openUrlIfPossible(whatsAppUrl)
    }
    
    @IBAction func onCallUs(_ sender: Any) {
        let numberUrl = URL(string: "tel://\(UserAppStorage.helplineNumber)")!
        openUrlIfPossible(numberUrl)
    }
    
    @IBAction func onWriteToUs(_ sender: Any) {
        let smsUrl = URL(string: "sms:\(UserAppStorage.helplineNumber)&body=\(helpTextBody)")!
        openUrlIfPossible(smsUrl)
    }
    
    private func openUrlIfPossible(_ url: URL){
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }

}
extension UIView {
  func addShadow() {
    self.layer.shadowColor = UIColor.gray.cgColor
      self.layer.shadowOffset = CGSize(width: 2, height: 1)
      self.layer.shadowOpacity = 0.8
      self.layer.shadowRadius = 4
      self.layer.cornerRadius = 15
  }
}
extension UIView {
    func dropShadow(scale: Bool = true) {
        layer.masksToBounds = false
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.5
        layer.shadowOffset = .zero
        layer.shadowRadius = 5
        layer.shouldRasterize = true
        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
}
