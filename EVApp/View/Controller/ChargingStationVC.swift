//
//  ChargingStationVC.swift
//  EVApp
//
//  Created by Brijesh Bhardwaj on 26/05/23.
//

import UIKit
import SkyFloatingLabelTextField


class ChargingStationVC: UIViewController {

    @IBOutlet weak var imgChargerType: UIImageView!
    //    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblType: UILabel!
    @IBOutlet weak var lblConName: UILabel!
    @IBOutlet weak var lblLocation: UILabel!
    @IBOutlet weak var lblStationName: UILabel!
    @IBOutlet weak var textField: SkyFloatingLabelTextField!
    @IBOutlet weak var amountStack: UIStackView!
    @IBOutlet weak var poweStack: UIStackView!
    @IBOutlet weak var btnNext: UIButton!
    @IBOutlet weak var amountView: UIView!
    @IBOutlet weak var powerVIew: UIView!
    @IBOutlet weak var timeView: UIView!
    @IBOutlet weak var btn120Min: UIButton!
    
    @IBOutlet weak var amountView4: UIView!
    @IBOutlet weak var amountView3: UIView!
    @IBOutlet weak var amountView2: UIView!
    @IBOutlet weak var amountView1: UIView!
    // Amount button
    @IBOutlet weak var amountButton1: UIButton!
    @IBOutlet weak var amountButton2: UIButton!
    @IBOutlet weak var amountButton3: UIButton!
    @IBOutlet weak var amountButton4: UIButton!
    
    @IBOutlet weak var powerView4: UIView!
    @IBOutlet weak var powerView3: UIView!
    @IBOutlet weak var powerView2: UIView!
    @IBOutlet weak var powerView1: UIView!
    var orderAmount = 0
  //  var power = 10
    var amtFlag = false
    var unitFlag = false
    var timeFlag = false
    var stationName = ""
    var stationAddress = ""
    var connName = String()
    var stationId = String()
    var type = ""
    var price = ""
    var parkingPrice = ""
    var chargerBoxId:String = ""
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.lblConName.text = "Connector ID: " + connName
        self.lblType.text = "Charger Id: " + stationId
//        self.lblPrice.text = "Rs:" + price + "/Unit"
        self.btnNext.layer.cornerRadius = 12
        lblStationName.text = stationName
        lblLocation.text = stationAddress
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.textField.placeholder = "Power(kWh)"
        //self.textField.placeholder = "First name"
        self.textField.title = "Power(kWh)"
        self.amountStack.isHidden = true
        self.poweStack.isHidden = false
        self.textField.text  = "10"
        self.unitFlag = true
        self.amtFlag = false
        self.timeFlag = false
        
        self.orderAmount = 10
        self.amountView.layer.cornerRadius = 12
        self.timeView.layer.cornerRadius = 12
        self.powerVIew.layer.cornerRadius = 12
        amountView.backgroundColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        timeView.backgroundColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        powerVIew.backgroundColor = #colorLiteral(red: 0.4901960784, green: 0.7882352941, blue: 0, alpha: 1)
        powerView1.layer.cornerRadius = 8
        powerView2.layer.cornerRadius = 8
        powerView3.layer.cornerRadius = 8
        powerView4.layer.cornerRadius = 8
        amountView1.layer.cornerRadius = 8
        amountView2.layer.cornerRadius = 8
        amountView3.layer.cornerRadius = 8
        amountView4.layer.cornerRadius = 8
        self.lblConName.text = "Connector ID:" + connName
        self.lblType.text = "Charger Id: " + stationId
//        self.lblPrice.text = "Rs:" + price + "/Unit"
        self.btnNext.layer.cornerRadius = 12
        lblStationName.text = stationName
        lblLocation.text = stationAddress
        if type == "DC" {
            imgChargerType.image = UIImage(named: "dc")
        }else {
            imgChargerType.image = UIImage(named: "ac")
        }
        
    }
    
    // MARK: - Action Method
    
    @IBAction func back(_ sender: Any) {
        self.dismiss(animated: true)
    }
    @IBAction func next(_ sender: Any) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "ChargingUnitVC") as! ChargingUnitVC
        
        var intVal = Int(textField.text ?? "0")!
        
        if amtFlag == true{
            //nextViewController.orderAmount = self.orderAmount
            if intVal < 100 {
                showAlert(title: "Yahhvi", message: "Amount must be at least ₹100. ")
            }else if intVal > 2000{
                showAlert(title: "Yahhvi", message: "Amount must be less than ₹2000. ")
            }else{
                nextViewController.orderAmount = Int(textField.text!) ?? 0
                nextViewController.amountFlag = true
            }
            
        }else if unitFlag == true{
           // nextViewController.orderAmount = self.orderAmount
            if intVal < 5{
                showAlert(title: "Yahhvi", message: "Power must be at least 5kWh. ")
            }else if intVal > 100{
                showAlert(title: "Yahhvi", message: "Power must be less than 100kWh. ")
            }
            else{
                nextViewController.orderAmount = Int(textField.text!) ?? 0
                nextViewController.unitsFlag = true
            }
            
        }else if timeFlag == true {
            if intVal < 15{
                showAlert(title: "Yahhvi", message: "Time must be at least 15 Mins. ")
            }else if intVal > 600{
                showAlert(title: "Yahhvi", message: "Time must be less than 10 Hours. ")
            }else{
                nextViewController.timeFlag = true
                nextViewController.timeInMinutes = textField.text ?? "0"
            }
            
        }
        
        nextViewController.connName = connName
        nextViewController.chargerBoxId = chargerBoxId
        nextViewController.stationName = stationName
        nextViewController.stationAddress = stationAddress
        nextViewController.parkingPrice = parkingPrice
        self.present(nextViewController, animated:true, completion:nil)
    }
    
    @IBAction func power(_ sender: Any) {
        self.textField.title = "Power(kWh)"
        self.textField.placeholder = "Power(kWh)"
        unitFlag = true
        amtFlag = false
        timeFlag = false
        self.orderAmount = 10
        self.amountStack.isHidden = true
        self.poweStack.isHidden = false
        self.textField.text  =  String(orderAmount)
        amountView.backgroundColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        timeView.backgroundColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        powerVIew.backgroundColor = #colorLiteral(red: 0.4901960784, green: 0.7882352941, blue: 0, alpha: 1)
    }
    @IBAction func amount(_ sender: Any) {
        self.textField.title = "Amount(₹)"
        self.textField.placeholder = "Amount(₹)"
        amtFlag = true
        unitFlag = false
        timeFlag = false
        changeAmountAndTime()
        self.orderAmount = 500
        amountView.backgroundColor = #colorLiteral(red: 0.4901960784, green: 0.7882352941, blue: 0, alpha: 1)
        timeView.backgroundColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        powerVIew.backgroundColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        self.amountStack.isHidden = false
        self.poweStack.isHidden = true
        self.textField.text  = String(orderAmount)
    }
    @IBAction func time(_ sender: Any) {
        self.textField.title = "Time(Min)"
        self.textField.placeholder = "Time(Min)"
        amtFlag = false
        unitFlag = false
        timeFlag = true
        changeAmountAndTime()
        self.orderAmount = 15
        timeView.backgroundColor = #colorLiteral(red: 0.4901960784, green: 0.7882352941, blue: 0, alpha: 1)
        amountView.backgroundColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        powerVIew.backgroundColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        self.amountStack.isHidden = false
        self.poweStack.isHidden = true
        self.textField.text  = String(orderAmount)
    }
    
    func changeAmountAndTime(){
        if timeFlag {
            amountButton1.setTitle("15 Min", for: .normal)
            amountButton2.setTitle("30 Min", for: .normal)
            amountButton3.setTitle("60 Min", for: .normal)
            amountButton4.setTitle("120 Min", for: .normal)
        } else {
            amountButton1.setTitle("₹500", for: .normal)
            amountButton2.setTitle("₹1000", for: .normal)
            amountButton3.setTitle("₹1500", for: .normal)
            amountButton4.setTitle("₹2000", for: .normal)
        }
    }
    @IBAction func power1(_ sender: Any) {
        self.orderAmount = 10
        self.textField.text  =  String(orderAmount)
    }
    @IBAction func power2(_ sender: Any) {
        self.orderAmount = 20
        self.textField.text  = String(orderAmount)
    }
    @IBAction func power3(_ sender: Any) {
        self.orderAmount = 30
        self.textField.text  = String(orderAmount)
    }
    @IBAction func power4(_ sender: Any) {
        self.orderAmount = 40
        self.textField.text  = String(orderAmount)
    }
    @IBAction func amount1(_ sender: Any) {
        if timeFlag{
            self.orderAmount = 15
        }else{
            self.orderAmount = 500
        }
        self.textField.text  =  String(orderAmount)
        changeAmountAndTime()
    }
    @IBAction func amount2(_ sender: Any) {
        if timeFlag{
            self.orderAmount = 30
        }else{
            self.orderAmount = 1000
        }
        self.textField.text  =   String(orderAmount)
        changeAmountAndTime()
    }
    @IBAction func amount3(_ sender: Any) {
        if timeFlag{
            self.orderAmount = 60
        }else{
            self.orderAmount = 1500
        }
        self.textField.text  =  String(orderAmount)
        changeAmountAndTime()
    }
    @IBAction func amount4(_ sender: Any) {
        if timeFlag{
            self.orderAmount = 120
        }else{
            self.orderAmount = 2000
        }
        self.textField.text  =  String(orderAmount)
        changeAmountAndTime()
    }
        func applyShadowOnButton(_ button: UIButton) {
            view.layer.cornerRadius = 18
            view.center = self.view.center
            view.backgroundColor = #colorLiteral(red: 0.4901960784, green: 0.7882352941, blue: 0, alpha: 1)
            view.layer.shadowColor = UIColor.gray.cgColor
            view.layer.shadowOpacity = 0.8
            view.layer.shadowOffset = CGSize.zero
            view.layer.shadowRadius = 5
    
        }
}
