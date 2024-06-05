//
//  ViewControllerType.swift
//  EVApp
//
//  Created by VM on 02/06/24.
//

import Foundation

enum ViewControllerType{
    case AvailableCharger
    case ChargingDetail
}

enum ViewControllerIdentifier: String{
    case AvailableConnectorsVC
    case ChargingDetailVC
}

extension ViewControllerType{
    
    func storyboardRepresentation() -> StoryboardRepresentation {
        return switch self {
        case .AvailableCharger:
            StoryboardRepresentation(bundle: nil, storyboardName: .Main, storyboardId: .AvailableConnectorsVC)
        case .ChargingDetail:
            StoryboardRepresentation(bundle: nil, storyboardName: .Main, storyboardId: .ChargingDetailVC)
        }
    }
}
