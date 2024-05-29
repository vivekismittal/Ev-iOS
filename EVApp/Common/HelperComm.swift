//
//  HelperComm.swift
//  EVApp
//
//  Created by Brijesh Bhardwaj on 20/06/23.
//

import Foundation

enum StoryBoards: String {
    case Main = "Main"
    case Dashboard = "Dashboard"
    case Landloard = "Landloard"
    case common = "Common"
    case Broker = "Broker"
}

enum UserDefaultConstants: String {
    case email = "email"
    case realId = "real_id"
    case phoneNumber = "phone_number"
    case name = "name"
    case id = "id"
    case userRoleRealId =  "user_role_real_id"
    case roleFetchRealId = "role_fetch_real_id"
    case userCodePre = "user_code_pre"
    case propertyNameType = "prop_name_typ"
//    case newUserRoleRealID = "new_user_real_id"
    case incomingOwnUserRoleRealId = "own_user_role_id"
    case userName = "userName"
    case userCode = "user_code"
    case newUserRoleRealId = "USERROLE_real_id"
    case userPropertyRealId = "USER_PROPERTY_real_id"
    case commPropertyRealId  = "comm_real_id"
}

enum UserType: String {
    case tenant = "1"
    case broker = "2"
    case landloard = "3"
}

enum FriendRequest: String {
    case pending = "pending", approve = "approve", reject = "reject"
}
