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
    case HomeDashboard
    case MenuNavigation
    case ChargerPanel
    case SignupBottomSheetForGuest
    case UserRegistrationScreen
}

enum ViewControllerIdentifier: String{
    case AvailableConnectorsVC
    case ChargingDetailVC
    case WelcomeVC
    case DashboardVC
    case MenuNavigationPoint
    case IntroPageContentViewController
    case PanelViewVC
    case GuestSignupViewController
    case RegistrationVC
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
        case .HomeDashboard:
            StoryboardRepresentation(bundle: nil, storyboardName: .Main, storyboardId: .DashboardVC)
        case .MenuNavigation:
            StoryboardRepresentation(bundle: nil, storyboardName: .Main, storyboardId: .MenuNavigationPoint)
        case .ChargerPanel:
            StoryboardRepresentation(bundle: nil, storyboardName: .Main, storyboardId: .PanelViewVC)
        case .SignupBottomSheetForGuest:
            StoryboardRepresentation(bundle: nil, storyboardName: .AuthStoryBoard, storyboardId: .GuestSignupViewController)
        case .UserRegistrationScreen:
            StoryboardRepresentation(bundle: nil, storyboardName: .AuthStoryBoard, storyboardId: .RegistrationVC)
        }
    }
}
