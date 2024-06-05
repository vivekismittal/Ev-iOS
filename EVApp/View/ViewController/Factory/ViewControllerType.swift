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
    case WelcomeScreen
}

enum ViewControllerIdentifier: String{
    case AvailableConnectorsVC
    case ChargingDetailVC
    case WelcomeVC
}

extension ViewControllerType{
    
    func storyboardRepresentation() -> StoryboardRepresentation {
        return switch self {
        case .AvailableCharger:
            StoryboardRepresentation(bundle: nil, storyboardName: .DetailStoryBoard, storyboardId: .AvailableConnectorsVC)
        case .ChargingDetail:
            StoryboardRepresentation(bundle: nil, storyboardName: .DetailStoryBoard, storyboardId: .ChargingDetailVC)
        case .WelcomeScreen:
            StoryboardRepresentation(bundle: nil, storyboardName: .AuthStoryBoard, storyboardId: .WelcomeVC)
        }
    }
}
