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
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        chatView.addShadow()
        callView.addShadow()
        addressView.addShadow()
        writeView.addShadow()
    }
    
    @IBAction func back(_ sender: Any) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = MenuNavigation.instantiateFromStoryboard()
        self.present(nextViewController, animated:true, completion:nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

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
