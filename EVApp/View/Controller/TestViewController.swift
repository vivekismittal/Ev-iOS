//
//  TestViewController.swift
//  EVApp
//
//  Created by Brijesh Bhardwaj on 02/06/23.
//

import UIKit
import Foundation
import PayUBizCoreKit
import PayUCheckoutProBaseKit
import PayUCheckoutProKit
import PayUParamsKit


class TestViewController: UIViewController {
  
    // MARK: - Variables -

    let keySalt = [
        ["XpvgUb", "6PUiBWV9ifmIlGhabPPzkcOoApqWRkqQ", Environment.production],
        ["gtKFFx", "<Please enter your salt here>", Environment.test]
    ]

    let indexKeySalt = 0
    var amount: String = "1"

    var productInfo: String = "Nokia"
    var surl: String = "https://payu.herokuapp.com/ios_success"
    var furl: String = "https://payu.herokuapp.com/ios_failure"
    var firstName: String = "Umang"
    var email: String = "umang@arya.com"
    var phoneNumber: String = "9876543210"
    var userCredential: String = "umang:arya123"
    var primaryColor: String = "#25272C"
    var secondaryColor: String = "#ffffff"
    var merchantName: String = "Gabbar"
    var logoName: String = "Logo"
    var showCancelDialogOnCheckoutScreen: Bool = true
    var showCancelDialogOnPaymentScreen: Bool = true
    var orderDetail: String = "[{\"GST\":\"5%\"},{\"Delivery Date\":\"25 Dec\"},{\"Status\":\"In Progress\"}]"
    var l1Option: String = "[{\"NetBanking\":\"\"},{\"BNPL\":\"\"},{\"EMI\":\"\"},{\"UPI\":\"TEZ\"},{\"Wallet\":\"PHONEPE\"}]"
    var offerDetail: String = "[[\"Cashback on cards and netbanking\",\"Cashback on cards and netbanking\",\"CardsOfferKey@11311\",\"Cards,NetBanking\"],]"
    var customNotes: String = "[{\"Hi, This is a custom note for payment modes.\":[]},{\"Hi, This is a custom note for payment options.\":[\"Cards\",\"NetBanking\",\"upi\",\"Wallet\",\"Sodexo\",\"NeftRtgs\",\"EMI\",\"SavedCard\"]}]"
    var splitPayRequest: String = "{\"type\":\"absolute\",\"splitInfo\":{\"imAJ7I\":{\"aggregatorSubTxnId\":\"Testchild123\",\"aggregatorSubAmt\":\"5\"},\"qOoYIv\":{\"aggregatorSubTxnId\":\"Testchild098\",\"aggregatorSubAmt\":\"5\"}}}"
    var autoOTPSelect: Bool = true
    var userToken: String = "anshul_bajpai_token"
    var merchantResponseTimeout: String = "4"
    var sodexoResponseTimeout: String = "4"
    var recurringAmount = "1"
    var recurringPeriod: PayUBillingCycle = .monthly
    var siStartDate: Date = .init()
    var siEndDate: Date = .init()
    var billingInterval = "1"
    var isFreeTrial = false
    var remarksText: String? = nil
    var datePicker: UIDatePicker!
    let toolBar = UIToolbar()
    var merchantAccessKey: String = "E5ABOXOWAAZNXB6JEF5Z"
    let merchantSecretKey = "e425e539233044146a2d185a346978794afd7c66"
    let sodexoSourceId = "src_b0d97b32-3900-421a-bc25-5c9924dbc171"


    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    @IBAction func checkout(_ sender: Any) {
        let payUConfig = PayUCheckoutProConfig()
        addCheckoutProConfigurations(config: payUConfig)
        PayUCheckoutPro.open(on: self, paymentParam: getPaymentParam(), config: payUConfig, delegate: self)
    }
//
//    private func setUpValuesInTextFields() {
//        keyTextField.text = keySalt[indexKeySalt][0] as? String
//        saltTextField.text = keySalt[indexKeySalt][1] as? String
//        amountTextField.text = amount
//        productInfoTextField.text = productInfo
//        surlTextField.text = surl
//        furlTextField.text = furl
//        firstNameTextField.text = firstName
//        emailTextField.text = email
//        phoneTextField.text = phoneNumber
//        environmentTextField.text = Utils.stringyfy(environment: keySalt[indexKeySalt][2] as? Environment)
//        userCredentialTextField.text = userCredential
//        primaryColorTextField.text = primaryColor
//        secondaryColorTextField.text = secondaryColor
//        merchantNameTextField.text = merchantName
//        logoNameTextField.text = logoName
//        showCancelDialogOnCheckoutScreenSwitch.isOn = showCancelDialogOnCheckoutScreen
//        showCancelDialogOnPaymentScreenSwitch.isOn = showCancelDialogOnPaymentScreen
//        orderDetailTextView.text = orderDetail
//        l1OptionTextView.text = l1Option
//        offerDetailTextView.text = offerDetail
//        customNotesDetailTextView.text = customNotes
//        autoOTPSelectSwitch.isOn = autoOTPSelect
//        userTokenTextField.text = userToken
//        merchantResponseTimeoutTextField.text = merchantResponseTimeout
//        sodexoCardBalanceAPITimeoutTextField.text = sodexoResponseTimeout
//        recurringAmountTf.text = recurringAmount
//        recurringPeriodTf.text = PPKUtils.billingCycleToString(recurringPeriod)
//        billingIntervalTf.text = billingInterval
//        remarksTextField.text = remarksText
//        freeTrialSwitch.isOn = isFreeTrial
//        primaryColorTextFieldTapped()
//        secondaryColorTextFieldTapped()
//        merchantAccessKeyTextField.text = merchantAccessKey
//        merchantSecretKeyTextField.text = merchantSecretKey
//        sodexoCardSourceIdTextField.text = sodexoSourceId
//        splitPayTF.text = splitPayRequest
//    }
//
//    private func getPaymentParam() -> PayUPaymentParam {
//        let paymentParam = PayUPaymentParam(
//            key: keyTextField.text ?? "",
//            transactionId: txnIDTextField.text ?? "",
//            amount: amountTextField.text ?? "",
//            productInfo: productInfoTextField.text ?? "",
//            firstName: firstNameTextField.text ?? "",
//            email: emailTextField.text ?? "",
//            phone: phoneTextField.text ?? "",
//            surl: surlTextField.text ?? "",
//            furl: furlTextField.text ?? "",
//            environment: Utils.environment(environment: environmentTextField.text ?? "")
//        )
//        if let recurringAmount = recurringAmountTf.text,
//           let frequency = billingIntervalTf.text,
//           let frequencyInt = Int(frequency),
//           siSwitch.isOn {
//            let siInfo = PayUSIParams(
//                billingAmount: recurringAmount,
//                paymentStartDate: siStartDate,
//                paymentEndDate: siEndDate,
//                billingCycle: recurringPeriod,
//                billingInterval: NSNumber(value: frequencyInt)
//            )
//            siInfo.remarks = remarksTextField.text?.isEmpty ?? true ? nil : remarksTextField.text
//            siInfo.isFreeTrial = freeTrialSwitch.isOn
//
//            siInfo.billingLimit = "ON"
//            siInfo.billingRule = "MAX"
//
//            paymentParam.siParam = siInfo
//        }
//        if splitPaySwitch.isOn {
//            paymentParam.splitPaymentDetails = splitPayTF.text
//        }
//        paymentParam.userCredential = userCredentialTextField.text
//        paymentParam.enableNativeOTP = enableNativeOTPSwitch.isOn
//        paymentParam.additionalParam[PaymentParamConstant.udf1] = "udf11"
//        paymentParam.additionalParam[PaymentParamConstant.udf2] = "udf22"
//        paymentParam.additionalParam[PaymentParamConstant.udf3] = "udf33"
//        paymentParam.additionalParam[PaymentParamConstant.udf4] = "udf44"
//        paymentParam.additionalParam[PaymentParamConstant.udf5] = "udf55"
//        paymentParam.additionalParam[PaymentParamConstant.merchantAccessKey] = merchantAccessKeyTextField.text ?? ""
//        paymentParam.userToken = userTokenTextField.text
//
//        paymentParam.additionalParam[PaymentParamConstant.sourceId] = sodexoCardSourceIdTextField.text
//
//        return paymentParam
//    }
//    private func addCheckoutProConfigurations(config: PayUCheckoutProConfig) {
//        config.merchantName = merchantNameTextField.text
//        config.merchantLogo = UIImage(named: logoNameTextField.text ?? "")
//        config.paymentModesOrder = getPreferredPaymentMode()
//        config.cartDetails = cartDetails()
//        if let primary = Utils.hexStringToUIColor(hex: primaryColorTextField.text ?? ""), let secondary = Utils.hexStringToUIColor(hex: secondaryColorTextField.text ?? "") {
//            config.customiseUI(primaryColor: primary, secondaryColor: secondary)
//        }
//        config.showExitConfirmationOnPaymentScreen = showCancelDialogOnPaymentScreenSwitch.isOn
//        config.showExitConfirmationOnCheckoutScreen = showCancelDialogOnCheckoutScreenSwitch.isOn
//
//        // CB Configurations
//        config.autoSelectOtp = autoOTPSelectSwitch.isOn
//        config.autoSubmitOtp = autoOTPSubmitSwitch.isOn
//        if let merchantResponseTimeoutStr = merchantResponseTimeoutTextField.text,
//           let merchantResponseTimeout = TimeInterval(merchantResponseTimeoutStr) {
//            config.merchantResponseTimeout = merchantResponseTimeout
//        }
//
//        // Sodexo Configurations
//        if let sodexoCardBalanceAPITimeoutStr = sodexoCardBalanceAPITimeoutTextField.text,
//           let sodexoCardBalanceAPITimeout = TimeInterval(sodexoCardBalanceAPITimeoutStr) {
//            config.sodexoCardBalanceAPITimeout = sodexoCardBalanceAPITimeout
//        }
//
//        // Custom Notes Configurations
//        config.customNotes = getCustomNotes()
//
//        // Custom Notes Configurations
//        if enableEnforcementSwitch.isOn {
//            config.enforcePaymentList = getEnforcePaymentModesList()
//        }
//
//    }
//
//    func getEnforcePaymentModesList() -> [[String: Any]]? {
//        var enforcePaymentList = [[String: Any]]()
//
//        var nbEnforcement = [String: Any]()
//        nbEnforcement[PaymentParamConstant.paymentType] = PaymentParamConstant.nb
//
//        var ccdcEnforcement = [String: Any]()
//        ccdcEnforcement[PaymentParamConstant.paymentType] = PaymentParamConstant.card
//
//        if let cardType = enforceCardTypeTextField.text, !cardType.isEmpty {
//            let cardType = cardType.uppercased() == PaymentParamConstant.cc ? PaymentParamConstant.cc : PaymentParamConstant.dc
//            ccdcEnforcement[PaymentParamConstant.cardType] = cardType
//        }
//
//        var upiEnforcement = [String: Any]()
//        upiEnforcement[PaymentParamConstant.paymentType] = PaymentParamConstant.upi
//
//        var walletEnforcement = [String: Any]()
//        walletEnforcement[PaymentParamConstant.paymentType] = PaymentParamConstant.wallet
//
//        var emiEnforcement = [String: Any]()
//        emiEnforcement[PaymentParamConstant.paymentType] = PaymentParamConstant.emi
//
//        var neftRtgsEnforcement = [String: Any]()
//        neftRtgsEnforcement[PaymentParamConstant.paymentType] = PaymentParamConstant.neftrtgs
//
//        var sodexoEnforcement = [String: Any]()
//        sodexoEnforcement[PaymentParamConstant.paymentType] = PaymentParamConstant.sodexo
//
//        var bnplEnforcement = [String: Any]()
//        bnplEnforcement[PaymentParamConstant.paymentType] = PaymentParamConstant.bnpl
//
//        if enforceNBSwitch.isOn {
//            enforcePaymentList.append(nbEnforcement)
//        }
//
//        if enforceCardsSwitch.isOn {
//            enforcePaymentList.append(ccdcEnforcement)
//        }
//
//        if enforceUPISwitch.isOn {
//            enforcePaymentList.append(upiEnforcement)
//        }
//
//        if enforceWalletSwitch.isOn {
//            enforcePaymentList.append(walletEnforcement)
//        }
//
//        if enforceEMISwitch.isOn {
//            enforcePaymentList.append(emiEnforcement)
//        }
//
//        if enforceNeftRtgsSwitch.isOn {
//            enforcePaymentList.append(neftRtgsEnforcement)
//        }
//
//        if enforceSodexoSwitch.isOn {
//            enforcePaymentList.append(sodexoEnforcement)
//        }
//
//        if enforceBNPLSwitch.isOn {
//            enforcePaymentList.append(bnplEnforcement)
//        }
//
//        return enforcePaymentList
//    }
//
//    func getCustomNotes() -> [PayUCustomNote]? {
//        if let notesJSON = Utils.JSONFrom(string: customNotesDetailTextView.text) as? [[String: Any]] {
//            var customNotes = [PayUCustomNote]()
//            for json in notesJSON {
//                for (key, value) in json {
//                    if let paymentModes = (value as? [String])?.compactMap({ Utils.paymentTypeFrom(paymentType: $0) }) {
//                        let customNote = PayUCustomNote()
//                        customNote.note = key
//                        customNote.noteCategories = paymentModes
//                        customNotes.append(customNote)
//                    }
//                }
//            }
//            return customNotes
//        }
//        return nil
//    }
//
//    func getPreferredPaymentMode() -> [PaymentMode]? {
//        if let preferredPaymentModesJSON = Utils.JSONFrom(string: l1OptionTextView.text) as? [[String: String]] {
//            var preferredPaymentModes: [PaymentMode] = []
//            for eachPreferredPaymentMode in preferredPaymentModesJSON {
//                if let paymentMode = Utils.paymentModeFrom(paymentType: eachPreferredPaymentMode.keys.first?.lowercased(), paymentOptionID: eachPreferredPaymentMode.values.first) {
//                    preferredPaymentModes.append(paymentMode)
//                }
//            }
//            return preferredPaymentModes
//        }
//        return nil
//    }
//
//    func cartDetails() -> [[String: String]]? {
//        if let cartDetails = Utils.JSONFrom(string: orderDetailTextView.text) as? [[String: String]] {
//            return cartDetails
//        }
//        return nil
//    }

    
}

// MARK: - PayUCheckoutPro Delegate Methods -

extension MerchantViewController: PayUCheckoutProDelegate {
//    func onError(_ error: Error?) {
//        // handle error scenario
//        navigationController?.popToViewController(self, animated: true)
//        showAlert(title: "Error", message: error?.localizedDescription ?? "")
//    }
//
//    func onPaymentSuccess(response: Any?) {
//        // handle success scenario
//        navigationController?.popToViewController(self, animated: true)
//        showAlert(title: "Success", message: "\(response ?? "")")
//        print("response\n", response ?? "")
//    }
//
//    func onPaymentFailure(response: Any?) {
//        // handle failure scenario
//        navigationController?.popToViewController(self, animated: true)
//        showAlert(title: "Failure", message: "\(response ?? "")")
//        print("response\n", response ?? "")
//    }
//
//    func onPaymentCancel(isTxnInitiated: Bool) {
//        // handle txn cancelled scenario
//        // isTxnInitiated == YES, means user cancelled the txn when on reaching bankPage
//        // isTxnInitiated == NO, means user cancelled the txn before reaching the bankPage
//        navigationController?.popToViewController(self, animated: true)
//        let completeResponse = "isTxnInitiated = \(isTxnInitiated)"
//        showAlert(title: "Cancelled", message: "\(completeResponse)")
//    }
////
////    func generateHash(for param: DictOfString, onCompletion: @escaping PayUHashGenerationCompletion) {
////        let commandName = (param[HashConstant.hashName] ?? "")
////        let hashStringWithoutSalt = (param[HashConstant.hashString] ?? "")
////        let postSalt = param[HashConstant.postSalt]
////        // get hash for "commandName" from server
////        // get hash for "hashStringWithoutSalt" from server
////
////        // After fetching hash set its value in below variable "hashValue"
////        var hashValue = ""
////        if let hashType = param[HashConstant.hashType], hashType == "V2" {
////
////            hashValue = "<hmacSHA256 hash for hashStringWithoutSalt with salt>"
////        } else if commandName == HashConstant.mcpLookup {
////            hashValue = "<hmacsha1 hash for hashStringWithoutSalt and secret>"
////        } else if let postSalt = postSalt {
////            let hashString = hashStringWithoutSalt + (saltTextField.text ?? "") + postSalt
////            hashValue = "<hmacsha1 hash for hashStringWithoutSalt and secret>"
////        } else {
////            hashValue = "<hmacsha512 hash for hashStringWithoutSalt and salt>"
////        }
////        onCompletion([commandName: hashValue])
////    }
//    func generateHash(for param: DictOfString, onCompletion: @escaping PayUHashGenerationCompletion) {
//
//          let commandName = (param[HashConstant.hashName] ?? "")
//
//          let hashStringWithoutSalt = (param[HashConstant.hashString] ?? "")
//
//          let postSalt = param[HashConstant.postSalt]
//        debugPrint("hashStringWithoutSalt.......\(hashStringWithoutSalt)")
//          // get hash for "commandName" from server
//
//          // get hash for "hashStringWithoutSalt" from server
//
//
//
//          // After fetching hash set its value in below variable "hashValue"
//
//          var hashValue = ""
//
//          if let hashType = param[HashConstant.hashType], hashType == HashConstant.V2 {
//
//              hashValue = PayUDontUseThisClass.hmacSHA256(hashStringWithoutSalt, withKey: (saltTextField.text ?? "")) ?? ""
//
//
//
//
//
//          } else if commandName == HashConstant.mcpLookup {
//
//              hashValue = Utils.hmacsha1(of: hashStringWithoutSalt, secret: (merchantSecretKeyTextField.text ?? ""))
//
//          } else if let postSalt = postSalt {
//
//              let hashString = hashStringWithoutSalt + (saltTextField.text ?? "") + postSalt
//
//              hashValue = Utils.sha512Hex(string: hashString)
//
//              print("POST SALT..........\(hashString)")
//
//          } else {
//
//              hashValue = Utils.sha512Hex(string: (hashStringWithoutSalt + (saltTextField.text ?? "")))
//
//          }
//
//
//
//          debugPrint("hashValue.......\(hashValue)")
//
//          onCompletion([commandName : hashValue])
//
//      }
//    func showAlert(title: String, message: String) {
//        let alert = UIAlertController(
//            title: title,
//            message: message,
//            preferredStyle: .alert
//        )
//
//        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
//        alert.addAction(okAction)
//        present(alert, animated: true, completion: nil)
//    }
}

extension TestViewController: UIGestureRecognizerDelegate {
    // MARK: - Dismiss Keyboard On Tap Outside TextField
//
//    func dismissKeyboardOnTapOutsideTextField(addDelegate: Bool = false) {
//        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
//        if addDelegate {
//            tapGesture.delegate = self
//        }
//        view.addGestureRecognizer(tapGesture)
//    }
//
//    @objc func dismissKeyboard() {
//        view.endEditing(true)
//    }
//
//    // MARK: - Keyboard Handling -
//
//    func registerKeyboardNotification() {
//        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
//    }
//
//    func unRegisterKeyboardNotification() {
//        NotificationCenter.default.removeObserver(UIResponder.keyboardWillChangeFrameNotification)
//    }
//
//    @objc func keyboardWillChange(notification: NSNotification) {
//        let info = notification.userInfo!
//        let endFrame = (info[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
//        let timeFrame = (info[UIResponder.keyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue
//
//        let screenHeight = UIScreen.main.bounds.height
//
//        let keyboardVisibleHeight = max(screenHeight - endFrame.minY, 0)
//
//        for constraint in view.constraints {
//            if constraint.firstAttribute == .bottom {
//                // If first item is self's view then constant should be positive else it should be negative
//                let multiplier = constraint.firstItem as? UIView == view ? 1 : -1
//                constraint.constant = CGFloat(multiplier) * keyboardVisibleHeight
//            }
//        }
//
//        UIView.animate(withDuration: timeFrame) {
//            self.view.layoutIfNeeded()
//        }
//    }
}

// MARK: - Textfield Tapped Methods -

}
