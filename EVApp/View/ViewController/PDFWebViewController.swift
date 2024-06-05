//
//  PDFWebViewController.swift
//  EVApp
//
//  Created by Brijesh Bhardwaj on 25/06/23.
//

import UIKit
import PDFKit


class PDFWebViewController: UIViewController {
   
    @IBOutlet weak var webView: UIWebView!
    private var pdfView: PDFView!
    var userTrxId = String()
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        self.viewInvoice()
    }
    @IBAction func back(_ sender: Any) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "MenuNavigationPoint") as! MenuNavigation
        self.present(nextViewController, animated:true, completion:nil)
    }
    func viewInvoice(){
        let invoiceUrl  = EndPoints.shared.baseUrlDev + EndPoints.shared.paymentInvoice + userTrxId
        var pdfURL = URL(string: invoiceUrl)!
        self.webView.loadRequest(URLRequest(url: pdfURL))
    }
    
}
