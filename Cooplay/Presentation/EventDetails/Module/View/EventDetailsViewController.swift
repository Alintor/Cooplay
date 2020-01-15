//
//  EventDetailsViewController.swift
//  Cooplay
//
//  Created by Alexandr Ovchinnikov on 15/01/2020.
//

import UIKit

final class EventDetailsViewController: UIViewController, EventDetailsViewInput {

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
    
    // MARK: - View out

    var output: EventDetailsModuleInput?
    var viewIsReady: (() -> Void)?
    var statusAction: ((_ delegate: StatusContextDelegate?) -> Void)?

    // MARK: - View in

    func setupInitialState() {
        navigationItem.largeTitleDisplayMode = .never
    }
    
    func update(with model: EventDetailsViewModel) {
        titleLabel.text = model.title
        dateLabel.text = model.date
        gameCoverImageView.setImage(withPath: model.coverPath)
        avatarView.update(with: model.avatarViewModel)
        statusTitle.text = model.statusTitle
        statusIconImageView.image = model.statusIcon
        statusIconView.backgroundColor = model.statusColor
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
