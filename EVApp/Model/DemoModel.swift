//
//  DemoModel.swift
//  EVApp
//
//  Created by Brijesh Bhardwaj on 20/06/23.
//

import Foundation

struct CheckLoginSignUpModel: Decodable {
    var formActionResponse: FormActionResponse
    var rolefetch: [Rolefetch]?
   // var mobilefetch: [mobilefetch]?

    enum CodingKeys: String, CodingKey {
        case formActionResponse = "FORM_ACTION_RESPONSE"
        case rolefetch = "ROLEFETCH"
      
      //  case mobilefetch = "MOBILEFETCH"
    }
}

struct Rolefetch: Decodable {
    var id: String
    var realID: Int
    var userCodePre: String?
    var userCode: Int?
    var user: User?
    var role: Role?
    var createdBy: Int?
    var status, created: String?

    enum CodingKeys: String, CodingKey {
        case id
        case realID = "real_id"
        case userCodePre = "user_code_pre"
        case userCode = "user_code"
        case role, user
        case createdBy = "created_by"
        case status, created
    }
}

struct AddPropertyResponse : Decodable {
    var PROPERTY: Property
    var FORM_ACTION_RESPONSE: FormActionResponse
}

struct FormActionResponse: Decodable {
    var message: String?
    var type: String?
}

struct Property: Decodable {
    let area : String?
    let house_type : String?
    let avail_from : String?
}
enum LoginType: String {
    case danger = "danger"
    case success = "success"
}

struct SignUpResponse: Decodable {
    var FORM_ACTION_RESPONSE: FormActionResponse?
    var USER: User?
}

struct User: Decodable {
    let address: String
    let age: Int
    let email_address: String
    let gender: String
    let real_id: Int
    let name: String
    let phone_number: String
    let id: String
    let panid : String
    let adharid : String
    let linked_in : String
    let occupation_user : String
    let companytype_user : String
}

enum UserCodeProType: String {
    case broker = "BROKER"
    case tenant = "TENANT"
    case landlord = "LANDLORD"
}

struct UserRoleResponse : Decodable {
    var USERROLE : UserRole
}

struct UserRole : Decodable {
    var real_id: Int
    var user : User
    var role: Role
    var user_code_pre : String
    var user_code : Int
}

struct Role: Decodable {
    var id: String
    var name: String
    var description: String
    var status: String
    var created: String
    
}

struct SentFriendListReponse: Decodable {
    var SENTFRIENDLISTALL: [SentFriendListAll]
    var FORM_ACTION_RESPONSE: FormActionResponse
}

struct SentFriendListAll: Decodable {
    var approval: String
    var created_by: Int
    var user: User
    var tenant_id: TenantID
}

struct TenantID: Decodable {
    var user: User
    
}
