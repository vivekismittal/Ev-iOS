//
//  ViewExtension.swift
//  EVApp
//
//  Created by VM on 18/07/24.
//

import SwiftUI

extension View{
    
    func getUIKitView()->UIView{
        let hostingController = UIHostingController(rootView: self)
        return hostingController.view
    }
    
    func addViewTo(superView: UIView){
        let uiView = self.getUIKitView()
        uiView.backgroundColor = .clear
        uiView.translatesAutoresizingMaskIntoConstraints = false
        
        superView.addSubview(uiView)
        
        NSLayoutConstraint.activate([
            uiView.topAnchor.constraint(equalTo: superView.topAnchor),
            uiView.leftAnchor.constraint(equalTo: superView.leftAnchor),
            uiView.rightAnchor.constraint(equalTo: superView.rightAnchor),
            uiView.bottomAnchor.constraint(equalTo: superView.bottomAnchor),
        ])
    }
}

