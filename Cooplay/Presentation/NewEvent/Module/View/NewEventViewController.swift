//
//  NewEventViewController.swift
//  Cooplay
//
//  Created by Alexandr Ovchinnikov on 20/01/2020.
//

import UIKit

final class NewEventViewController: UIViewController, NewEventViewInput {

    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var gamesCollectionView: UICollectionView!
    @IBOutlet weak var gamesView: UIView!
    @IBOutlet weak var selectGameButton: UIButton!
    @IBOutlet weak var selectMembersButton: UIButton!
    @IBOutlet weak var mainActionButton: UIButton!
    @IBOutlet weak var timeView: NewEventTimeButtonView!
    
    @IBOutlet weak var dateTodayView: UIView!
    @IBOutlet weak var dateTodayLabel: UILabel!
    @IBOutlet weak var dateTomorrowView: UIView!
    @IBOutlet weak var dateTomorrowLabel: UILabel!
    @IBOutlet weak var dateCalendarView: UIView!
    @IBOutlet weak var dateCalendarIcon: UIImageView!
    
    @IBOutlet weak var dateCalendarLabelsView: UIView!
    @IBOutlet weak var dateCalendarDayLabel: UILabel!
    @IBOutlet weak var dateCalendarMonthLabel: UILabel!
    
    @IBOutlet weak var membersCollectionView: UICollectionView!
    @IBOutlet weak var membersView: UIView!
    
    @IBOutlet var dateTodayTapGestureRecognizer: UITapGestureRecognizer!
    @IBOutlet var dateTomorrowTapGestureRecognizer: UITapGestureRecognizer!
    @IBOutlet var dateCalendarTapGestureRecognizer: UITapGestureRecognizer!
    
    @IBOutlet weak var timeViewLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var timeViewTrailingConstraint: NSLayoutConstraint!
    
    // MARK: - View out

    var output: NewEventModuleInput?
    var viewIsReady: (() -> Void)?
    var calendarAction: (() -> Void)?
    var timePickerAction: (() -> Void)?
    var searchGameAction: (() -> Void)?
    var searchMembersAction: (() -> Void)?

    // MARK: - View in

    func setupInitialState() {
        dateTodayView.layer.borderWidth = 2
        dateTodayView.layer.borderColor = R.color.actionAccent()?.cgColor
        mainActionButton.isEnabled = false
        mainActionButton.alpha = 0.5
        gamesCollectionView.register(
            UINib(resource: R.nib.newEventGameCell),
            forCellWithReuseIdentifier: R.reuseIdentifier.newEventGameCell.identifier
        )
        membersCollectionView.register(
            UINib(resource: R.nib.newEventMemberCell),
            forCellWithReuseIdentifier: R.reuseIdentifier.newEventMemberCell.identifier
        )
    }
    
    func showGamesLoading() {
        gamesCollectionView.dataSource = self

        selectGameButton.isEnabled = false
        selectGameButton.alpha = 0.5
    }
    
    func hideGamesLoading() {
        selectGameButton.isEnabled = true
        selectGameButton.alpha = 1
    }
    
    func showTimeLoading() {
        let color = SkeletonGradient(baseColor: R.color.block()!)
        let animation = SkeletonAnimation(
            direction: .leftRight,
            sizeMultiplier: 2,
            duration: 1.5,
            intervalDelay: 0.3
        )
        timeView.showSkeleton(color: color, animation: animation)
        timeView.isUserInteractionEnabled = false
    }
    
    func hideTimeLoading() {
        timeView.hideSkeleton()
        timeView.isUserInteractionEnabled = true
    }
    
    func setTime(_ time: Date) {
        timeView.setTime(time)
    }
    
    func updateDayDate(with model: NewEventDayDateViewModel) {
        dateCalendarDayLabel.text = model.day
        dateCalendarMonthLabel.text = model.month
        dateCalendarView.layer.borderWidth = 2
        dateCalendarView.layer.borderColor = R.color.actionAccent()?.cgColor
        dateCalendarIcon.isHidden = true
        dateCalendarLabelsView.isHidden = false
        dateTodayView.layer.borderWidth = 0
        dateTodayLabel.textColor = R.color.actionAccent()
        dateTomorrowView.layer.borderWidth = 0
        dateTomorrowLabel.textColor = R.color.actionAccent()
    }
    
    func setGamesDataSource(_ dataSource: UICollectionViewDataSource) {
        gamesCollectionView.dataSource = dataSource
        gamesCollectionView.reloadData()
    }
    
    func showGames(_ isShow: Bool) {
        UIView.animate(
            withDuration: isShow ? 0.3 : 0,
            delay: isShow ? 0.2 : 0,
            usingSpringWithDamping: 0.9,
            initialSpringVelocity: 0,
            options: .curveEaseInOut,
            animations: {
                self.gamesCollectionView.alpha = isShow ? 1 : 0
        })
        UIView.animate(
            withDuration: 0.5,
            delay: 0,
            usingSpringWithDamping: 0.8,
            initialSpringVelocity: 0,
            options: .curveEaseInOut,
            animations: {
                self.gamesView.isHidden = !isShow
                self.stackView.layoutIfNeeded()
            }
        )
        
    }
    
    func updateGames() {
        DispatchQueue.main.async { [weak self] in
            self?.gamesCollectionView.reloadData()
        }
    }
    
    func setMembersDataSource(_ dataSource: UICollectionViewDataSource) {
        membersCollectionView.dataSource = dataSource
        membersCollectionView.reloadData()
    }
    
    func showMembers(_ isShow: Bool) {
        UIView.animate(
            withDuration: isShow ? 0.3 : 0,
            delay: isShow ? 0.2 : 0,
            usingSpringWithDamping: 0.9,
            initialSpringVelocity: 0,
            options: .curveEaseInOut,
            animations: {
                self.membersCollectionView.alpha = isShow ? 1 : 0
        })
        UIView.animate(
            withDuration: 0.5,
            delay: 0,
            usingSpringWithDamping: 0.8,
            initialSpringVelocity: 0,
            options: .curveEaseInOut,
            animations: {
                self.membersView.isHidden = !isShow
                self.stackView.layoutIfNeeded()
            }
        )
        
    }
    
    func updateMembers() {
        DispatchQueue.main.async { [weak self] in
            self?.membersCollectionView.reloadData()
        }
    }
    
    func showMembersLoading() {
        membersCollectionView.dataSource = self

        selectMembersButton.isEnabled = false
        selectMembersButton.alpha = 0.5
    }
    
    func hideMembersLoading() {
        selectMembersButton.isEnabled = true
        selectMembersButton.alpha = 1
    }

	// MARK: - Life cycle

	override func viewDidLoad() {
		super.viewDidLoad()
		viewIsReady?()
	}
    
    // MARK: - Actions
    
    @IBAction func selectGameButtonTapped() {
        searchGameAction?()
    }
    
    @IBAction func selectMembersButtonTapped() {
        searchMembersAction?()
    }
    @IBAction func mainActionButtonTapped() {
        
    }
    
    @IBAction func dateViewTapped(_ sender: UITapGestureRecognizer) {
        switch sender {
        case dateTodayTapGestureRecognizer:
            dateTodayView.layer.borderWidth = 2
            dateTodayView.layer.borderColor = R.color.actionAccent()?.cgColor
            dateTodayLabel.textColor = R.color.textPrimary()
            dateTomorrowView.layer.borderWidth = 0
            dateTomorrowLabel.textColor = R.color.actionAccent()
            dateCalendarView.layer.borderWidth = 0
            dateCalendarLabelsView.isHidden = true
            dateCalendarIcon.isHidden = false
        case dateTomorrowTapGestureRecognizer:
            dateTomorrowView.layer.borderWidth = 2
            dateTomorrowView.layer.borderColor = R.color.actionAccent()?.cgColor
            dateTomorrowLabel.textColor = R.color.textPrimary()
            dateTodayView.layer.borderWidth = 0
            dateTodayLabel.textColor = R.color.actionAccent()
            dateCalendarView.layer.borderWidth = 0
            dateCalendarLabelsView.isHidden = true
            dateCalendarIcon.isHidden = false
        case dateCalendarTapGestureRecognizer:
            calendarAction?()
        default: break
        }
    }
    
    @IBAction func timeViewTapped(_ sender: UITapGestureRecognizer) {
        timePickerAction?()
    }
    
}

extension NewEventViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var reuseIdentifier: String {
            switch collectionView {
            case gamesCollectionView:
                return R.reuseIdentifier.newEventGameCell.identifier
            case membersCollectionView:
                return R.reuseIdentifier.newEventMemberCell.identifier
            default:
                fatalError("Unknown collectionView in NewEventViewController")
            }
        }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
        if let cell = cell as? Skeletonable {
            let color = SkeletonGradient(baseColor: R.color.block()!)
            let animation = SkeletonAnimation(
                direction: .leftRight,
                sizeMultiplier: 3,
                duration: 0.3,
                startDelay: CFTimeInterval(Float(indexPath.row) * 0.1),
                intervalDelay: 1.5
            )
            cell.showSkeleton(color: color, animation: animation)
        }
        return cell
    }
    
}

extension NewEventViewController: NewEventTimePickerViewDelegate {
    
    
    var timeButtonView: UIView {
        return timeView
    }
    
    func prepareView(completion: @escaping () -> Void) {
        timeViewLeadingConstraint.constant = 10
        timeViewTrailingConstraint.constant = 10
        UIView.animate(withDuration: 0.1, animations: {
            self.timeView.arrowImageView.transform = CGAffineTransform(rotationAngle: .pi)
            self.view.layoutIfNeeded()
        }) { (_) in
            completion()
        }
    }
    
    func restoreView() {
        timeViewLeadingConstraint.constant = 24
        timeViewTrailingConstraint.constant = 24
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseOut, animations: {
            self.timeView.arrowImageView.transform = .identity
            self.view.layoutIfNeeded()
        })
    }
}
