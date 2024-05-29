//
//  TemsConditionVC.swift
//  EVApp
//
//  Created by Brijesh Bhardwaj on 01/06/23.
//

import UIKit

class TemsConditionVC: UIViewController {

    @IBOutlet weak var textView: UITextView!
    
    var reg = false
    override func viewDidLoad() {
        super.viewDidLoad()
        
        uidateUI()

    }
    
    @IBAction func back(_ sender: Any) {
        if reg == true{
            self.dismiss(animated: true)
//            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
//            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "RegistrationVC") as! RegistrationVC
//            self.present(nextViewController, animated:true, completion:nil)
        }else{
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "MenuNavigationPoint") as! MenuNavigation
            self.present(nextViewController, animated:true, completion:nil)
        }
    }
    func uidateUI(){
        let content  = String("PRIVACY POLICY\nThis privacy policy for Green Velocity Private Limited (\"Company,\" \"we,\" \"us,\" or \"our\"), describes how and why we might collect, store, use, and/or share (\"process\") your information when you use our Services. \nThe Company is an EV Charging Solutions provider, providing EV charging solutions through its Application and website, operating under the brand name 2018Yahhvi2019 (201cServices201d)\n\n\n    1. WHAT INFORMATION DO WE COLLECT?\n1.1 Personal information you disclose to us\nWe collect personal information that you voluntarily provide to us when you register on the Services, express an interest in obtaining information about us or our products and Services, when you participate in activities on the Services, or otherwise when you contact us.\nAll personal information that you provide to us must be true, complete, and accurate, and you must notify us of any changes to such personal information.\n1.2 Information automatically collected\nWe automatically collect certain information when you visit, use, or navigate the Services. This information does not reveal your specific identity but may include device and usage information, such as your IP address, browser and device characteristics, operating system, language preferences, referring URLSs, device name, country, location, information about how and when you use our Services, and other technical information. This information is primarily needed to maintain the security and operation of our Services, and for our internal analytics and reporting purposes. \nYou may additionally submit personally identifying information, such as your name, contact details, and employment history, by filling out a web form, getting in touch with us by email, or using another method. \n1.3 Cookies\nAs per business standards, we make use of a range of third- party service providers to design, protect, enhance, maintain, track, and advertise our website. Third parties (like Google) may set cookies on your computer when you visit our website in order to display you more relevant advertisements. By changing your browser settings, you can choose not to be tracked by cookies and advertisements.00a0\n1.4 Content from other websites\nContent in this site may include embedded content from other websites. These websites may track your interaction with the embedded content, gather information about you, utilise cookies, embed additional third-party tracking, and monitor your activity. This includes tracking your activity if you have an account and are logged in to the website.\n\n    2. HOW DO WE PROCESS YOUR INFORMATION?\nWe use your information to react to your questions, communicate with you about our services, and/or decide whether to invite you to take part in our service offerings. This privacy statement governs the collection of the information you provide and ensures its security. We also process your information to provide, improve, and administer our Services, communicate with you, for security and fraud prevention, and to comply with law. We may also process your information for other purposes with your consent\n\n    3. HOW LONG DO WE KEEP YOUR DATA?\nUnless a longer retention time is required or permitted by law, we will only keep your personal information for as long as it is necessary for the reasons outlined in this privacy notice (such as tax, accounting, or other legal requirements). If we no longer need to process your personal information for legitimate business purposes, we will either delete it or make it anonymous. If this is not possible (for instance, if your personal information is stored in backup archives), we will securely store your personal information and keep it separate from any other processing until deletion is possible.\n\n    4. WHERE IS YOUR DATA SENT?\nYour submissions might be subject to automated spam screening, internal email distribution, and storage in one or more cloud-based systems, some of whose servers might be located outside of your country of origin.\n\n    5. WHAT ARE YOUR PRIVACY RIGHTS?\nOn your request to terminate your account, we shall deactivate or remove your account and information from our active databases. If you would want to review or amend the information in your account at any time, you can. To stop fraud, address issues, help with any investigations, enforce our legal responsibilities, and/or comply with relevant legal requirements, we might keep some information in our records.\n\n    6. DO WE MAKE UPDATES TO THIS PRIVACY POLICY?\nThis privacy notice may occasionally be updated. A new \"Revised\" date will be used to identify the revised version, and it will take effect as soon as it is made available. If we make significant changes to our privacy statement, we'll let you know by either publicly publishing a notice of the changes or by sending you a notification. In order to stay informed about how we are protecting your information, we encourage you to frequently review this privacy notice.\n\n    7. HOW CAN YOU CONTACT US ABOUT THIS POLICY?\nIf you have questions or comments about this notice, you may email us at it@yahhvi.")
        //self.textView.htmlText = content
        
        var attributedString = NSMutableAttributedString(string: content)
        var s = attributedString.string

        textView.attributedText = attributedString
    }
 
}
extension String {
  
    var htmlToAttributedString: NSAttributedString? {
        guard let data = data(using: .utf8) else { return NSAttributedString() }
        do {
            let options: [NSAttributedString.DocumentReadingOptionKey : Any] = [
                .documentType: NSAttributedString.DocumentType.html,
                .characterEncoding: String.Encoding.utf8.rawValue
            ]
            let attributedString = try NSMutableAttributedString(data: data, options: options, documentAttributes: nil)
            return attributedString
        } catch {
            return NSAttributedString()
        }
    }
    
    func customHTMLAttributedString(withFont font: UIFont?, textColor: UIColor) -> NSAttributedString? {
        guard let font = font else {
            return self.htmlToAttributedString
        }
        let hexCode = textColor.hexCodeString
        let css = "<style>body{font-family: '\(font.fontName)'; font-size:\(font.pointSize)px; color: \(hexCode);}</style>"
        let modifiedString = css + self
        return modifiedString.htmlToAttributedString
    }
  
}

extension UITextView {
    
    var htmlText: String? {
        set(value) {
            let newValue = value ?? ""
            self.attributedText = newValue.customHTMLAttributedString(withFont: self.font, textColor: self.textColor ?? .black)
        }
        get {
            return self.attributedText.string
        }
    }
    
}

extension UIColor {
    
    var hexCodeString: String {
        var r:CGFloat = 0
        var g:CGFloat = 0
        var b:CGFloat = 0
        var a:CGFloat = 0

        getRed(&r, green: &g, blue: &b, alpha: &a)

        let rgb:Int = (Int)(r*255)<<16 | (Int)(g*255)<<8 | (Int)(b*255)<<0

        return String(format:"#%06x", rgb)
    }
  
}
