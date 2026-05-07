//
//  ContrainerController.swift
//  ShikimoriPetApp
//
//  Created by Иван Илькив on 5/2/26.
//

import UIKit
import SnapKit
class ContainerController: UIViewController {
    
    let mainViewController = MainViewController()
    let sideMenuController = SideMenuController()
    var isMenuOpen: Bool = false
    private let dummmyView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.alpha = 0
        view.isHidden = true
        return view
    }()
  
    override func viewDidLoad() {
        super.viewDidLoad()
        setupChildsControllers()
    }
    private func setupChildsControllers(){
        addChild(mainViewController)
        view.addSubview(mainViewController.view)
        mainViewController.didMove(toParent: self)
        view.addSubview(dummmyView)
        
        dummmyView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        addChild(sideMenuController)
        view.addSubview(sideMenuController.view)
        sideMenuController.didMove(toParent: self)
        
       
        
        mainViewController.view.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        sideMenuController.view.layer.cornerRadius = 16
        sideMenuController.view.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(-40)
            make.bottom.equalTo(view.safeAreaLayoutGuide)
            make.leading.equalTo(view.snp.trailing)
            make.width.equalTo(250)
        }
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapGesture))
        dummmyView.addGestureRecognizer(tapGesture)
        
        mainViewController.delegate = self
        sideMenuController.delegate = self
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))
        view.addGestureRecognizer(panGestureRecognizer)
    }
    @objc private func handleTapGesture(){
        openMenu(false)
    }
    @objc private func handlePanGesture(_ gesture: UIPanGestureRecognizer){
        let translation = gesture.translation(in: view).x
        let velocity = gesture.velocity(in: view).x
        switch gesture.state{
        case .changed:
            let startOffset: CGFloat = isMenuOpen ? -250: 0
            let targetOffset: CGFloat = startOffset + translation
            let clampedOffset = max(-250, min(0, targetOffset))
            let percentOpened = abs(clampedOffset) / 250
            sideMenuController.view.snp.updateConstraints { make in
                make.leading.equalTo(view.snp.trailing).offset(clampedOffset)
            }
            dummmyView.isHidden = false
            dummmyView.alpha = percentOpened * 0.5
            view.layoutIfNeeded()
        case  .ended:
            let shouldOpen: Bool

            if isMenuOpen {
                shouldOpen = translation <= 125 && velocity <= 500
            } else {
                shouldOpen = translation < -125 || velocity < -500
            }
            openMenu(shouldOpen)
        default: return
        }
    }
    private func openMenu(_ open: Bool) {
        isMenuOpen = open
        let offset: CGFloat = open ? -250 : 0
        if open {
               dummmyView.isHidden = false
           }
        sideMenuController.view.snp.updateConstraints { make in
            make.leading.equalTo(view.snp.trailing).offset(offset)
        }
        
        UIView.animate(
            withDuration: 0.4,
            delay: 0,
            usingSpringWithDamping: 0.85,
            initialSpringVelocity: 0.5,
            animations:{
                self.view.layoutIfNeeded()
                self.dummmyView.alpha = open ? 0.5: 0
            }, completion: { _ in
                if !open{
                    self.dummmyView.isHidden = true
                }
                
            }
        )
    }
  
}
extension ContainerController: MainViewControllerDelegate{
    func didApplyFilters(filter: Filters) {
        mainViewController.viewModel.filters = filter
    }
    
    func didTapMenuButton() {
        openMenu(!isMenuOpen)
    }
    func switchType(type: ContentType) {
        mainViewController.viewModel.filters = Filters(page: 1, order: .ranked, kind: nil, status: nil)
        sideMenuController.viewModel.restoreFilters()
        sideMenuController.viewModel.type = type
    }
}
