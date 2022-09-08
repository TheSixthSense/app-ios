//
//  ChallengeListRouter.swift
//  Home
//
//  Created by 문효재 on 2022/08/02.
//  Copyright © 2022 kr.co.thesixthsense. All rights reserved.
//

import RIBs
import Challenge

protocol ChallengeListInteractable: Interactable,
                                    ChallengeCheckListener,
                                    ChallengeDetailListener {
    var router: ChallengeListRouting? { get set }
    var listener: ChallengeListListener? { get set }
}

protocol ChallengeListViewControllable: ViewControllable {
    // TODO: Declare methods the router invokes to manipulate the view hierarchy.
}

final class ChallengeListRouter: ViewableRouter<ChallengeListInteractable, ChallengeListViewControllable>, ChallengeListRouting {
    private var childRouting: ViewableRouting?
    private let checkBuilder: ChallengeCheckBuildable
    private let detailBuilder: ChallengeDetailBuildable

    
    // TODO: Constructor inject child builder protocols to allow building children.
    init(interactor: ChallengeListInteractable,
         viewController: ChallengeListViewControllable,
         checkBuilder: ChallengeCheckBuildable,
         detailBuilder: ChallengeDetailBuildable) {
        self.checkBuilder = checkBuilder
        self.detailBuilder = detailBuilder
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
    
    func routeToRegister() {
        viewControllable.uiviewController.tabBarController?.selectedIndex = 1
    }
    
    func attachCheck() {
        if childRouting != nil { return }
        
        let router = checkBuilder.build(withListener: interactor)
        let viewController = router.viewControllable
        viewController.uiviewController.modalPresentationStyle = .fullScreen
        viewController.uiviewController.hidesBottomBarWhenPushed = true
        viewControllable.pushViewController(viewController, animated: true)
        
        attachChild(router)
        self.childRouting = router
    }
    
    func detachCheck() {
        guard let router = childRouting else { return }
        router.viewControllable.popViewController(animated: true)
        detachChild(router)
        self.childRouting = nil
    }

    func attachDetail(id: String) {
        if childRouting != nil { return }
        
        let router = detailBuilder.build(withListener: interactor, id: id)
        let viewController = router.viewControllable
        viewController.uiviewController.modalPresentationStyle = .fullScreen
        viewControllable.present(viewController, animated: true)
        
        attachChild(router)
        self.childRouting = router
    }
    
    func detachDetail() {
        guard let router = childRouting else { return }
        router.viewControllable.dismiss(animated: true, completion: nil)
        detachChild(router)
        self.childRouting = nil
    }
}
