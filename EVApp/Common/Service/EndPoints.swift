//
//  EndPoints.swift
//  EVApp
//
//  Created by Brijesh Bhardwaj on 25/05/23.
//

import Foundation

struct EndPoints{
    static let shared = EndPoints()
    private init() {}
    // Production URL
    // let  baseUrlProd =  "http://cms.greenvelocity.co.in:8087/cms/manager/rest"
    // Development URL
    
    // Production URL
    let  baseUrlDev =  "http://cms.greenvelocity.co.in:8087/cms/manager/rest"
    let  baseUrl =     "http://cms.greenvelocity.co.in:8087/cms/manager/rest"
    // Development URL
    // Beta URL
//    let  baseUrl =  "http://beta.greenvelocity.co.in:8080/cms/manager/rest"
//    let  baseUrlDev = "http://beta.greenvelocity.co.in:8080/cms/manager/rest"
    //End Points
    let state = "/combo/state"
    let country = "/combo/country"
    let guestUser = "/users/guestLogin"
    let sendOtp = "/users/otp"
    let verifyOtp = "/users/verify"
    let login = "/users/login"
    let registerUser = "/users"
    let chargerList = "/chargers"
    let waletTransaction = "/payment/wallet/transaction"
    let usersUpdate = "/users/update"
    let getUserByPhone = "/users/phone"
    let getWalletAmount = "/payment/wallet/amount"
    let addWaletAmt = "/payment/wallet/add"
    let couponDetail = "/chargers/coupon-details"
    let amountUnit = "/chargers/amount/unit"
    let discountCoupon = "/chargers/discount-coupon"
    let wattAmount = "/chargers/watt/amount"
    let timeAmount = "/chargers/time-in-minutes/amount"
    let trxStart = "/chargers/trx/start"
    let trxStop = "/chargers/trx/stop"
    let paymentHash = "/payment/hash"
    let trxMeterValues = "/chargers/trx/metervalues"
    let chargersStations = "/chargers/stations"
    let paymentUsertrxsession = "/payment/usertrxsession"
    let usersChangePassword = "/users/changePassword"
    let chargersTrxSummary = "/chargers/trx/summary"
    let paymentInvoice = "/payment/invoice/pdf1/"
    let advancebookingTimeslots = "/advancebooking/timeslots"
    let advbookingUserBookings = "/advancebooking/user-bookings"
    let advbookingUserCancelled = "/advancebooking/user-cancelled-bookings"
    let adbookingCancelBooking = "/advancebooking/cancel-booking"
    let advBookslots = "/advancebooking/book-slots"
    let userReviewRating = "/users/review-rating"
    let userReviewWriting = "/users/review-writing"
    let version = "/chargers/ios-version"
    let appStoreLink = "https://apps.apple.com/us/app/yahhvi-ev-charging/id6450030187"
}




