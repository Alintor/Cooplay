//
//  EventsListViewController.swift
//  Cooplay
//
//  Created by Alexandr Ovchinnikov on 04/10/2019.
//

import DTTableViewManager
import DTModelStorage

final class EventsListViewController: UIViewController, EventsListViewInput, DTTableViewManageable {
    
    private enum Constant {
        
        static let profileDiameter: CGFloat = 32
        static let profileTrailingIndent: CGFloat = 16
        static let profilewBottomIndent: CGFloat = 12
        static let profileTopIndent: CGFloat = 4
    }

    @IBOutlet weak var tableView: UITableView!
    
    private var avatarView: AvatarView?
    
    // MARK: - View out

    var output: EventsListModuleInput?
    var viewIsReady: (() -> Void)?
    var dataSourceIsReady: ((_ dataSource: MemoryStorage) -> Void)?

    // MARK: - View in

    func setupInitialState() {
        navigationController?.navigationBar.prefersLargeTitles = true
        manager.startManaging(withDelegate: self)
        manager.configureEvents(for: ActiveEventCell.self) { cellType, modelType in
            manager.register(cellType) { $0.condition = .section(0) }
            manager.heightForCell(withItem: modelType) { _, _ in return UITableView.automaticDimension }
            manager.estimatedHeightForCell(withItem: modelType) { _, _ in return cellType.defaultHeight }
        }
        manager.configureEvents(for: EventCell.self) { cellType, modelType in
            manager.register(cellType) { $0.condition = .section(1) }
            manager.heightForCell(withItem: modelType) { _, _ in return UITableView.automaticDimension }
            manager.estimatedHeightForCell(withItem: modelType) { _, _ in return cellType.defaultHeight }
        }
        if let dataSource = manager.storage as? MemoryStorage {
            dataSourceIsReady?(dataSource)
        }
    }
    
    func updateProfile(with model: AvatarViewModel) {
        if avatarView == nil {
            avatarView = AvatarView(frame: CGRect(
                x: 0,
                y: 0,
                width: Constant.profileDiameter,
                height: Constant.profileDiameter
            ))
            // TODO: Set action
        }
        avatarView?.update(with: model)
        configureProfileView()
    }

	// MARK: - Life cycle

	override func viewDidLoad() {
		super.viewDidLoad()
		viewIsReady?()
	}
    
    override func viewDidAppear(_ animated: Bool) {
        configureProfileView()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        avatarView?.removeConstraints(avatarView?.constraints ?? [])
        avatarView?.removeFromSuperview()
    }
    
    // MARK: - Private
    
    private func configureProfileView() {
        guard let avatarView = avatarView else { return }
        navigationController?.navigationBar.addSubview(avatarView)
        let navigationBar = self.navigationController?.navigationBar
        let trailingContraint = NSLayoutConstraint(
            item: avatarView,
            attribute: .trailingMargin,
            relatedBy: .equal,
            toItem: navigationBar,
            attribute: .trailingMargin,
            multiplier: 1.0,
            constant: -Constant.profileTrailingIndent
        )
        let bottomConstraint = NSLayoutConstraint(
            item: avatarView,
            attribute: .bottom,
            relatedBy: .equal,
            toItem: navigationBar,
            attribute: .bottom,
            multiplier: 1.0,
            constant: -Constant.profilewBottomIndent
        )
        let topConstraint = NSLayoutConstraint(
            item: avatarView,
            attribute: .top,
            relatedBy: .greaterThanOrEqual,
            toItem: navigationBar,
            attribute: .top,
            multiplier: 1.0,
            constant: Constant.profileTopIndent
        )
        let heightConstraint = avatarView.heightAnchor.constraint(equalToConstant: Constant.profileDiameter)
        let widthConstraint = avatarView.widthAnchor.constraint(equalTo: avatarView.heightAnchor, multiplier: 1)
        bottomConstraint.priority = .defaultLow
        avatarView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            trailingContraint,
            bottomConstraint,
            topConstraint,
            heightConstraint,
            widthConstraint
        ])
    }
}
