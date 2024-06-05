//
//  BookedSlotVC.swift
//  EVApp
//
//  Created by Brijesh Bhardwaj on 08/07/23.
//

import UIKit

class BookedSlotVC: UIViewController,UITableViewDelegate,UITableViewDataSource {
    @IBOutlet weak var slotTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func back(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
     return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BookedSlotCell", for: indexPath) as? BookedSlotCell
        cell?.bcview.layer.cornerRadius = 12
        return cell!
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
   

}
