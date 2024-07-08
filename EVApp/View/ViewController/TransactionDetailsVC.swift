//
//  TransactionDetailsVC.swift
//  EVApp
//
//  Created by Brijesh Bhardwaj on 23/06/23.
//

import UIKit
import Alamofire
import SwiftyJSON
import PDFKit

class TransactionDetailsVC: UIViewController {
    @IBOutlet weak var lblTrxID: UILabel!
    @IBOutlet weak var detailView: UIView!
    @IBOutlet weak var btnViewInvv: UIButton!
    @IBOutlet weak var btnGetInvoice: UIButton!
    @IBOutlet weak var lblTotalAmount: UILabel!
    @IBOutlet weak var lblGst2: UILabel!
    @IBOutlet weak var lblGst1: UILabel!
    @IBOutlet weak var lblSubTotal: UILabel!
    @IBOutlet weak var lblUnitConsumed: UILabel!
    @IBOutlet weak var lblTotalBatery: UILabel!
    @IBOutlet weak var lblFinalBatery: UILabel!
    @IBOutlet weak var lblInBatery: UILabel!
    @IBOutlet weak var lblTotalTime: UILabel!
    @IBOutlet weak var lblEndTime: UILabel!
    @IBOutlet weak var lblStartTime: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblSAdd: UILabel!
    @IBOutlet weak var lblSName: UILabel!
    
    var userTransactionId = String()
    var consUnit = Float()
    var isCommingFromTransactionList = false
    
    static func instantiateUsingStoryboard() -> Self {
        let vc = ViewControllerFactory<Self>.viewController(for: .ChargingInvoiceScreen)
        return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.detailView.layer.cornerRadius = 12
        self.btnViewInvv.layer.cornerRadius = 12
        self.btnGetInvoice.layer.cornerRadius = 12
        self.detailView.layer.borderColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        self.detailView.layer.borderWidth = 1
        
        self.lblUnitConsumed.text = String(consUnit)
        getTransactionApi()
    }
    @IBAction func back(_ sender: Any) {
        if isCommingFromTransactionList{
            self.dismiss(animated: false)
        }else{
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let nextViewController = MenuNavigation.instantiateUsingStoryboard()
            self.present(nextViewController, animated:true, completion:nil)
        }
    }
    
    @IBAction func getInvoice(_ sender: Any) {
        // saveInvoice(invoiceName: "Invoice", invoiceData: "Invoice")
        let invoiceUrl  = EndPoints.shared.baseUrlDev + EndPoints.shared.paymentInvoice + userTransactionId
        let fileName = "EVCharging-Invoice"
        self.savePdf(stringUrl: invoiceUrl, fileName: fileName)
    }
    
    @IBAction func viewInnvoice(_ sender: Any) {
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextVC = storyBoard.instantiateViewController(withIdentifier: "PDFWebViewController") as! PDFWebViewController
        nextVC.userTrxId = userTransactionId
        self.present(nextVC, animated:true, completion:nil)
    }
    func getTransactionApi(){
        let verifyOtp  = EndPoints.shared.baseUrlDev + EndPoints.shared.chargersTrxSummary
        let userPk = UserAppStorage.userPk
        LoadingOverlay.shared.showOverlay(view: view)
        let parameters = [
            "userTransactionId": userTransactionId
        ] as? [String:AnyObject]
        AF.request(verifyOtp, method: .post, parameters: parameters! as Parameters, encoding: JSONEncoding.default, headers: nil).responseJSON {
            response in
            LoadingOverlay.shared.hideOverlayView()
            
            switch (response.result) {
                
            case .success(let value):
                print(response)
                
                let statusCode = response.response?.statusCode
                print(statusCode!)
                
                let jsonData = JSON(value)
                print(jsonData)
                
                let startTime = jsonData["startTime"].stringValue
                let chargerId = jsonData["chargerId"].stringValue
                let date = jsonData["date"].stringValue
                let stationName = jsonData["stationName"].stringValue
                let endTime = jsonData["endTime"].stringValue
                let totalTime = jsonData["totalTime"].stringValue
                let initialBatteryLevel = jsonData["initialBatteryLevel"].stringValue
                let finalBatteryLevel = jsonData["finalBatteryLevel"].stringValue
                let totalBatteryCharged = jsonData["totalBatteryCharged"].stringValue
                let unitsConsumed = jsonData["unitsConsumed"].floatValue
                let subTotal = jsonData["subTotal"].floatValue
                let cgst = jsonData["cgst"].floatValue
                let sgst = jsonData["sgst"].floatValue
                let igst = jsonData["chargerId"].floatValue
                let totalAmountPaid = jsonData["totalAmountPaid"].floatValue
                let chargerAddress = jsonData["chargerAddress"].dictionaryValue
                let street = chargerAddress["street"]?.string
                self.lblTrxID.text  = chargerId
                self.lblDate.text  = date
                self.lblSName.text  = stationName
                self.lblSAdd.text  = street
                self.lblStartTime.text  = startTime
                self.lblEndTime.text  = endTime
                self.lblTotalTime.text  = totalTime
                self.lblInBatery.text  = initialBatteryLevel
                self.lblFinalBatery.text  = finalBatteryLevel
                self.lblTotalBatery.text  = totalBatteryCharged
                self.lblUnitConsumed.text  = String(unitsConsumed) + " kW"
                self.lblSubTotal.text  = "Rs: " + String(subTotal)
                self.lblGst1.text  = "Rs: " + String(cgst)
                self.lblGst2.text  = "Rs: " + String(sgst)
                self.lblTotalAmount.text  = "Rs: " + String(totalAmountPaid)
//                print(street)
                break
            case .failure:
                print(Error.self)
                
            }
        }
    }
    func viewInvoiceApi(){
        guard let userPk = UserAppStorage.userPk else { return }
        let invoiceUrl = EndPoints.shared.baseUrlDev + EndPoints.shared.paymentInvoice +  String(userPk)
        let headers:HTTPHeaders = [
            
        ]
        LoadingOverlay.shared.showOverlay(view: view)
        AF.request(invoiceUrl, method: .get, parameters: nil, encoding: URLEncoding.default, headers: headers).responseJSON {
            response in
            LoadingOverlay.shared.hideOverlayView()
            
            switch (response.result) {
                
            case .success(let value):
                print(response)
                
                let statusCode = response.response?.statusCode
//                print(statusCode)
                
                let jsonData = JSON(value)
                print(jsonData)
                let stationId = jsonData.arrayValue.map {$0["stationId"].stringValue}
                let stationTimings = jsonData.arrayValue.map {$0["stationTimings"].stringValue}
                let stationNameList = jsonData.arrayValue.map {$0["chargerInfos"].arrayValue.map {$0["name"].stringValue}}
                let nameList = jsonData.arrayValue.map {$0["chargerInfos"].arrayValue.first?["name"].stringValue}
                let street = jsonData.arrayValue.map {$0["stationChargerAddress"].dictionaryValue}.map {$0["street"]?.stringValue}
                print(street)
                
                
                break
            case .failure:
                print(Error.self)
                
            }
        }
    }
    fileprivate func getFilePath() -> URL? {
        let documentDirectoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let directoryURl = documentDirectoryURL.appendingPathComponent("Invoice", isDirectory: true)
        
        if FileManager.default.fileExists(atPath: directoryURl.path) {
            return directoryURl
        } else {
            do {
                try FileManager.default.createDirectory(at: directoryURl, withIntermediateDirectories: true, attributes: nil)
                return directoryURl
            } catch {
                print(error.localizedDescription)
                return nil
            }
        }
    }
    fileprivate func saveInvoice(invoiceName: String, invoiceData: String) {
        
        guard let directoryURl = getFilePath() else {
            print("Invoice save error")
            return }
        var url = "http://beta.greenvelocity.co.in:8080/cms/manager/rest/payment/invoice/pdf1/269"
        let fileURL = directoryURl.appendingPathComponent(url)
        
        guard let data = Data(base64Encoded: invoiceData, options: .ignoreUnknownCharacters) else {
            print("Invoice downloaded Error")
            //   self.hideHUD()
            return
        }
        
        do {
            try data.write(to: fileURL, options: .atomic)
            print("Invoice downloaded successfully")
        } catch {
            print(error.localizedDescription)
        }
    }
  
   
func savePdf(stringUrl: String,fileName:String) {
        if let url = URL(string: stringUrl) {
        URLSession.shared.dataTask(with: url) { (data, response, error) in
          // Error handling...
          guard let imageData = data else { return }

          DispatchQueue.main.async {
              let pdfData = imageData
              let resourceDocPath = (FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)).last! as URL
              let pdfNameFromUrl = "EVCharging-\(fileName).pdf"
              let actualPath = resourceDocPath.appendingPathComponent(pdfNameFromUrl)
              do {
                  try pdfData.write(to: actualPath, options: .atomic)
                  print("pdf successfully saved!")
                  self.showAlert(title: "EV Charging", message: "Invoice pdf successfully saved!")
 
              } catch {
                  print("Pdf could not be saved")
              }
          }
        }.resume()
      }
    }
}
