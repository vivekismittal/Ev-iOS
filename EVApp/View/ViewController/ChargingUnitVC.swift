//
//  ChargingUnitVC.swift
//  EVApp
//
//  Created by Brijesh Bhardwaj on 30/05/23.
//  Corrected by Vivek Mittal

import UIKit

class ChargingUnitVC: UIViewController {
    @IBOutlet weak var imgConnectorType: UIImageView!
    @IBOutlet weak var lblConnName: UILabel!
    @IBOutlet weak var lblStationAdd: UILabel!
    @IBOutlet weak var lblStationName: UILabel!
    @IBOutlet weak var detailsView: UIView!
    @IBOutlet weak var couponView: UIView!
    @IBOutlet weak var waletView: UIView!
    @IBOutlet weak var lblTotalTax: UILabel!
    @IBOutlet weak var lblDiscountValue: UILabel!
    @IBOutlet weak var lblOrderAmt: UILabel!
    @IBOutlet weak var lblUnit: UILabel!
    @IBOutlet weak var txtCoupon: UITextField!
    @IBOutlet weak var lblWaletAmt: UILabel!
    @IBOutlet weak var btnNext: UIButton!
    @IBOutlet weak var lblNote: UILabel!
    @IBOutlet weak var lbUnit: UILabel!
    
   private var orderAmount = Float() {
        didSet{
            self.lblOrderAmt.text =  orderAmount.rupeeString(withPrecision: 1)
            self.lblTotalTax.text =  orderAmount.rupeeString(withPrecision: 1)
            self.lblDiscountValue.text =  0.rupeeString()
        }
    }
    
    private var startChargingType: StartChargingType!
    private var chargingUnitViewModel: ChargingUnitViewModel!
    
   private var walletAmount = Float() {
        didSet{
            self.lblWaletAmt.text = walletAmount.rupeeString()
        }
    }
    
    private var energyInWatts = Float(){
        didSet{
            lblUnit.text = energyInWatts.precisedString(upTo: 1) + " kWH"
        }
    }
    
    private var chargingTime = Int(){
        didSet{
            self.lbUnit.text = "Time"
            self.lblUnit.text = "\(chargingTime) Min"
        }
    }
    
    var chargerBoxId:String = ""
    var connName = ""
    var stationName = ""
    var stationAddress = ""
    var connectorType = ""
    var parkingPrice = 0
    private var chargingQuantity: Int!
    
    static func instantiateUsingStoryboard(with chargingType: StartChargingType,_ quantity: Int) -> Self {
        let chargingUnitVC = ViewControllerFactory<Self>.viewController(for: .ChargingEstimationScreen)
        chargingUnitVC.startChargingType = chargingType
        chargingUnitVC.chargingQuantity = quantity
        chargingUnitVC.chargingUnitViewModel = ChargingUnitViewModel()
        return chargingUnitVC
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setViews()
        getWalletAmount()
        getChargingAmountBasedOnType()
    }
    
    fileprivate func setViews() {
        self.btnNext.layer.cornerRadius = 12
        self.waletView.layer.cornerRadius = 12
        self.couponView.layer.cornerRadius = 12
        self.detailsView.layer.cornerRadius = 16
        self.waletView.layer.borderWidth = 1
        self.waletView.layer.borderColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        self.couponView.layer.borderWidth = 1
        self.couponView.layer.borderColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        self.detailsView.layer.borderWidth = 1
        self.detailsView.layer.borderColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        self.lblNote.text = "Note: Parking chargers of \(parkingPrice.rupeeString())/hr will be charged after the transaction."
        if connectorType == "DC" {
            imgConnectorType.image = UIImage(named: "dc")
        } else {
            imgConnectorType.image = UIImage(named: "ac")
        }
        self.lblConnName.text =  "Connector ID: " + connName
        self.lblStationName.text = stationName
        self.lblStationAdd.text = stationAddress
    }
    
    @IBAction func back(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @IBAction func next(_ sender: Any) {
        if walletAmount > orderAmount{
            let nextViewController = StartChargingVC.instantiateUsingStoryboard(with: chargingUnitViewModel)
            nextViewController.connName = connName
            nextViewController.orderChargingAmount = orderAmount
            nextViewController.orderChargingUnitInWatt = energyInWatts
            nextViewController.chargerBoxId = chargerBoxId
            if startChargingType == .Time{
                nextViewController.timeBasedCharging = true
                nextViewController.chargingTimeInMinutes = chargingQuantity
            }
            self.present(nextViewController, animated:true, completion:nil)
        } else{
            let nextViewController = AddMoneyVC.instantiateUsingStoryboard()
            self.present(nextViewController, animated:true, completion:nil)
        }
        
    }
    
    @IBAction func applyCoupon(_ sender: Any) {}
    
    @IBAction func viewCoupon(_ sender: Any) {
        let nextViewController = AvailableCouponVC.instantiateUsingStoryboard()
        self.present(nextViewController, animated:true, completion:nil)
    }
    
    func getWalletAmount(){
        LoadingOverlay.shared.showOverlay(view: view)
        chargingUnitViewModel.getWalletAmount{ [weak self] res in
            DispatchQueue.main.async {
                LoadingOverlay.shared.hideOverlayView()
            }
            switch res{
            case .success(let amount):
                DispatchQueue.main.async {
                    self?.walletAmount = amount
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func getChargingAmountBasedOnType(){
        LoadingOverlay.shared.showOverlay(view: view)
        chargingUnitViewModel.getChargingAmountBasedOnType(quantity: chargingQuantity,type: startChargingType,chargerBoxId: chargerBoxId,isCorporateUser: false,connectorName: connName){[weak self] res in
            DispatchQueue.main.async {
                LoadingOverlay.shared.hideOverlayView()
            }
            switch res{
            case .success(let chargingTimeAmount):
                DispatchQueue.main.async {
                    self?.orderAmount = chargingTimeAmount.amount ?? 0
                    self?.energyInWatts = chargingTimeAmount.energyInWatts ?? 0
                    if self?.startChargingType == .Time, let time = self?.chargingQuantity{
                        self?.chargingTime = time
                    }
                }
            case .failure(let error):
                print(error)
            }
        }
    }
}
