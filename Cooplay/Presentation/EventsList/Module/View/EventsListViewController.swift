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
    
    private enum Constant {
        
        enum Empty {
            
            static let image = R.image.eventsListEmptyState()
            static let title = R.string.localizable.eventsListEmptySateTitle()
            static let description = R.string.localizable.eventsListEmptySateDescription()
        }
        
        static let profileDiameter: CGFloat = 32
        static let profileTrailingIndent: CGFloat = 16
        static let profilewBottomIndent: CGFloat = 12
        static let profileTopIndent: CGFloat = 4
        static let cellHightlightAnimationDuration: TimeInterval = 0.1
        static let cellHightlightAnimationDamping: CGFloat = 0.8
        static let cellHightlightAnimationTransformScale: CGFloat = 0.98
        static let actionButtonInset: CGFloat = 66
        static let actionButtonShowingAnimationDuration: TimeInterval = 1
        static let actionButtonShowingAnimationDamping: CGFloat = 0.7
        static let actionButtonHightlightAnimationDuration: TimeInterval = 0.1
        static let actionButtonHightlightTransformScale: CGFloat = 0.9
        static let eventItemShowingDelay: TimeInterval = 0.2
        static let eventItemShowingAnimationDuration: TimeInterval = 0.8
        static let eventItemShowingAnimationDamping: CGFloat = 0.8
    }
    
    @IBOutlet weak var actionButtonView: UIView!
    @IBOutlet weak var actionButtonTrailingConstraint: NSLayoutConstraint!
    @IBOutlet weak var tableView: UITableView!
    
    private var avatarView: AvatarView?
    
    private lazy var emptyState = EmptyStateHandler(
        image: Constant.Empty.image,
        title: Constant.Empty.title,
        descriptionText: Constant.Empty.description
    )
    
    // MARK: - View out

    var output: EventsListModuleInput?
    var viewIsReady: (() -> Void)?
    var dataSourceIsReady: ((_ dataSource: MemoryStorage) -> Void)?
    var itemSelected: ((_ event: Event) -> Void)?
    var newEventAction: (() -> Void)?
    var profileAction: (() -> Void)?

    // MARK: - View in

    func setupInitialState() {
        navigationController?.view.backgroundColor = R.color.background()
        tableView.isHidden = true
        tableView.contentInset.bottom = Constant.actionButtonInset
        actionButtonView.transform = CGAffineTransform(
            translationX: Constant.actionButtonInset,
            y: 0
        )
        let tapGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(actionButtonTapHandler))
        tapGestureRecognizer.minimumPressDuration = 0
        actionButtonView.addGestureRecognizer(tapGestureRecognizer)
        navigationController?.navigationBar.prefersLargeTitles = true
        manager.startManaging(withDelegate: self)
        manager.configureEvents(for: InvitationsHeaderCell.self) { cellType, modelType in
            manager.register(cellType) { $0.condition = .section(0) }
            manager.heightForCell(withItem: modelType) { _, _ in return UITableView.automaticDimension }
            manager.estimatedHeightForCell(withItem: modelType) { _, _ in return cellType.defaultHeight }
        }
        manager.configureEvents(for: ActiveEventCell.self) { cellType, modelType in
            manager.register(cellType) { $0.condition = .section(1) }
            manager.didSelect(cellType) { [weak self] (cell, model, _) in
                self?.itemSelected?(model.model)
            }
            manager.didHighlight(cellType) { (cell, _, _) in
                UIView.animate(
                    withDuration: Constant.cellHightlightAnimationDuration,
                    delay: 0,
                    usingSpringWithDamping: Constant.cellHightlightAnimationDamping,
                    initialSpringVelocity: 0,
                    options: .curveEaseOut,
                    animations: {
                        cell.transform = CGAffineTransform(
                            scaleX: Constant.cellHightlightAnimationTransformScale,
                            y: Constant.cellHightlightAnimationTransformScale
                        )
                    }
                )
            }
            manager.didUnhighlight(cellType) { (cell, _, _) in
                UIView.animate(
                    withDuration: Constant.cellHightlightAnimationDuration,
                    delay: 0,
                    usingSpringWithDamping: Constant.cellHightlightAnimationDamping,
                    initialSpringVelocity: 0,
                    options: .curveEaseOut,
                    animations: {
                        cell.transform = .identity
                    }
                )
            }
            manager.heightForCell(withItem: modelType) { _, _ in return UITableView.automaticDimension }
            manager.estimatedHeightForCell(withItem: modelType) { _, _ in return cellType.defaultHeight }
        }
        manager.registerNiblessHeader(EventSectionСollapsibleHeaderView.self)
        manager.heightForHeader(withItem: String.self) { _, _ in
            return UITableView.automaticDimension
        }
        manager.heightForHeader(withItem: EventSectionСollapsibleHeaderViewModel.self) { _, _ in
            return UITableView.automaticDimension
        }
        manager.estimatedHeightForHeader(withItem: EventSectionСollapsibleHeaderViewModel.self) { _, _ in
            return 50
        }
        manager.configureEvents(for: EventCell.self) { cellType, modelType in
            manager.register(cellType) { $0.condition = .section(2) }
            manager.register(cellType) { $0.condition = .section(3) }
            manager.didSelect(cellType) { [weak self] (cell, model, _) in
                self?.itemSelected?(model.model)
            }
            manager.didHighlight(cellType) { (cell, _, _) in
                UIView.animate(
                    withDuration: Constant.cellHightlightAnimationDuration,
                    delay: 0,
                    usingSpringWithDamping: Constant.cellHightlightAnimationDamping,
                    initialSpringVelocity: 0,
                    options: .curveEaseOut,
                    animations: {
                        cell.transform = CGAffineTransform(
                            scaleX: Constant.cellHightlightAnimationTransformScale,
                            y: Constant.cellHightlightAnimationTransformScale
                        )
                    }
                )
            }
            manager.didUnhighlight(cellType) { (cell, _, _) in
                UIView.animate(
                    withDuration: Constant.cellHightlightAnimationDuration,
                    delay: 0,
                    usingSpringWithDamping: Constant.cellHightlightAnimationDamping,
                    initialSpringVelocity: 0,
                    options: .curveEaseOut,
                    animations: {
                        cell.transform = .identity
                    }
                )
            }
            manager.heightForCell(withItem: modelType) { _, _ in return UITableView.automaticDimension }
            manager.estimatedHeightForCell(withItem: modelType) { _, _ in return cellType.defaultHeight }
        }
        manager.tableViewUpdater?.didUpdateContent = { [weak self] storage in
            self?.tableView.reloadEmptyState(self?.emptyState)
            UIView.animate(
                withDuration: Constant.actionButtonShowingAnimationDuration,
                delay: 0,
                usingSpringWithDamping: Constant.actionButtonShowingAnimationDamping,
                initialSpringVelocity: 0,
                options: .curveEaseOut,
                animations: {
                    self?.actionButtonView.transform = .identity
                }
            )
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
            avatarView?.addGestureRecognizer(
                UITapGestureRecognizer(target: self, action: #selector(avatarViewTapped))
            )
            // TODO: Set action
        }
        avatarView?.update(with: model)
        configureProfileView()
    }
    
    func showItems() {
        guard tableView.isHidden else { return }
        tableView.isHidden = false
        var delay: TimeInterval = 0
        for cell in tableView.visibleCells {
            cell.transform = CGAffineTransform(translationX: 0, y: view.frame.height)
            UIView.animate(
                withDuration: Constant.eventItemShowingAnimationDuration,
                delay: delay,
                usingSpringWithDamping: Constant.eventItemShowingAnimationDamping,
                initialSpringVelocity: 0,
                options: .curveEaseOut,
                animations: {
                    cell.transform = .identity
                }
            )
            delay += Constant.eventItemShowingDelay
        }
    }

	// MARK: - Life cycle

	override func viewDidLoad() {
		super.viewDidLoad()
		viewIsReady?()
	}
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //configureProfileView()
        //avatarView?.isHidden = false
        UIView.animate(withDuration: 0.1) {
            self.avatarView?.alpha = 1
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
//        avatarView?.removeConstraints(avatarView?.constraints ?? [])
//        avatarView?.removeFromSuperview()
        //avatarView?.isHidden = true
        UIView.animate(withDuration: 0.1) {
            self.avatarView?.alpha = 0
        }
    }
    
    override public func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        updateHeaderViewHeight()
    }
    
    // MARK: - Actions
    
    @objc func actionButtonTapHandler(gesture: UITapGestureRecognizer) {
        
        if gesture.state == .began {
            UIView.animate(withDuration: 0.1) {
                self.actionButtonView.transform = CGAffineTransform(
                    scaleX: Constant.actionButtonHightlightTransformScale,
                    y: Constant.actionButtonHightlightTransformScale
                )
            }
        }
        if  gesture.state == .ended {
            let touchLocation = gesture.location(in: actionButtonView)
            if touchLocation.x >= 0
                && touchLocation.x <= (actionButtonView.frame.width / Constant.actionButtonHightlightTransformScale)
                && touchLocation.y > 0 && touchLocation.y <= (actionButtonView.frame.height / Constant.actionButtonHightlightTransformScale) {
                UIView.animate(
                    withDuration: Constant.actionButtonHightlightAnimationDuration,
                    animations: {
                        self.actionButtonView.transform = .identity
                    },
                    completion: { [weak self] (_) in
                        self?.newEventAction?()
                    }
                )
            } else {
                UIView.animate(withDuration: Constant.actionButtonHightlightAnimationDuration) {
                    self.actionButtonView.transform = .identity
                }
            }
        }
    }
    
    @objc func avatarViewTapped() {
        profileAction?()
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
