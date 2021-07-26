//
//  EventDetailsViewController.swift
//  Cooplay
//
//  Created by Alexandr Ovchinnikov on 15/01/2020.
//

import DTTableViewManager
import DTModelStorage
import UIImageColors

final class EventDetailsViewController: UIViewController, EventDetailsViewInput, DTTableViewManageable {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var editInfoView: UIView!
    @IBOutlet weak var infoView: UIView!
    @IBOutlet weak var infoStackView: UIStackView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var gameChangeButtonView: UIView!
    @IBOutlet weak var gameChangeButtonTitle: UILabel!
    @IBOutlet weak var gameChangeButtonIcon: UIImageView!
    @IBOutlet weak var dateChangeButtonView: UIView!
    @IBOutlet weak var dateChangeButtonTitle: UILabel!
    @IBOutlet weak var dateChangeButtonIcon: UIImageView!
    @IBOutlet weak var gameCoverImageView: UIImageView!
    @IBOutlet weak var statusTitle: UILabel!
    @IBOutlet weak var statusIconImageView: UIImageView!
    @IBOutlet weak var statusIconView: UIView!
    @IBOutlet weak var statusView: UIView!
    @IBOutlet weak var avatarView: AvatarView!
    @IBOutlet weak var arrowImageView: UIImageView!
    @IBOutlet weak var gradientView: UIView!
    
    var editButton: UIBarButtonItem?
    var deleteButton: UIBarButtonItem?
    var cancelButton: UIBarButtonItem?
    var addMemberView: UIView?
    
    // MARK: - View out

    var output: EventDetailsModuleInput?
    var viewIsReady: (() -> Void)?
    var statusAction: ((_ delegate: StatusContextDelegate?) -> Void)?
    var dataSourceIsReady: ((_ dataSource: MemoryStorage) -> Void)?
    var itemSelected: ((_ item: EventDetailsCellViewModel, _ delegate: StatusContextDelegate?) -> Void)?
    var editAction: (() -> Void)?
    var deleteAction: (() -> Void)?
    var cancelAction: (() -> Void)?
    var changeGameAction: (() -> Void)?
    var changeDateAction: (() -> Void)?
    var addMemberAction: (() -> Void)?

    // MARK: - View in

    func setupInitialState() {
        navigationItem.largeTitleDisplayMode = .never
        editButton = UIBarButtonItem(image: R.image.commonEdit(), style: .plain, target: self, action: #selector(editButtonTapped))
        cancelButton = UIBarButtonItem(title: R.string.localizable.commonCancel(), style: .plain, target: self, action: #selector(cancelButtonTapped))
        deleteButton = UIBarButtonItem(image: R.image.commonDelete(), style: .plain, target: self, action: #selector(deleteButtonTapped))
        deleteButton?.tintColor = R.color.red()
        addMemberView = tableView.tableFooterView
        addMemberView?.alpha = 0
        tableView.tableFooterView = nil
        manager.startManaging(withDelegate: self)
        manager.configureEvents(for: EventDetailsMemberCell.self) { cellType, _ in
            manager.register(cellType)
            manager.didSelect(cellType) { [weak self] cell, model, _ in
                self?.itemSelected?(model, cell)
            }
        }
        manager.tableViewUpdater?.didUpdateContent = { [weak self] update in
            self?.tableView.isHidden = false
        }
        if let dataSource = manager.storage as? MemoryStorage {
            dataSourceIsReady?(dataSource)
        }
    }
    
    func update(with model: EventDetailsViewModel) {
        titleLabel.text = model.title
        gameChangeButtonTitle.text = model.title
        dateLabel.text = model.date
        dateChangeButtonTitle.text = model.date
        if let coverPath = model.coverPath {
            gameCoverImageView.setImage(withPath: coverPath, placeholder: R.image.commonGameCover()) { [weak self] image in
                image.getColors(quality: .highest) { colors in
                    guard let `self` = self, let colors = colors, model.showGradient else { return }
                    let gradient = CAGradientLayer(layer: self.gradientView.layer)
                    gradient.colors = [colors.secondary.cgColor, R.color.background()!.cgColor]
                    gradient.locations = [0.0, 1.0]
                    gradient.frame = self.gradientView.bounds
                    self.gradientView.layer.insertSublayer(gradient, at: 0)
                    self.gradientView.alpha = 0
                    UIView.animate(withDuration: 0.2) { [weak self] in
                        self?.gradientView.alpha = 0.3
                        self?.navigationController?.navigationBar.tintColor = R.color.textPrimary()
                    }
                }
            }
        } else {
            gameCoverImageView.image = R.image.commonGameCover()
        }
        avatarView.update(with: model.avatarViewModel)
        statusTitle.text = model.statusTitle
        statusIconImageView.image = model.statusIcon
        statusIconView.backgroundColor = model.statusColor
        gradientView.isHidden = !model.showGradient
    }
    
    func updateState(with model: EventDetailsStateViewModel, animated: Bool) {
        navigationItem.title = model.title
        navigationItem.rightBarButtonItem = model.showDeleteButton ? deleteButton : (model.showEditButton ? editButton : nil)
        navigationItem.leftBarButtonItem = model.showCancelButton ? cancelButton : nil
        tableView.layoutIfNeeded()
        guard animated else {
            self.editInfoView.isHidden = !model.showEditPanel
            self.infoView.isHidden = model.showEditPanel
            statusView.isUserInteractionEnabled = model.hideStatus ? false : true
            statusView.alpha = model.hideStatus ? 0.3 : 1
            tableView.tableFooterView = model.showEditPanel ? addMemberView : nil
            gradientView.isHidden = !model.showGradient
            return
        }
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.prepare()
        let transformScale: CGFloat = 0.9
        let hideAlpha: CGFloat = 0.5
        UIView.animate(
            withDuration: 0.1,
            delay: 0,
            options: .curveEaseIn,
            animations: {
                if model.showEditPanel {
                    self.infoView.alpha = hideAlpha
                    self.infoView.transform = CGAffineTransform(scaleX: transformScale, y: transformScale)
                } else {
                    self.editInfoView.alpha = hideAlpha
                    self.editInfoView.transform = CGAffineTransform(scaleX: transformScale, y: transformScale)
                }
        }) { (_) in
            generator.impactOccurred()
            self.editInfoView.isHidden = !model.showEditPanel
            self.infoView.isHidden = model.showEditPanel
            self.gradientView.isHidden = !model.showGradient
            if model.showEditPanel {
                self.editInfoView.alpha = hideAlpha
                self.editInfoView.transform = CGAffineTransform(scaleX: transformScale, y: transformScale)
                self.infoView.alpha = 1
                self.infoView.transform = .identity
            } else {
                self.infoView.alpha = hideAlpha
                self.infoView.transform = CGAffineTransform(scaleX: transformScale, y: transformScale)
                self.editInfoView.alpha = 1
                self.editInfoView.transform = .identity
            }
            UIView.animate(
                withDuration: 0.2,
                delay: 0,
                usingSpringWithDamping: 0.8,
                initialSpringVelocity: 0,
                options: .curveEaseOut,
                animations: {
                    if model.showEditPanel {
                        self.editInfoView.alpha = 1
                        self.editInfoView.transform = .identity
                        //self.gradientView.alpha = 0
                    } else {
                        self.infoView.alpha = 1
                        self.infoView.transform = .identity
                        //self.gradientView.alpha = 0.3
                    }
            })
        }
        if model.showEditPanel {
            addMemberView?.alpha = 0
            tableView.tableFooterView = addMemberView
            addMemberView?.transform = CGAffineTransform(scaleX: 1, y: 0.8).translatedBy(x: 0, y: -20)
        }
        UIView.animate(
            withDuration: 0.2,
            delay: model.showEditPanel ? 0.1 : 0,
            usingSpringWithDamping: 0.8,
            initialSpringVelocity: 0,
            options: .curveEaseInOut,
            animations: {
                self.statusView.isUserInteractionEnabled = model.hideStatus ? false : true
                self.statusView.alpha = model.hideStatus ? 0.3 : 1
                self.addMemberView?.alpha = model.showEditPanel ? 1 : 0
                self.addMemberView?.transform = model.showEditPanel ? .identity
                    : CGAffineTransform(scaleX: 1, y: 0.8).translatedBy(x: 0, y: -20)
            }
        ) { (_) in
            if !model.showEditPanel {
                self.addMemberView?.transform = .identity
                self.tableView.tableFooterView = nil
                self.addMemberView?.alpha = 1
                
            }
        }
    }

	// MARK: - Life cycle

	override func viewDidLoad() {
		super.viewDidLoad()
		viewIsReady?()
	}
    
    override public func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        updateHeaderViewHeight()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.tintColor = R.color.actionAccent()
    }
    
    // MARK: - Actions
    
    @IBAction func statusViewTapped(_ sender: UITapGestureRecognizer) {
        statusAction?(self)
    }
    @IBAction func addMemberViewTapped(_ sender: UITapGestureRecognizer) {
        addMemberAction?()
    }
    
    @objc func editButtonTapped() {
        editAction?()
    }
    
    @objc func deleteButtonTapped() {
        deleteAction?()
    }
    
    @objc func cancelButtonTapped() {
        cancelAction?()
    }
    
    @IBAction func changeGameButtonTapped(_ sender: UITapGestureRecognizer) {
        changeGameAction?()
    }
    
    @IBAction func changeDateButtonTapped(_ sender: UITapGestureRecognizer) {
        changeDateAction?()
    }
    
    
    // MARK: - Private
    
    private func updateHeaderViewHeight() {
        guard let headerView = tableView.tableHeaderView else { return }
        let size = headerView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
        if headerView.frame.size.height != size.height {
            headerView.frame.size.height = size.height
            tableView.tableHeaderView = headerView
            tableView.layoutIfNeeded()
        }
    }
    
}

extension EventDetailsViewController: StatusContextDelegate {
    var targetView: UIView {
        return statusView
    }
    
    func prepareView(completion: @escaping () -> Void) {
        UIView.animate(withDuration: 0.1, animations: {
            self.arrowImageView.transform = CGAffineTransform(rotationAngle: .pi)
        }) { (_) in
            completion()
        }
    }
    
    func restoreView(with menuItem: MenuItem?) {
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseOut, animations: {
            self.arrowImageView.transform = .identity
            if let status = menuItem?.value as? User.Status {
                self.statusTitle.text = status.title()
                self.statusIconImageView.image = status.icon()
                self.statusIconView.backgroundColor = status.color
            }
        })
    }
}

extension EventDetailsViewController: NewEventTimePickerViewDelegate {
    
    
    var timeButtonView: UIView {
        return dateChangeButtonView
    }
    
    func prepareTimeView(completion: @escaping () -> Void) {
        completion()
    }
    
    func restoreView() {
        
    }
}
extension EventDetailsViewController: TimeCarouselContextDelegate {
    
    var targetButtonView: UIView {
        return dateChangeButtonView
    }
}
