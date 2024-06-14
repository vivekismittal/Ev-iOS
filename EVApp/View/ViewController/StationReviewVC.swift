//
//  StationReviewVC.swift
//  EVApp
//
//  Created by Brijesh Bhardwaj on 08/07/23.
//

import UIKit
import SkyFloatingLabelTextField
import Alamofire
import SwiftyJSON

class StationReviewVC: UIViewController,UITableViewDelegate,UITableViewDataSource {
    @IBOutlet weak var reviewView: UIView!
    @IBOutlet weak var btnStar5: UIButton!
    @IBOutlet weak var btnStar4: UIButton!
    @IBOutlet weak var btnStar3: UIButton!
    @IBOutlet weak var btnStar2: UIButton!
    @IBOutlet weak var btnStar1: UIButton!
    @IBOutlet weak var txtReview: UITextField!
    @IBOutlet weak var btnSubmit: UIButton!
    @IBOutlet weak var reviewTable: UITableView!
    var stationid = String()
    var firstName = [String]()
    var ratings = [String]()
    var comments = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.reviewView.isHidden = true
        self.btnStar1.tintColor = .lightGray
        self.btnStar2.tintColor = .lightGray
        self.btnStar3.tintColor = .lightGray
        self.btnStar4.tintColor = .lightGray
        self.btnStar5.tintColor = .lightGray
        callReviewApi()
    }
    @IBAction func back(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @IBAction func review(_ sender: Any) {
        callRatingApi()
        self.reviewView.isHidden = false
    }
    @IBAction func submit(_ sender: Any) {
        self.reviewView.isHidden = true
    }
    @IBAction func Star1(_ sender: Any) {
    }
    @IBAction func startAction1(_ sender: Any) {
       // btnStar1.setImage(UIImage(systemName: "star.fill"), for: .normal)
        self.btnStar1.tintColor = #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 1)
    }
    @IBAction func startAction2(_ sender: Any) {
        //btnStar2.setImage(UIImage(systemName: "star.fill"), for: .normal)
        self.btnStar2.tintColor = #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 1)
    }
    @IBAction func startAction3(_ sender: Any) {
       // btnStar3.setImage(UIImage(systemName: "star.fill"), for: .normal)
        self.btnStar3.tintColor = #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 1)
    }
    @IBAction func startAction4(_ sender: Any) {
        //btnStar4.setImage(UIImage(systemName: "star.fill"), for: .normal)
        self.btnStar4.tintColor = #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 1)
    }
    @IBAction func startAction5(_ sender: Any) {
        //btnStar5.setImage(UIImage(systemName: "star.fill"), for: .normal)
        self.btnStar5.tintColor = #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 1)
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.firstName.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "StationReviewCell", for: indexPath) as? StationReviewCell
       cell?.lblUserName.text! = firstName[indexPath.row]
        cell?.lblReview.text! = comments[indexPath.row]
        return cell!
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 130
    }
    
   

}
extension StationReviewVC{
    func callReviewApi(){
        let amountUnit = EndPoints.shared.baseUrlDev + EndPoints.shared.userReviewRating
        let userPk = UserAppStorage.userPk
        let chrBoxId =  UserAppStorage.chrgBoxId
        LoadingOverlay.shared.showOverlay(view: view)
        let parameters = [
            "stationId": stationid
        ] as? [String:AnyObject]
        print(parameters)
        AF.request(amountUnit, method: .post, parameters: parameters! as Parameters, encoding: JSONEncoding.default, headers: nil).responseJSON {
            response in
            LoadingOverlay.shared.hideOverlayView()
            
            switch (response.result) {
                
            case .success(let value):
                print(response)
                
                let statusCode = response.response?.statusCode
                print(statusCode!)
                
                let jsonData = JSON(value)
                print(jsonData)
                
                let status = jsonData["status"].boolValue
                let rating = jsonData["rating"].stringValue
                let comment = jsonData["comment"].arrayValue
                let firstName = comment.map {$0["firstName"].stringValue}
                let ratings = comment.map {$0["rating"].stringValue}
                let comments = comment.map {$0["comment"].stringValue}
                self.firstName =  firstName
                self.ratings =  ratings
                self.comments =  comments
                
                self.reviewTable.reloadData()

                break
            case .failure:
                print(Error.self)
                
            }
        }
    }
    func callRatingApi(){
        let amountUnit = EndPoints.shared.baseUrlDev + EndPoints.shared.userReviewWriting
        let userPk = UserAppStorage.userPk
        LoadingOverlay.shared.showOverlay(view: view)
        let parameters = [
            "userPK": userPk,
            "stationId":stationid,
            "rating": "4.5",
            "comment": "Very good service provider",
            
        ] as? [String:AnyObject]
        print(parameters)
        AF.request(amountUnit, method: .post, parameters: parameters! as Parameters, encoding: JSONEncoding.default, headers: nil).responseJSON {
            response in
            LoadingOverlay.shared.hideOverlayView()
            
            switch (response.result) {
                
            case .success(let value):
                print(response)
                
                let statusCode = response.response?.statusCode
                print(statusCode!)
                
                let jsonData = JSON(value)
                print(jsonData)
                
                break
            case .failure:
                print(Error.self)
                
            }
        }
    }
}
