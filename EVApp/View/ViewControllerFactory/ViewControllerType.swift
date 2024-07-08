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
    case ChargingStationScreen
    case ChargingEstimationScreen
    case AvailableCouponScreen
    case StartChargingScreen
    case ChargingWaitingScreen
    case OnGoingChargingScreen
    case UserChargingSessionsScreen
    case AddMoneyScreen
    case MyWalletScreen
    case ChargingInvoiceScreen
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
    case ChargingStationVC
    case ChargingUnitVC
    case AvailableCouponVC
    case StartChargingVC
    case WaitingVC
    case ChargingVC
    case ChargingSessionVC
    case AddMoneyVC
    case WalletVC
    case TransactionDetailsVC
}

extension ViewControllerType{
    
    func storyboardRepresentation() -> StoryboardRepresentation {
        return switch self {
        case .HomeDashboard:
            StoryboardRepresentation(bundle: nil, storyboardName: .Main, storyboardId: .DashboardVC)
        case .MenuNavigation:
            StoryboardRepresentation(bundle: nil, storyboardName: .Main, storyboardId: .MenuNavigationPoint)
        case .ChargerPanel:
            StoryboardRepresentation(bundle: nil, storyboardName: .Main, storyboardId: .PanelViewVC)
            
        case .WelcomeScreen:
            StoryboardRepresentation(bundle: nil, storyboardName: .AuthStoryBoard, storyboardId: .WelcomeVC)
        case .SignupBottomSheetForGuest:
            StoryboardRepresentation(bundle: nil, storyboardName: .AuthStoryBoard, storyboardId: .GuestSignupViewController)
        case .UserRegistrationScreen:
            StoryboardRepresentation(bundle: nil, storyboardName: .AuthStoryBoard, storyboardId: .RegistrationVC)
            
        case .AvailableCharger:
            StoryboardRepresentation(bundle: nil, storyboardName: .ChargingStoryBoard, storyboardId: .AvailableConnectorsVC)
        case .ChargingDetail:
            StoryboardRepresentation(bundle: nil, storyboardName: .ChargingStoryBoard, storyboardId: .ChargingDetailVC)
        case .ChargingStationScreen:
            StoryboardRepresentation(bundle: nil, storyboardName: .ChargingStoryBoard, storyboardId: .ChargingStationVC)
        case .ChargingEstimationScreen:
            StoryboardRepresentation(bundle: nil, storyboardName: .ChargingStoryBoard, storyboardId: .ChargingUnitVC)
        case .AvailableCouponScreen:
            StoryboardRepresentation(bundle: nil, storyboardName: .ChargingStoryBoard, storyboardId: .AvailableCouponVC)
        case .StartChargingScreen:
            StoryboardRepresentation(bundle: nil, storyboardName: .ChargingStoryBoard, storyboardId: .StartChargingVC)
        case .ChargingWaitingScreen:
            StoryboardRepresentation(bundle: nil, storyboardName: .ChargingStoryBoard, storyboardId: .WaitingVC)
        case .OnGoingChargingScreen:
            StoryboardRepresentation(bundle: nil, storyboardName: .ChargingStoryBoard, storyboardId: .ChargingVC)
        case .UserChargingSessionsScreen:
            StoryboardRepresentation(bundle: nil, storyboardName: .ChargingStoryBoard, storyboardId: .ChargingSessionVC)
        case .ChargingInvoiceScreen:
            StoryboardRepresentation(bundle: nil, storyboardName: .ChargingStoryBoard, storyboardId: .TransactionDetailsVC)
            
        case .AddMoneyScreen:
            StoryboardRepresentation(bundle: nil, storyboardName: .WalletStoryBoard, storyboardId: .AddMoneyVC)
        case .MyWalletScreen:
            StoryboardRepresentation(bundle: nil, storyboardName: .WalletStoryBoard, storyboardId: .WalletVC)
        }
    }
}
