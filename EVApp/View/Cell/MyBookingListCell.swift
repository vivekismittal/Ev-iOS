//
//  MyBookingListCell.swift
//  EVApp
//
//  Created by Brijesh Bhardwaj on 19/05/23.
//

import UIKit

class MyBookingListCell: UITableViewCell {
    static let identifier = "MyBookingListCell"
    
    @IBOutlet weak var cancelLabel: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var bcView: UIView!
    @IBOutlet weak var lblBookingId: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var lblConnId: UILabel!
    @IBOutlet weak var btnStart: UIButton!
    @IBOutlet weak var btnlocate: UIButton!
    @IBOutlet weak var lblStationName: UILabel!
    @IBOutlet weak var locateStartBackgroundView: UIView!
    @IBOutlet weak var locateStartHeightConstraint: NSLayoutConstraint!


    
    var bookedSlot: AdvancedChargingBookedSlot!{
        didSet{
         setView()
        }
    }
    
    var onCancelAppointment: ((Int)->())!
    
    var forPage: BookedSlotPage!{
        didSet{
            setViewAccordingToUpcomingOrCancelled()
        }
    }
    
    func setViewAccordingToUpcomingOrCancelled(){
        switch forPage! {
        case .Upcoming:
            cancelLabel.text = "Cancel"
            cancelLabel.isUserInteractionEnabled = true
            cancelLabel.setOnClickListener {[weak self] in
                if let id = self?.bookedSlot?.id{
                    self?.onCancelAppointment(id)
                }
            }
            
        case .Cancelled:
            cancelLabel.text = "Cancelled"
            locateStartHeightConstraint.constant = 0
            locateStartBackgroundView.isHidden = true
            cancelLabel.setOnClickListener {}
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.bcView.layer.borderColor   = #colorLiteral(red: 0.3102734685, green: 0.7092829347, blue: 0.955113709, alpha: 1)
        self.bcView.layer.borderWidth = 1
        self.bcView.layer.cornerRadius = 15
        self.btnlocate.layer.cornerRadius = 8
        self.btnStart.layer.cornerRadius = 8
    }
    
    func setView(){
        lblDate.text = " Date: \(bookedSlot.bookingDate ?? "NA")"
        lblBookingId.text = "    Booking Id: \(bookedSlot.id ?? -1)"
        lblStationName.text = bookedSlot.chargerInfo?.chargerAddress?.street ?? "NA"
        lblConnId.text = (bookedSlot.chargeBoxIdentity ?? "NA") + ":" + (bookedSlot.connectorId ?? "NA")
        lblTime.text = (bookedSlot.startTime ?? "NA") + " to " + (bookedSlot.endTime ?? "NA")
        btnlocate.setOnClickListener {
            
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(false, animated: animated)

        // Configure the view for the selected state
    }
    
    override func prepareForReuse() {
        locateStartHeightConstraint.constant = 34
        locateStartBackgroundView.isHidden = false
    }

}
