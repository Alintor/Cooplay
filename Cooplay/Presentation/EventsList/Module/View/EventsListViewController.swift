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
        tableView.isHidden = true
        navigationController?.navigationBar.prefersLargeTitles = true
        manager.startManaging(withDelegate: self)
        manager.configureEvents(for: ActiveEventCell.self) { cellType, modelType in
            manager.register(cellType) { $0.condition = .section(0) }
            manager.heightForCell(withItem: modelType) { _, _ in return UITableView.automaticDimension }
            manager.estimatedHeightForCell(withItem: modelType) { _, _ in return cellType.defaultHeight }
        }
        manager.registerNiblessHeader(EventSectionHeaderView.self)
        manager.heightForHeader(withItem: String.self) { _, _ in
            return UITableView.automaticDimension
        }
        manager.estimatedHeightForHeader(withItem: String.self) { _, _ in
            return 50
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
    
    func showItems() {
        tableView.isHidden = false
        var sectionHeaders = [UIView]()
        for sectionIndex in 0...tableView.numberOfSections - 1 {
            if let sectionHeader = tableView.headerView(forSection: sectionIndex) {
                sectionHeader.alpha = 0
                sectionHeaders.append(sectionHeader)
            }
        }
        var delay: TimeInterval = 0
        for cell in tableView.visibleCells {
            cell.transform = CGAffineTransform(translationX: 0, y: view.frame.height)
            UIView.animate(withDuration: 0.8, delay: delay, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseOut, animations: {
                cell.transform = .identity
            }) { (_) in
                guard cell == self.tableView.visibleCells.last else { return }
                for sectionHeader in sectionHeaders {
                    UIView.animate(withDuration: 0.3, animations: {
                        sectionHeader.alpha = 1
                    })
                }
            }
            delay += 0.2
        }
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
