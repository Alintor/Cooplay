//
//  EventDetailsViewController.swift
//  Cooplay
//
//  Created by Alexandr Ovchinnikov on 15/01/2020.
//

import DTTableViewManager
import DTModelStorage
import UIImageColors
import SwiftUI
import Combine

final class EventDetailsViewController: UIHostingController<EventDetailsView> {

    private weak var output: EventDetailsViewOutput?
    private var anyCancellable: AnyCancellable?
    
    init(contentView: EventDetailsView, output: EventDetailsViewOutput?) {
        self.output = output
        super.init(rootView: contentView)
    }
    
    @MainActor @objc required dynamic init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        anyCancellable?.cancel()
    }
    
    
//    func update(with model: EventDetailsViewModel) {
//        let oldTitle = titleLabel.text
//        titleLabel.text = model.title
//        gameChangeButtonTitle.text = model.title
//        dateLabel.text = model.date
//        dateChangeButtonTitle.text = model.date
//        if let coverPath = model.coverPath {
//            gameCoverImageView.setImage(withPath: coverPath, placeholder: R.image.commonGameCover()) { [weak self] image in
//                guard model.showGradient, model.title != oldTitle else { return }
//                image.getColors { colors in
//                    guard let `self` = self, let colors = colors else { return }
//                    let gradient = CAGradientLayer(layer: self.gradientView.layer)
//                    gradient.colors = [colors.secondary.cgColor, R.color.background()!.cgColor]
//                    gradient.locations = [0.0, 1.0]
//                    gradient.frame = self.gradientView.bounds
//                    self.gradientView.layer.sublayers?.forEach { $0.removeFromSuperlayer() }
//                    self.gradientView.layer.insertSublayer(gradient, at: 0)
//                    self.gradientView.alpha = 0
//                    UIView.animate(withDuration: 0.2) { [weak self] in
//                        self?.gradientView.alpha = 0.3
//                        self?.navigationController?.navigationBar.tintColor = R.color.textPrimary()
//                    }
//                }
//            }
//        } else {
//            gameCoverImageView.image = R.image.commonGameCover()
//        }
//    }
    
//    func updateState(with model: EventDetailsStateViewModel, animated: Bool) {
//        navigationItem.title = model.title
//        navigationItem.rightBarButtonItem = model.showDeleteButton ? deleteButton : (model.showEditButton ? editButton : nil)
//        navigationItem.leftBarButtonItem = model.showCancelButton ? cancelButton : nil
        

	// MARK: - Life cycle

	override func viewDidLoad() {
		super.viewDidLoad()
        output?.didLoad()
        anyCancellable = rootView.viewModel.$modeState.sink { [weak self] modeState in
            self?.configureNavigationItems(modeState: modeState)
        }
	}
    
    override public func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .never
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        //self.navigationController?.navigationBar.tintColor = R.color.actionAccent()
    }
    
    // MARK: - Actions
    
    
    @objc func editButtonTapped() {
        rootView.viewModel.changeEditMode()
    }
    
    @objc func deleteButtonTapped() {
        output?.deleteAction()
    }
    
    @objc func cancelButtonTapped() {
        rootView.viewModel.changeEditMode()
    }
    
    func configureNavigationItems(modeState: EventDetailsViewModel.State) {
        switch modeState {
        case .edit:
            navigationItem.title = R.string.localizable.eventDetailsEditTitle()
            navigationItem.setHidesBackButton(true, animated: true)
            navigationItem.leftBarButtonItem = UIBarButtonItem(
                title: R.string.localizable.commonCancel(),
                style: .plain,
                target: self,
                action: #selector(cancelButtonTapped)
            )
            let deleteButton = UIBarButtonItem(
                image: R.image.commonDelete(),
                style: .plain, target: self,
                action: #selector(deleteButtonTapped)
            )
            deleteButton.tintColor = R.color.red()
            navigationItem.rightBarButtonItem = deleteButton
        case .owner:
            navigationItem.title = nil
            navigationItem.leftBarButtonItem = nil
            navigationItem.setHidesBackButton(false, animated: true)
            navigationItem.rightBarButtonItem = UIBarButtonItem(
                image: R.image.commonEdit(),
                style: .plain, target: self,
                action: #selector(editButtonTapped)
            )
        case .member:
            navigationItem.title = nil
            navigationItem.leftBarButtonItem = nil
            navigationItem.setHidesBackButton(false, animated: true)
            navigationItem.rightBarButtonItem = nil
        }
    }
    
}
