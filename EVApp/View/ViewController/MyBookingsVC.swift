//
//  MyBookingsVC.swift
//  EVApp
//
//  Created by Brijesh Bhardwaj on 19/05/23.
//  Corrected by Vivek Mittal

import UIKit

class MyBookingsVC: UIViewController {
    
    var signUpResponse : CheckLoginSignUpModel?
    var userRoleResponse: UserRoleResponse?
    var userRoleResponseA : UserRoleResponse?
    
    @IBOutlet weak var cancelledBookingsLabel: UILabel!
    @IBOutlet weak var upcomingBookingsLabel: UILabel!
    @IBOutlet weak var cancelView: UIView!
    @IBOutlet weak var upComView: UIView!
    @IBOutlet weak var segmentView: UIView!
    @IBOutlet weak var slotsTableView: UITableView!
    
    private let chargingViewModel: ChargingViewModel = .init()

    private var currentPage: BookedSlotPage = .Upcoming
    
    private var upcomingAdvancedBookedSlots: [AdvancedChargingBookedSlot] = .init()
    private var cancelledAdvancedBookedSlots: [AdvancedChargingBookedSlot] = .init()
    
    private var bookedSlots: [AdvancedChargingBookedSlot] {
        switch currentPage {
        case .Upcoming:
            upcomingAdvancedBookedSlots
        case .Cancelled:
            cancelledAdvancedBookedSlots
        }
    }
    
    private let dispatchGroup: DispatchGroup = .init()
    
    static func instantiateFromStoryboard() -> Self {
        let vc = ViewControllerFactory<Self>.viewController(for: .MyBookingsScreen)
        return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        slotsTableView.delegate = self
        slotsTableView.dataSource = self
        
        fetchBothUpcomingAndCancelledBookedSlots()
        
        upComView.layer.cornerRadius = 12
        cancelView.layer.cornerRadius = 12
        
        segmentView.layer.cornerRadius = 12
        segmentView.layer.borderColor = #colorLiteral(red: 0.4855932593, green: 0.7739699483, blue: 0.08541054279, alpha: 1)
        segmentView.layer.borderWidth = 2
        
        upcomingBookingsLabel.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        cancelledBookingsLabel.textColor = .black
        upComView.backgroundColor = #colorLiteral(red: 0.4855932593, green: 0.7739699483, blue: 0.08541054279, alpha: 1)
        cancelView.backgroundColor = .white
        
        upComView.setOnClickListener { [weak self] in
            self?.currentPage = .Upcoming
            self?.switchUpcomingOrCancelledBookingList()
        }
        
        cancelView.setOnClickListener { [weak self] in
            self?.currentPage = .Cancelled
            self?.switchUpcomingOrCancelledBookingList()
        }
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Show the navigation bar on other view controllers
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    @IBAction func back(_ sender: Any) {
        goBack()
    }
    
    func switchUpcomingOrCancelledBookingList() {
        
        upComView.backgroundColor = currentPage == .Upcoming ? #colorLiteral(red: 0.4855932593, green: 0.7739699483, blue: 0.08541054279, alpha: 1) : .white
        cancelView.backgroundColor = currentPage == .Upcoming ? .white : #colorLiteral(red: 0.4855932593, green: 0.7739699483, blue: 0.08541054279, alpha: 1)
        
        upcomingBookingsLabel.textColor = currentPage == .Upcoming ? .white : .black
        cancelledBookingsLabel.textColor = currentPage == .Upcoming ? .black : .white
        
        slotsTableView.reloadData()
    }
    
    private func fetchBothUpcomingAndCancelledBookedSlots(){
        MainAsyncThread {[weak self] in
            guard let self else { return }
            showSpinner(onView: view)
        }
        fetchAdvancedChargingBookedSlots(forPage: .Upcoming)
        fetchAdvancedChargingBookedSlots(forPage: .Cancelled)
        
        dispatchGroup.notify(queue: .main){[weak self] in
            MainAsyncThread {
                self?.removeSpinner()
            }
            self?.slotsTableView.reloadData()
        }
    }
    
    private func fetchAdvancedChargingBookedSlots(forPage: BookedSlotPage){
        dispatchGroup.enter()
        
        chargingViewModel.getAdvancedChargingBookingSlotsForUser(forPage: forPage){ [weak self] res in
            defer{
                self?.dispatchGroup.leave()
            }
            
            switch res{
            case .success(let bookedSlots):
                switch forPage {
                case .Upcoming:
                    self?.upcomingAdvancedBookedSlots = bookedSlots
                case .Cancelled:
                    self?.cancelledAdvancedBookedSlots = bookedSlots
                }
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func cancelChargingBookedSlot(id: Int){
        self.showSpinner(onView: view)
        
        chargingViewModel.cancelChargingBookedSlot(id: id){ [weak self] res in
            
            MainAsyncThread {
                self?.removeSpinner()
            }
            
            switch res{
            case .success(let statusMessage):
                MainAsyncThread {
                    if let message = statusMessage.message{
                        self?.showAlert(title: "", message: message)
                    }
                }
                if statusMessage.status == "True"{
                    self?.fetchBothUpcomingAndCancelledBookedSlots()
                }
            case .failure(let error):
                print(error)
            }
        }
    }

}

extension MyBookingsVC: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bookedSlots.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MyBookingListCell.identifier, for: indexPath)
        
        if let bookingCell = cell as? MyBookingListCell{
            bookingCell.bookedSlot = bookedSlots[indexPath.row]
            bookingCell.forPage = currentPage
            
            bookingCell.onCancelAppointment = {[weak self] bookingId in
                self?.cancelChargingBookedSlot(id: bookingId)
            }
        }
       
        return cell
    }
    
    func  tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return currentPage == .Upcoming ? 245 : 245 - 34
    }
    
    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        return bookedSlots.isEmpty ?
        "No Data Found!"
        : nil
    }
    
}

enum BookedSlotPage: String{
    case Upcoming
    case Cancelled
}
