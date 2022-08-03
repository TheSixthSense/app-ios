//
//  FeedRouter.swift
//  Home
//
//  Created by 문효재 on 2022/08/02.
//  Copyright © 2022 kr.co.thesixthsense. All rights reserved.
//

import RIBs

protocol FeedInteractable: Interactable {
    var router: FeedRouting? { get set }
    var listener: FeedListener? { get set }
}

protocol FeedViewControllable: ViewControllable {
    // TODO: Declare methods the router invokes to manipulate the view hierarchy.
}

final class FeedRouter: ViewableRouter<FeedInteractable, FeedViewControllable>, FeedRouting {

    // TODO: Constructor inject child builder protocols to allow building children.
    override init(interactor: FeedInteractable, viewController: FeedViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}
