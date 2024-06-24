//
//  AvailableCouponVC.swift
//  EVApp
//
//  Created by Brijesh Bhardwaj on 12/06/23.
//

import UIKit
import SkyFloatingLabelTextField
import Alamofire
import SwiftyJSON


class AvailableCouponVC: UIViewController,UITableViewDelegate,UITableViewDataSource  {
    var couponCode = [""]
    var couponType  =  [""]
    var discountValue = [Int]()
    var expiry = [""]
    var minOrderValue = [""]
    var chargerBase = [""]

    
    @IBOutlet weak var lblDetails: UILabel!
    @IBOutlet weak var lblFor: UILabel!
    @IBOutlet weak var lblExpiryDate: UILabel!
    @IBOutlet weak var lblmMinAmt: UILabel!
    @IBOutlet weak var couponDetailsView: UIView!
    @IBOutlet weak var couponTable: UITableView!
    
     static func instantiateUsingStoryboard() -> Self {
         let availableCouponVc = ViewControllerFactory<AvailableCouponVC>.viewController(for: .AvailableCouponScreen)
         return availableCouponVc as! Self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        callCouponApi()
    }
    
    @IBAction func back(_ sender: Any) {
        self.dismiss(animated: true)
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return couponCode.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CouponTableViewCell", for: indexPath) as? CouponTableViewCell
        cell!.lblCouponCode.text! =  couponCode[indexPath.row]
        cell!.lblDetail.text! =  couponType[indexPath.row]
        return cell!
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 155
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//       let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
//        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "CoupopDetaliVC") as! CoupopDetaliVC
//        nextViewController.discountValue = self.discountValue[indexPath.row]
//        nextViewController.couponCode = self.couponCode[indexPath.row]
//        self.present(nextViewController, animated:true, completion:nil)
      
        
    }
    func callCouponApi(){
        let stateUrl = EndPoints.shared.baseUrlDev + EndPoints.shared.couponDetail
        let headers:HTTPHeaders = [
          
        ]
        LoadingOverlay.shared.showOverlay(view: view)
        AF.request(stateUrl, method: .get, parameters: nil, encoding: URLEncoding.default, headers: headers).responseJSON { [self]
                    response in
            LoadingOverlay.shared.hideOverlayView()

                    switch (response.result) {

                    case .success(let value):
                        print(response)
                        
                       let statusCode = response.response?.statusCode
                      print(statusCode)
                        
                let jsonData = JSON(value)
                        print(jsonData)
                      
                        let couponCode = jsonData.arrayValue.map {$0["couponCode"].stringValue}
                        let discountValue = jsonData.arrayValue.map {$0["discountValue"].intValue}
                        let minOrderValue = jsonData.arrayValue.map {$0["minOrderValue"].intValue}
                        let couponType = jsonData.arrayValue.map {$0["couponType"].stringValue}
                        let expiry = jsonData.arrayValue.map {$0["expiry"].stringValue}
                        let userBase = jsonData.arrayValue.map {$0["userBase"].stringValue}
                        self.discountValue  = discountValue
                        self.couponType = couponType
                        self.couponCode = couponCode
                        self.couponTable.reloadData()

                        break
                    case .failure:
                        print(Error.self)
                       
                    }
                }
    }

}
