//
//  DimmingPresentationController.swift
//  AppStoreSearch
//
//  Created by Federico Pugnaloni on 07/02/2019.
//  Copyright © 2019 Federico Pugnaloni. All rights reserved.
//

import UIKit

class DimmingPresentationController: UIPresentationController {
    lazy var dimmingView = GradientView(frame: CGRect.zero)
    override var shouldRemovePresentersView: Bool {
        return false
    }
    
    override func presentationTransitionWillBegin() {
        dimmingView.frame = containerView!.bounds
        containerView!.insertSubview(dimmingView, at: 0)
    }
}
