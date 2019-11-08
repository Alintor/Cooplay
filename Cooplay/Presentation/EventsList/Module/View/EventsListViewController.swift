//
//  EventsListViewController.swift
//  Cooplay
//
//  Created by Alexandr Ovchinnikov on 04/10/2019.
//

import DTTableViewManager
import DTModelStorage
import iCarousel

final class EventsListViewController: UIViewController, EventsListViewInput, DTTableViewManageable {
    @IBOutlet weak var actionButtonView: UIView!
    @IBOutlet weak var actionButtonTrailingConstraint: NSLayoutConstraint!
    
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
        tableView.contentInset.bottom = 66
        actionButtonView.transform = CGAffineTransform(translationX: 66, y: 0)
        let tapGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(actionButtonTapHandler))
        tapGestureRecognizer.minimumPressDuration = 0
        actionButtonView.addGestureRecognizer(tapGestureRecognizer)
        navigationController?.navigationBar.prefersLargeTitles = true
        manager.startManaging(withDelegate: self)
        manager.configureEvents(for: ActiveEventCell.self) { cellType, modelType in
            manager.register(cellType) { $0.condition = .section(0) }
            manager.didSelect(cellType) { (cell, model, _) in
                print("Event selected!")
            }
            manager.didHighlight(cellType) { (cell, _, _) in
                UIView.animate(withDuration: 0.1, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseOut, animations: {
                    cell.transform = CGAffineTransform(scaleX: 0.98, y: 0.98)
                })
            }
            manager.didUnhighlight(cellType) { (cell, _, _) in
                UIView.animate(withDuration: 0.1, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseOut, animations: {
                    cell.transform = .identity
                })
            }
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
            manager.didHighlight(cellType) { (cell, _, _) in
                UIView.animate(withDuration: 0.1, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseOut, animations: {
                    cell.transform = CGAffineTransform(scaleX: 0.98, y: 0.98)
                })
            }
            manager.didUnhighlight(cellType) { (cell, _, _) in
                UIView.animate(withDuration: 0.1, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseOut, animations: {
                    cell.transform = .identity
                })
            }
            manager.heightForCell(withItem: modelType) { _, _ in return UITableView.automaticDimension }
            manager.estimatedHeightForCell(withItem: modelType) { _, _ in return cellType.defaultHeight }
        }
        
        manager.tableViewUpdater?.didUpdateContent = { [weak self] storage in
            UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0, options: .curveEaseOut, animations: {
                self?.actionButtonView.transform = .identity
            })
        }
        manager.tableViewUpdater?.deleteRowAnimation = .fade
        manager.tableViewUpdater?.insertRowAnimation = .middle
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
    
    func setInvitations(show: Bool, dataSource: iCarouselDataSource) {
        guard show else {
            tableView.tableHeaderView = nil
            return
        }
        tableView.tableHeaderView = InventedHeaderView(dataSource: dataSource)
        updateHeaderViewHeight()
    }
    
    func removeInvitation(index: Int) {
        let inventedHeader = tableView.tableHeaderView as? InventedHeaderView
        inventedHeader?.removeItem(index: index)
    }
    
    func showItems() {
        tableView.isHidden = false
        var delay: TimeInterval = 0
        if let inventedHeaderView = tableView.tableHeaderView as? InventedHeaderView {
            inventedHeaderView.animateTitle()
            inventedHeaderView.transform = CGAffineTransform(translationX: 0, y: view.frame.height)
            UIView.animate(withDuration: 0.8, delay: delay, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseOut, animations: {
                inventedHeaderView.transform = .identity
            }) { (_) in
                //inventedHeaderView.animateTitle()
            }
            delay += 0.2
        }
        for cell in tableView.visibleCells {
            cell.transform = CGAffineTransform(translationX: 0, y: view.frame.height)
            UIView.animate(withDuration: 0.8, delay: delay, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseOut, animations: {
                cell.transform = .identity
            })
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
    
    override public func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        updateHeaderViewHeight()
    }
    
    // MARK: - Actions
    
    @objc func actionButtonTapHandler(gesture: UITapGestureRecognizer) {
        
        if gesture.state == .began {
            UIView.animate(withDuration: 0.1) {
                self.actionButtonView.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
            }
        }
        if  gesture.state == .ended {
            let touchLocation = gesture.location(in: actionButtonView)
            if touchLocation.x >= 0 && touchLocation.x <= (actionButtonView.frame.width / 0.9) && touchLocation.y > 0 && touchLocation.y <= (actionButtonView.frame.height / 0.9) {
                UIView.animate(withDuration: 0.1) {
                    self.actionButtonView.transform = .identity
                }
            } else {
                UIView.animate(withDuration: 0.1) {
                    self.actionButtonView.transform = .identity
                }
            }
        }
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
