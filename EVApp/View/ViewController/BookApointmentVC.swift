//
//  BookApointmentVC.swift
//  EVApp
//
//  Created by Brijesh Bhardwaj on 02/07/23.
//  Corrected by Vivek Mittal

import UIKit

class BookApointmentVC: UIViewController {
    @IBOutlet weak var viewGreen: UIView!
    @IBOutlet weak var startTimePicker: UIDatePicker!
    @IBOutlet weak var endTimePicker: UIDatePicker!
    @IBOutlet weak var timeDurationOptionHorizontalStackView: UIStackView!
    @IBOutlet weak var dateOptionsVerticalStackView: UIStackView!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var view6: UIView!
    @IBOutlet weak var viewRed: UIView!
    @IBOutlet weak var view5: UIView!
    @IBOutlet weak var view4: UIView!
    @IBOutlet weak var lblSelectedSession: UILabel!
    @IBOutlet weak var view3: UIView!
    @IBOutlet weak var view2: UIView!
    @IBOutlet weak var view1: UIView!
    @IBOutlet weak var lblEndDate: UILabel!
    @IBOutlet weak var lblEndTime: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var btnNext: UIButton!
    
    private var id = [String]()
    private var bookingDate = [String]()
    private var chargeBoxIdentity = [String]()
    private var connectorId = [String]()
    private var selectedDate = String()
    private var startingTime = String()
    private var endingTime = String()
    
    private var chargeBoxId: String!
    private var connName: String!
    private var chargingViewModel: ChargingViewModel!
    
    private var selectedChargingDateButton: UIButton?{
        didSet{
            if let oldValue{
                unSelectButton(oldValue)
            }
            guard let selectedChargingDateButton else { return }
            selectButton(selectedChargingDateButton)
            
            lblDate.text = selectedChargingDateButton.titleLabel?.text
            lblEndDate.text = selectedChargingDateButton.titleLabel?.text
            selectedDate = lblDate.text ?? ""
        }
    }
    
    private var selectedChargingDurationButton: UIButton?{
        didSet{
            if let oldValue{
                unSelectButton(oldValue)
            }
            guard let selectedChargingDurationButton else { return }
            selectButton(selectedChargingDurationButton)
            lblSelectedSession.text = selectedChargingDurationButton.titleLabel?.text
        }
    }
    
    private var selectedTimeDuration: ChargingBookingTimeDuration?{
        didSet{
            updateStartEndTime()
        }
    }
    
    func updateStartEndTime(){
        guard let selectedTimeDuration else { return }
        endTimePicker.setDate(startTimePicker.date.addingTimeInterval(selectedTimeDuration.timeDuration), animated: true)
        let endTime = endTimePicker.date.getTimeInAMPM()
        lblEndTime.text = endTime
        
        endingTime = endTime
        startingTime = lblTime.text ?? ""
    }
    
    
    static func instantiateFromStoryboard(with viewModel: ChargingViewModel = ChargingViewModel(),connectorName: String, chargeBoxId: String) -> Self {
        let vc = ViewControllerFactory<Self>.viewController(for: .BookChargingSlotScreen)
        
        vc.chargingViewModel = viewModel
        vc.chargeBoxId = chargeBoxId
        vc.connName = connectorName
        return vc
    }
    
    @objc func handleTimeChange(sender: UIDatePicker) {
        lblTime.text = sender.date.getTimeInAMPM()
        updateStartEndTime()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        startTimePicker.addTarget(self, action: #selector(handleTimeChange(sender: )), for: .valueChanged)
        
        setViews()
        
        fetchAvailableChargingSlots()
        
    }
    
    fileprivate func setViews() {
        self.lblTime.text = self.startTimePicker.date.getTimeInAMPM()
        self.view1.layer.cornerRadius = self.view1.bounds.height / 2
        self.view2.layer.cornerRadius = self.view2.bounds.height / 2
        self.view3.layer.cornerRadius = self.view3.bounds.height / 2
        self.view4.layer.cornerRadius = self.view4.bounds.height / 2
        self.view5.layer.cornerRadius = self.view5.bounds.height / 2
        self.view6.layer.cornerRadius = self.view6.bounds.height / 2
        self.viewGreen.layer.cornerRadius = self.viewGreen.bounds.height / 2
        self.viewRed.layer.cornerRadius = self.viewRed.bounds.height / 2
        
        bottomView.clipsToBounds = true
        bottomView.layer.cornerRadius = 25
        btnNext.layer.cornerRadius = 12
        bottomView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        self.bottomView.layer.borderColor   = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        self.bottomView.layer.borderWidth = 1
        self.lblSelectedSession.layer.borderColor   = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        self.lblSelectedSession.layer.borderWidth = 1
    }
    
    @IBAction func back(_ sender: Any) {
        goBack()
    }
    
    @IBAction func next(_ sender: Any) {
        if !selectedDate.isEmpty, !startingTime.isEmpty, !endingTime.isEmpty{
            makeAdvanceChargingBooking()
        }
    }
    
    @IBAction func viewBookedSlots(_ sender: Any) {
    }
    
    private func addTimeDurationOptionsInStack(timeDurationOptionsButtons: [UIButton]){
        timeDurationOptionsButtons.forEach { button in
            timeDurationOptionHorizontalStackView.addArrangedSubview(button)
        }
    }
    
    private func getButtonsList(from titleList: [String], onSelect: @escaping (UIButton, Int)->()) -> [UIButton]{
        titleList.enumerated().map { (index, title) in
            let button = UIButton()
            button.setTitle(title, for: .normal)
            button.titleLabel?.font = .systemFont(ofSize: 14)
            button.setTitleColor(.black, for: .normal)
            button.layer.cornerRadius = 12
            
            unSelectButton(button)
            button.setOnClickListener {
                if !button.isSelected{
                    onSelect(button, index)
                }
            }
            
            return button
        }
    }
    
    private func addAvailableBookingDateOptionsInStack(dateOptionsButtons: [UIButton]){
        var horizontalStack: UIStackView!
        
        for (index,dateButton) in dateOptionsButtons.enumerated(){
            if index.isMultiple(of: 2){
                
                if index != 0{
                    dateOptionsVerticalStackView.addArrangedSubview(horizontalStack)
                }
                
                horizontalStack = UIStackView()
                horizontalStack.frame = .init(x: horizontalStack.frame.origin.x, y: horizontalStack.frame.origin.y, width: horizontalStack.frame.width, height: 45)
                horizontalStack.axis = .horizontal
                horizontalStack.spacing = 4
                horizontalStack.distribution = .fillEqually
                horizontalStack.alignment = .fill
                
                horizontalStack.addArrangedSubview(dateButton)
            } else{
                
                horizontalStack.addArrangedSubview(dateButton)
            }
        }
        dateOptionsVerticalStackView.addArrangedSubview(horizontalStack)
    }
    
    
    
    private func unSelectButton(_ button: UIButton){
        button.isSelected = false
        button.layer.borderColor   = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        button.layer.borderWidth = 1
    }
    
    private func selectButton(_ button: UIButton){
        button.isSelected = true
        button.layer.borderColor   = #colorLiteral(red: 0.4855932593, green: 0.7739699483, blue: 0.08541054279, alpha: 1)
        button.layer.borderWidth = 2
    }
    
    private func fetchAvailableChargingSlots(){
        self.showSpinner(onView: view)
        
        chargingViewModel.getChargerBookingSlots(chargeBoxId: chargeBoxId){[weak self] res in
            MainAsyncThread {
                self?.removeSpinner()
            }
            switch res{
            case .success(let availableSlots):
                MainAsyncThread {
                    self?.removeSpinner()
                    
                    if let dateOptionsButtons = self?.getButtonsList(
                        from: availableSlots.bookingDates ?? [],
                        onSelect: { button, index in
                            self?.selectedChargingDateButton = button
                        }){
                        self?.selectedChargingDateButton = dateOptionsButtons.first
                        
                        self?.addAvailableBookingDateOptionsInStack(dateOptionsButtons: dateOptionsButtons)
                    }
                    
                    guard let chargingBookingTimeDurationList = self?.chargingBookingTimeDurationList else { return }
                    
                    if let timeDurationOptionsButtons = self?.getButtonsList(
                        from: chargingBookingTimeDurationList.map({ $0.durationTitle }),
                        onSelect: { button, index in
                            self?.selectedChargingDurationButton = button
                            self?.selectedTimeDuration = chargingBookingTimeDurationList[index]
                        }
                    ){
                        self?.selectedChargingDurationButton = timeDurationOptionsButtons.first
                        self?.selectedTimeDuration = chargingBookingTimeDurationList.first
                        
                        self?.addTimeDurationOptionsInStack(timeDurationOptionsButtons: timeDurationOptionsButtons)
                    }
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func makeAdvanceChargingBooking(){
        self.showSpinner(onView: view)
        chargingViewModel.makeAdvanceBookingForCharging(for: selectedDate, startingTime: startingTime, endingTime: endingTime, connectorName: connName, chargeBoxId: chargeBoxId){[weak self] res in
            MainAsyncThread {
                self?.removeSpinner()
            }
            switch res{
            case .success(let bookingResponse):
                MainAsyncThread {
                    if let message = bookingResponse.message{
                        self?.showAlert(title: "", message: message)
                    }
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private let chargingBookingTimeDurationList: [ChargingBookingTimeDuration] = [
        (15 * 60, "15 Min"),
        (30 * 60, "30 Min"),
        (60 * 60, "1 Hour"),
        (2 * 60 * 60, "2 Hour")
    ]
}

extension Date{
    func getTimeInAMPM() -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h:mm a"
        return dateFormatter.string(from: self)
    }
}

typealias ChargingBookingTimeDuration = (timeDuration: TimeInterval, durationTitle: String)


