//
//  ChargingMeterValuesModel.swift
//  EVApp
//
//  Created by VM on 27/06/24.
//

import Foundation

// MARK: - ChargingMeterValuesModel
struct ChargingMeterValuesModel: Decodable {
    let meterValues: [MeterValue]?
    let batteryLevel: BatteryLevel?
    let stopValue, startValue: Float?
    let status, error: String?
    let stopReason, chargeBoxId: String?
    let amount: Float?
    let startTime, stopTime, date, totalTime: String?
    let paymentTransactionId, transactionId: Int?
    let amountDeducted: Double?
    let corporateUser: Bool?
    let totalTimes: Double?
    let totalTimeTakenInMinutes: Float?
    let timerBasedCharging: Bool?
    let chargingTimeInMinutes: Int?
    let totalTimeRemainingInMinutes: Float?
    
    enum CodingKeys: CodingKey {
        case meterValues
        case batteryLevel
        case stopValue
        case startValue
        case status
        case error
        case stopReason
        case chargeBoxId
        case amount
        case startTime
        case stopTime
        case date
        case totalTime
        case paymentTransactionId
        case transactionId
        case amountDeducted
        case corporateUser
        case totalTimes
        case totalTimeTakenInMinutes
        case timerBasedCharging
        case chargingTimeInMinutes
        case totalTimeRemainingInMinutes
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.meterValues = try container.decodeIfPresent([MeterValue].self, forKey: .meterValues)
        self.batteryLevel = try container.decodeIfPresent(BatteryLevel.self, forKey: .batteryLevel)
        self.stopValue = if let stopValue = try container.decodeIfPresent(String.self, forKey: .stopValue){
            Float(stopValue)
        } else {
            nil
        }
        self.startValue = if let startValue = try container.decodeIfPresent(String.self, forKey: .startValue){
            Float(startValue)
        } else {
            nil
        }
        self.status = try container.decodeIfPresent(String.self, forKey: .status)
        self.error = try container.decodeIfPresent(String.self, forKey: .error)
        self.stopReason = try container.decodeIfPresent(String.self, forKey: .stopReason)
        self.chargeBoxId = try container.decodeIfPresent(String.self, forKey: .chargeBoxId)
        self.amount = try container.decodeIfPresent(Float.self, forKey: .amount)
        self.startTime = try container.decodeIfPresent(String.self, forKey: .startTime)
        self.stopTime = try container.decodeIfPresent(String.self, forKey: .stopTime)
        self.date = try container.decodeIfPresent(String.self, forKey: .date)
        self.totalTime = try container.decodeIfPresent(String.self, forKey: .totalTime)
        self.paymentTransactionId = try container.decodeIfPresent(Int.self, forKey: .paymentTransactionId)
        self.transactionId = try container.decodeIfPresent(Int.self, forKey: .transactionId)
        self.amountDeducted = try container.decodeIfPresent(Double.self, forKey: .amountDeducted)
        self.corporateUser = try container.decodeIfPresent(Bool.self, forKey: .corporateUser)
        self.totalTimes = try container.decodeIfPresent(Double.self, forKey: .totalTimes)
        self.totalTimeTakenInMinutes = try container.decodeIfPresent(Float.self, forKey: .totalTimeTakenInMinutes)
        self.timerBasedCharging = try container.decodeIfPresent(Bool.self, forKey: .timerBasedCharging)
        self.chargingTimeInMinutes = try container.decodeIfPresent(Int.self, forKey: .chargingTimeInMinutes)
        self.totalTimeRemainingInMinutes = try container.decodeIfPresent(Float.self, forKey: .totalTimeRemainingInMinutes)
    }
}

// MARK: - BatteryLevel
struct BatteryLevel: Decodable {
    let batteryPercentage, chargeBoxID: String?

    enum CodingKeys: String, CodingKey {
        case batteryPercentage
        case chargeBoxID = "chargeBoxId"
    }
}

// MARK: - MeterValue
struct MeterValue: Decodable {
    let value: Float?
    var format: String?
    var measurand: String?
    var unit: Unit?
    let chargeBoxId, status: String?
    
    enum CodingKeys: CodingKey {
        case value
        case format
        case measurand
        case unit
        case chargeBoxId
        case status
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.value = if let value = try container.decodeIfPresent(String.self, forKey: .value){
            Float(value)
        } else {
            nil
        }
        self.format = try container.decodeIfPresent(String.self, forKey: .format)
        self.measurand = try container.decodeIfPresent(String.self, forKey: .measurand)
        self.unit = try container.decodeIfPresent(Unit.self, forKey: .unit)
        self.chargeBoxId = try container.decodeIfPresent(String.self, forKey: .chargeBoxId)
        self.status = try container.decodeIfPresent(String.self, forKey: .status)
    }
}


enum Unit: String, Decodable {
    case a = "A"
    case percent = "Percent"
    case w = "W"
    case wh = "Wh"
}

//
//{
//    "meterValues": [{
//        "value": "1244510",
//        "readingContext": "Sample.Periodic",
//        "format": "Raw",
//        "measurand": "Energy.Active.Import.Register",
//        "location": null,
//        "unit": "Wh",
//        "chargeBoxId": "20210903036",
//        "status": "true",
//        "batteryLevel": null
//    }, {
//        "value": "7197.83",
//        "readingContext": "Sample.Periodic",
//        "format": "Raw",
//        "measurand": "Power.Active.Import",
//        "location": null,
//        "unit": "W",
//        "chargeBoxId": "20210903036",
//        "status": "true",
//        "batteryLevel": null
//    }, {
//        "value": "1244530",
//        "readingContext": "Sample.Periodic",
//        "format": "Raw",
//        "measurand": "Energy.Active.Import.Register",
//        "location": null,
//        "unit": "Wh",
//        "chargeBoxId": "20210903036",
//        "status": "true",
//        "batteryLevel": null
//    }, {
//        "value": "7317.23",
//        "readingContext": "Sample.Periodic",
//        "format": "Raw",
//        "measurand": "Power.Active.Import",
//        "location": null,
//        "unit": "W",
//        "chargeBoxId": "20210903036",
//        "status": "true",
//        "batteryLevel": null
//    }, {
//        "value": "1244550",
//        "readingContext": "Sample.Periodic",
//        "format": "Raw",
//        "measurand": "Energy.Active.Import.Register",
//        "location": null,
//        "unit": "Wh",
//        "chargeBoxId": "20210903036",
//        "status": "true",
//        "batteryLevel": null
//    }, {
//        "value": "7697.32",
//        "readingContext": "Sample.Periodic",
//        "format": "Raw",
//        "measurand": "Power.Active.Import",
//        "location": null,
//        "unit": "W",
//        "chargeBoxId": "20210903036",
//        "status": "true",
//        "batteryLevel": null
//    }, {
//        "value": "1244570",
//        "readingContext": "Sample.Periodic",
//        "format": "Raw",
//        "measurand": "Energy.Active.Import.Register",
//        "location": null,
//        "unit": "Wh",
//        "chargeBoxId": "20210903036",
//        "status": "true",
//        "batteryLevel": null
//    }, {
//        "value": "8037.61",
//        "readingContext": "Sample.Periodic",
//        "format": "Raw",
//        "measurand": "Power.Active.Import",
//        "location": null,
//        "unit": "W",
//        "chargeBoxId": "20210903036",
//        "status": "true",
//        "batteryLevel": null
//    }, {
//        "value": "1244600",
//        "readingContext": "Sample.Periodic",
//        "format": "Raw",
//        "measurand": "Energy.Active.Import.Register",
//        "location": null,
//        "unit": "Wh",
//        "chargeBoxId": "20210903036",
//        "status": "true",
//        "batteryLevel": null
//    }, {
//        "value": "8401.78",
//        "readingContext": "Sample.Periodic",
//        "format": "Raw",
//        "measurand": "Power.Active.Import",
//        "location": null,
//        "unit": "W",
//        "chargeBoxId": "20210903036",
//        "status": "true",
//        "batteryLevel": null
//    }, {
//        "value": "1244620",
//        "readingContext": "Sample.Periodic",
//        "format": "Raw",
//        "measurand": "Energy.Active.Import.Register",
//        "location": null,
//        "unit": "Wh",
//        "chargeBoxId": "20210903036",
//        "status": "true",
//        "batteryLevel": null
//    }, {
//        "value": "8769.93",
//        "readingContext": "Sample.Periodic",
//        "format": "Raw",
//        "measurand": "Power.Active.Import",
//        "location": null,
//        "unit": "W",
//        "chargeBoxId": "20210903036",
//        "status": "true",
//        "batteryLevel": null
//    }, {
//        "value": "1244650",
//        "readingContext": "Sample.Periodic",
//        "format": "Raw",
//        "measurand": "Energy.Active.Import.Register",
//        "location": null,
//        "unit": "Wh",
//        "chargeBoxId": "20210903036",
//        "status": "true",
//        "batteryLevel": null
//    }, {
//        "value": "9116.19",
//        "readingContext": "Sample.Periodic",
//        "format": "Raw",
//        "measurand": "Power.Active.Import",
//        "location": null,
//        "unit": "W",
//        "chargeBoxId": "20210903036",
//        "status": "true",
//        "batteryLevel": null
//    }, {
//        "value": "90",
//        "readingContext": "Sample.Periodic",
//        "format": "Raw",
//        "measurand": "SoC",
//        "location": null,
//        "unit": "Percent",
//        "chargeBoxId": "20210903036",
//        "status": "true",
//        "batteryLevel": null
//    }, {
//        "value": "1244680",
//        "readingContext": "Sample.Periodic",
//        "format": "Raw",
//        "measurand": "Energy.Active.Import.Register",
//        "location": null,
//        "unit": "Wh",
//        "chargeBoxId": "20210903036",
//        "status": "true",
//        "batteryLevel": null
//    }, {
//        "value": "9484.34",
//        "readingContext": "Sample.Periodic",
//        "format": "Raw",
//        "measurand": "Power.Active.Import",
//        "location": null,
//        "unit": "W",
//        "chargeBoxId": "20210903036",
//        "status": "true",
//        "batteryLevel": null
//    }, {
//        "value": "1244700",
//        "readingContext": "Sample.Periodic",
//        "format": "Raw",
//        "measurand": "Energy.Active.Import.Register",
//        "location": null,
//        "unit": "Wh",
//        "chargeBoxId": "20210903036",
//        "status": "true",
//        "batteryLevel": null
//    }, {
//        "value": "9848.51",
//        "readingContext": "Sample.Periodic",
//        "format": "Raw",
//        "measurand": "Power.Active.Import",
//        "location": null,
//        "unit": "W",
//        "chargeBoxId": "20210903036",
//        "status": "true",
//        "batteryLevel": null
//    }, {
//        "value": "1244730",
//        "readingContext": "Sample.Periodic",
//        "format": "Raw",
//        "measurand": "Energy.Active.Import.Register",
//        "location": null,
//        "unit": "Wh",
//        "chargeBoxId": "20210903036",
//        "status": "true",
//        "batteryLevel": null
//    }, {
//        "value": "10196.8",
//        "readingContext": "Sample.Periodic",
//        "format": "Raw",
//        "measurand": "Power.Active.Import",
//        "location": null,
//        "unit": "W",
//        "chargeBoxId": "20210903036",
//        "status": "true",
//        "batteryLevel": null
//    }, {
//        "value": "19.8",
//        "readingContext": "Sample.Periodic",
//        "format": "Raw",
//        "measurand": "Current.Import",
//        "location": null,
//        "unit": "A",
//        "chargeBoxId": "20210903036",
//        "status": "true",
//        "batteryLevel": null
//    }, {
//        "value": "1244760",
//        "readingContext": "Sample.Periodic",
//        "format": "Raw",
//        "measurand": "Energy.Active.Import.Register",
//        "location": null,
//        "unit": "Wh",
//        "chargeBoxId": "20210903036",
//        "status": "true",
//        "batteryLevel": null
//    }, {
//        "value": "10301.9",
//        "readingContext": "Sample.Periodic",
//        "format": "Raw",
//        "measurand": "Power.Active.Import",
//        "location": null,
//        "unit": "W",
//        "chargeBoxId": "20210903036",
//        "status": "true",
//        "batteryLevel": null
//    }, {
//        "value": "1244790",
//        "readingContext": "Sample.Periodic",
//        "format": "Raw",
//        "measurand": "Energy.Active.Import.Register",
//        "location": null,
//        "unit": "Wh",
//        "chargeBoxId": "20210903036",
//        "status": "true",
//        "batteryLevel": null
//    }, {
//        "value": "10363.9",
//        "readingContext": "Sample.Periodic",
//        "format": "Raw",
//        "measurand": "Power.Active.Import",
//        "location": null,
//        "unit": "W",
//        "chargeBoxId": "20210903036",
//        "status": "true",
//        "batteryLevel": null
//    }, {
//        "value": "1244820",
//        "readingContext": "Sample.Periodic",
//        "format": "Raw",
//        "measurand": "Energy.Active.Import.Register",
//        "location": null,
//        "unit": "Wh",
//        "chargeBoxId": "20210903036",
//        "status": "true",
//        "batteryLevel": null
//    }, {
//        "value": "10367.9",
//        "readingContext": "Sample.Periodic",
//        "format": "Raw",
//        "measurand": "Power.Active.Import",
//        "location": null,
//        "unit": "W",
//        "chargeBoxId": "20210903036",
//        "status": "true",
//        "batteryLevel": null
//    }, {
//        "value": "1244850",
//        "readingContext": "Sample.Periodic",
//        "format": "Raw",
//        "measurand": "Energy.Active.Import.Register",
//        "location": null,
//        "unit": "Wh",
//        "chargeBoxId": "20210903036",
//        "status": "true",
//        "batteryLevel": null
//    }, {
//        "value": "11150",
//        "readingContext": "Sample.Periodic",
//        "format": "Raw",
//        "measurand": "Power.Active.Import",
//        "location": null,
//        "unit": "W",
//        "chargeBoxId": "20210903036",
//        "status": "true",
//        "batteryLevel": null
//    }, {
//        "value": "19.9",
//        "readingContext": "Sample.Periodic",
//        "format": "Raw",
//        "measurand": "Current.Import",
//        "location": null,
//        "unit": "A",
//        "chargeBoxId": "20210903036",
//        "status": "true",
//        "batteryLevel": null
//    }, {
//        "value": "1244890",
//        "readingContext": "Sample.Periodic",
//        "format": "Raw",
//        "measurand": "Energy.Active.Import.Register",
//        "location": null,
//        "unit": "Wh",
//        "chargeBoxId": "20210903036",
//        "status": "true",
//        "batteryLevel": null
//    }, {
//        "value": "11153.9",
//        "readingContext": "Sample.Periodic",
//        "format": "Raw",
//        "measurand": "Power.Active.Import",
//        "location": null,
//        "unit": "W",
//        "chargeBoxId": "20210903036",
//        "status": "true",
//        "batteryLevel": null
//    }, {
//        "value": "1244930",
//        "readingContext": "Sample.Periodic",
//        "format": "Raw",
//        "measurand": "Energy.Active.Import.Register",
//        "location": null,
//        "unit": "Wh",
//        "chargeBoxId": "20210903036",
//        "status": "true",
//        "batteryLevel": null
//    }, {
//        "value": "28303.3",
//        "readingContext": "Sample.Periodic",
//        "format": "Raw",
//        "measurand": "Power.Active.Import",
//        "location": null,
//        "unit": "W",
//        "chargeBoxId": "20210903036",
//        "status": "true",
//        "batteryLevel": null
//    }, {
//        "value": "50.1",
//        "readingContext": "Sample.Periodic",
//        "format": "Raw",
//        "measurand": "Current.Import",
//        "location": null,
//        "unit": "A",
//        "chargeBoxId": "20210903036",
//        "status": "true",
//        "batteryLevel": null
//    }, {
//        "value": "1245010",
//        "readingContext": "Sample.Periodic",
//        "format": "Raw",
//        "measurand": "Energy.Active.Import.Register",
//        "location": null,
//        "unit": "Wh",
//        "chargeBoxId": "20210903036",
//        "status": "true",
//        "batteryLevel": null
//    }, {
//        "value": "28476.8",
//        "readingContext": "Sample.Periodic",
//        "format": "Raw",
//        "measurand": "Power.Active.Import",
//        "location": null,
//        "unit": "W",
//        "chargeBoxId": "20210903036",
//        "status": "true",
//        "batteryLevel": null
//    }, {
//        "value": "80",
//        "readingContext": "Sample.Periodic",
//        "format": "Raw",
//        "measurand": "Current.Offered",
//        "location": null,
//        "unit": "A",
//        "chargeBoxId": "20210903036",
//        "status": "true",
//        "batteryLevel": null
//    }, {
//        "value": "60000",
//        "readingContext": "Sample.Periodic",
//        "format": "Raw",
//        "measurand": "Power.Offered",
//        "location": null,
//        "unit": "W",
//        "chargeBoxId": "20210903036",
//        "status": "true",
//        "batteryLevel": null
//    }, {
//        "value": "91",
//        "readingContext": "Sample.Periodic",
//        "format": "Raw",
//        "measurand": "SoC",
//        "location": null,
//        "unit": "Percent",
//        "chargeBoxId": "20210903036",
//        "status": "true",
//        "batteryLevel": null
//    }, {
//        "value": "49.9",
//        "readingContext": "Sample.Periodic",
//        "format": "Raw",
//        "measurand": "Current.Import",
//        "location": null,
//        "unit": "A",
//        "chargeBoxId": "20210903036",
//        "status": "true",
//        "batteryLevel": null
//    }, {
//        "value": "1245090",
//        "readingContext": "Sample.Periodic",
//        "format": "Raw",
//        "measurand": "Energy.Active.Import.Register",
//        "location": null,
//        "unit": "Wh",
//        "chargeBoxId": "20210903036",
//        "status": "true",
//        "batteryLevel": null
//    }, {
//        "value": "28393.1",
//        "readingContext": "Sample.Periodic",
//        "format": "Raw",
//        "measurand": "Power.Active.Import",
//        "location": null,
//        "unit": "W",
//        "chargeBoxId": "20210903036",
//        "status": "true",
//        "batteryLevel": null
//    }],
//    "batteryLevel": {
//        "batteryPercentage": "91",
//        "chargeBoxId": "20210903036"
//    },
//    "status": "true",
//    "error": "Transaction Stopped",
//    "stopValue": "1245130",
//    "startValue": "1244500",
//    "stopReason": "Remote",
//    "chargeBoxId": "20210903036",
//    "amount": 118.0,
//    "startTime": "19:19",
//    "stopTime": "19:22",
//    "date": "17 Jan 2023",
//    "totalTime": "0H:3M",
//    "paymentTransactionId": 41,
//    "transactionId": 359,
//    "amountDeducted": 14.37,
//    "corporateUser": false,
//    "totalTimes": 0.05,
//    "totalTimeTakenInMinutes": 3.0,
//    "timerBasedCharging": false,
//    "chargingTimeInMinutes": 0,
//    "totalTimeRemainingInMinutes": -3.0
//}
