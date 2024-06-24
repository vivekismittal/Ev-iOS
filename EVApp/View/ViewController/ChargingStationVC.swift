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
    @IBOutlet weak var lblType: UILabel!
    @IBOutlet weak var lblConName: UILabel!
    @IBOutlet weak var lblLocation: UILabel!
    @IBOutlet weak var lblStationName: UILabel!
    @IBOutlet weak var textField: SkyFloatingLabelTextField!
    @IBOutlet weak var defaultValueOptionsStack: UIStackView!
    @IBOutlet weak var chargeTypeStack: UIStackView!
    @IBOutlet weak var btnNext: UIButton!
    
    private var chargerConnectorInfo: ChargerStationConnectorInfos!
    private var orderAmount = 0
    private var startChargingType: StartChargingType = .Power
    private var stationName = ""
    private var stationAddress = ""
    
    static func instantiateUsingStoryboard(with chargerConnectorInfo: ChargerStationConnectorInfos, chargerInfoName: String, streetAddress: String) -> Self {
        let chargingStationVC = ViewControllerFactory<Self>.viewController(for: .ChargingStationScreen)
        chargingStationVC.chargerConnectorInfo = chargerConnectorInfo
        chargingStationVC.stationName = chargerInfoName
        chargingStationVC.stationAddress = streetAddress
        return chargingStationVC
    }
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.lblConName.text = "Connector ID: \(chargerConnectorInfo.connectorNo ?? "NA")"
        self.lblType.text = "Charger Id: \( chargerConnectorInfo.stationId ?? "NA")"
        self.btnNext.layer.cornerRadius = 12
        lblStationName.text = stationName
        lblLocation.text = stationAddress
        addAllStartChargingTypeInStack()
        textField.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.lblConName.text = "Connector ID: \(chargerConnectorInfo.connectorNo ?? "NA")"
        self.lblType.text = "Charger Id: \(chargerConnectorInfo.stationId ?? "NA")"
        self.btnNext.layer.cornerRadius = 12
        lblStationName.text = stationName
        lblLocation.text = stationAddress
        if chargerConnectorInfo.connectorType == "DC" {
            imgChargerType.image = UIImage(named: "dc")
        } else{
            imgChargerType.image = UIImage(named: "ac")
        }
    }
    
    private func addAllStartChargingTypeInStack(){
        for view in chargeTypeStack.arrangedSubviews {
            chargeTypeStack.removeArrangedSubview(view)
            view.removeFromSuperview()
        }
        
        chargeTypeStack.distribution = .fillEqually
        chargeTypeStack.alignment = .fill
        
        StartChargingType.allCases.forEach { chargeType in
            addOptionInStack(title: chargeType.rawValue, in: chargeTypeStack){[weak self] in                self?.selectChargeType(chargeType)
                self?.updateBackgroundForChargeTypeOption(chargeType)
            }
        }
        updateBackgroundForChargeTypeOption(startChargingType)
    }
    
    fileprivate func selectChargeType(_ chargeType: StartChargingType) {
        startChargingType = chargeType
        updateDefaultValueOptionsList()
        
        if let value = chargeType.getDefaultValuesOptions().first{
            orderAmount = value
        }
        self.textField.text  =  String(orderAmount)
        
        switch chargeType{
        case .Power:
            self.textField.title = "Power(kWh)"
            self.textField.placeholder = "Power(kWh)"
            
        case .Amount:
            self.textField.title = "Amount(₹)"
            self.textField.placeholder = "Amount(₹)"
            
        case .Time:
            self.textField.title = "Time(Min)"
            self.textField.placeholder = "Time(Min)"
        }
    }
    
    private func updateBackgroundForChargeTypeOption(_ type: StartChargingType){
        chargeTypeStack.arrangedSubviews.forEach { arrangedSubview in
            if let buttonView = arrangedSubview as? UIButton, let chargeType = StartChargingType(rawValue: buttonView.currentTitle ?? ""){
                if chargeType == type{
                    buttonView.backgroundColor = #colorLiteral(red: 0.4901960784, green: 0.7882352941, blue: 0, alpha: 1)
                } else{
                    buttonView.backgroundColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
                }
            }
        }
    }
    
    private func updateDefaultValueOptionsList(){
        for view in defaultValueOptionsStack.arrangedSubviews {
            defaultValueOptionsStack.removeArrangedSubview(view)
            view.removeFromSuperview()
        }
        
        defaultValueOptionsStack.distribution = .fillEqually
        defaultValueOptionsStack.alignment = .fill
        
        startChargingType.getDefaultValuesOptions().forEach { value in
            let title = switch startChargingType {
            case .Power:
                "\(value) kWH"
            case .Amount:
                "₹\(value)"
            case .Time:
                "\(value) Min"
            }
            addOptionInStack(title: title, in: defaultValueOptionsStack, onClick: {[weak self] in
                self?.orderAmount = value
                self?.textField.text = String(self?.orderAmount ?? 0)
            })
        }
    }
    
    private func addOptionInStack(title: String,in stackView: UIStackView, onClick: @escaping ()->()){
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        
        if let chargeType = StartChargingType(rawValue: title){
            if chargeType == startChargingType{
                selectChargeType(chargeType)
            }
        } else {
            button.backgroundColor = #colorLiteral(red: 0.4901960784, green: 0.7882352941, blue: 0, alpha: 1)
        }
        
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 8
        button.setOnClickListener {
            onClick()
        }
        stackView.addArrangedSubview(button)
    }
    
    @IBAction func back(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @IBAction func next(_ sender: Any) {
        guard let intVal = Int(textField.text ?? "0") else { return }
        let nextViewController = ChargingUnitVC.instantiateUsingStoryboard(with: startChargingType,intVal)
        
        switch startChargingType {
        case .Power:
            if intVal < 5{
                return showAlert(title: "Yahhvi", message: "Power must be at least 5kWh.")
            }
            if intVal > 100{
                return  showAlert(title: "Yahhvi", message: "Power must be less than 100kWh.")
            }
            
        case .Time:
            if intVal < 15{
                return  showAlert(title: "Yahhvi", message: "Time must be at least 15 Mins.")
            }
            if intVal > 600{
                return showAlert(title: "Yahhvi", message: "Time must be less than 10 Hours. ")
            }
            
        case .Amount:
            if intVal < 100 {
                return showAlert(title: "Yahhvi", message: "Amount must be at least ₹100.")
            }
            if intVal > 2000{
                return showAlert(title: "Yahhvi", message: "Amount must be less than ₹2000.")
            }
        }
        nextViewController.connName = chargerConnectorInfo.connectorNo ?? "NA"
        nextViewController.chargerBoxId = chargerConnectorInfo.chargeBoxId ?? "NA"
        nextViewController.stationName = stationName
        nextViewController.stationAddress = stationAddress
        nextViewController.parkingPrice = chargerConnectorInfo.parkingPrice ?? 0
        self.present(nextViewController,animated: true,completion: nil)
    }
}

extension ChargingStationVC: UITextFieldDelegate{
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let allowedCharacters = CharacterSet.decimalDigits
        let characterSet = CharacterSet(charactersIn: string)
        return allowedCharacters.isSuperset(of: characterSet)
    }
}

enum StartChargingType: String, CaseIterable{
    case Power
    case Amount
    case Time
    
    func getDefaultValuesOptions()->[Int]{
        return switch self {
        case .Power:
            [10,20,30,40]
        case .Time:
            [15,30,60,120]
        case .Amount:
            [300,500,700,1000]
        }
    }
}
