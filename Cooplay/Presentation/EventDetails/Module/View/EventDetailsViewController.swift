//
//  EventDetailsViewController.swift
//  Cooplay
//
//  Created by Alexandr Ovchinnikov on 15/01/2020.
//

import DTTableViewManager
import DTModelStorage

final class EventDetailsViewController: UIViewController, EventDetailsViewInput, DTTableViewManageable {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var gameCoverImageView: UIImageView!
    @IBOutlet weak var statusTitle: UILabel!
    @IBOutlet weak var statusIconImageView: UIImageView!
    @IBOutlet weak var statusIconView: UIView!
    @IBOutlet weak var statusView: UIView!
    @IBOutlet weak var avatarView: AvatarView!
    @IBOutlet weak var arrowImageView: UIImageView!
    
    var editButton: UIBarButtonItem?
    var addMemberView: UIView?
    
    // MARK: - View out

    var output: EventDetailsModuleInput?
    var viewIsReady: (() -> Void)?
    var statusAction: ((_ delegate: StatusContextDelegate?) -> Void)?
    var dataSourceIsReady: ((_ dataSource: MemoryStorage) -> Void)?
    var itemSelected: ((_ item: EventDetailsCellViewModel, _ delegate: StatusContextDelegate?) -> Void)?

    // MARK: - View in

    func setupInitialState() {
        navigationItem.largeTitleDisplayMode = .never
        editButton = UIBarButtonItem(image: R.image.commonEdit(), style: .plain, target: self, action: #selector(editButtonTapped))
        navigationItem.rightBarButtonItem = editButton
        addMemberView = tableView.tableFooterView
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
        dateLabel.text = model.date
        gameCoverImageView.setImage(withPath: model.coverPath)
        avatarView.update(with: model.avatarViewModel)
        statusTitle.text = model.statusTitle
        statusIconImageView.image = model.statusIcon
        statusIconView.backgroundColor = model.statusColor
        navigationItem.rightBarButtonItem = model.showEditButton ? editButton : nil
        tableView.tableFooterView = model.showEditButton ? addMemberView : nil
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
    
    // MARK: - Actions
    
    @IBAction func statusViewTapped(_ sender: UITapGestureRecognizer) {
        statusAction?(self)
    }
    @IBAction func addMemberViewTapped(_ sender: UITapGestureRecognizer) {
    }
    
    @objc func editButtonTapped() {
        
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
