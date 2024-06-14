//
//  RegistrationVC.swift
//  EVApp
//
//  Created by Brijesh Bhardwaj on 16/05/23.
//

import UIKit

class RegistrationVC: UIViewController {
    @IBOutlet weak var selfUserContainer: UIView!
    
    @IBOutlet weak var sectionView: UIView!
    @IBOutlet weak var coporateUserContainer: UIView!
    @IBOutlet weak var btnCorporate: UIButton!
    @IBOutlet weak var btnSelfuser: UIButton!
    
    static func instantiateUsingStoryboard() -> Self {
        let vc = ViewControllerFactory<RegistrationVC>.viewController(for: .UserRegistrationScreen)
        return vc as! Self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.setHidesBackButton(true, animated: true)
        self.selfUserContainer.isHidden = false
        self.coporateUserContainer.isHidden = true
        
        self.btnSelfuser.layer.cornerRadius = 12
        self.btnCorporate.layer.cornerRadius = 12
        sectionView.layer.cornerRadius = 12
        sectionView.layer.borderColor = #colorLiteral(red: 0.4855932593, green: 0.7739699483, blue: 0.08541054279, alpha: 1)
        sectionView.layer.borderWidth = 2
        
        btnSelfuser.titleLabel?.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        btnCorporate.titleLabel?.textColor = .black
        self.btnSelfuser.backgroundColor = #colorLiteral(red: 0.4855932593, green: 0.7739699483, blue: 0.08541054279, alpha: 1)
        self.btnCorporate.backgroundColor = .white
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationItem.setHidesBackButton(true, animated: true)
    self.selfUserContainer.isHidden = false
    self.coporateUserContainer.isHidden = true
    
    self.btnSelfuser.layer.cornerRadius = 12
    self.btnCorporate.layer.cornerRadius = 12
    sectionView.layer.cornerRadius = 12
    sectionView.layer.borderColor = #colorLiteral(red: 0.4855932593, green: 0.7739699483, blue: 0.08541054279, alpha: 1)
    sectionView.layer.borderWidth = 2
    
    btnSelfuser.titleLabel?.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
    btnCorporate.titleLabel?.textColor = .black
    self.btnSelfuser.backgroundColor = #colorLiteral(red: 0.4855932593, green: 0.7739699483, blue: 0.08541054279, alpha: 1)
    self.btnCorporate.backgroundColor = .white
    }
    
    @IBAction func selfUserAction(_ sender: Any) {
        self.selfUserContainer.isHidden = false
        self.coporateUserContainer.isHidden = true
        
        self.btnSelfuser.backgroundColor = #colorLiteral(red: 0.4855932593, green: 0.7739699483, blue: 0.08541054279, alpha: 1)
        self.btnCorporate.backgroundColor = .white
        
        btnSelfuser.titleLabel?.textColor = .white
        btnCorporate.titleLabel?.textColor = .black
    }
    @IBAction func corporateAction(_ sender: Any) {
        self.selfUserContainer.isHidden = true
        self.coporateUserContainer.isHidden = false
        
        self.btnSelfuser.backgroundColor = .white
        self.btnCorporate.backgroundColor = #colorLiteral(red: 0.4855932593, green: 0.7739699483, blue: 0.08541054279, alpha: 1)
        
        btnSelfuser.titleLabel?.textColor = .black
        btnCorporate.titleLabel?.tintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
    }
    
}
