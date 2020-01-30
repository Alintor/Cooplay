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
    @IBOutlet weak var timePicker: UIDatePicker!
    @IBOutlet weak var dateTodayView: UIView!
    @IBOutlet weak var dateTodayLabel: UILabel!
    @IBOutlet weak var dateTomorrowView: UIView!
    @IBOutlet weak var dateTomorrowLabel: UILabel!
    @IBOutlet weak var dateCalendarView: UIView!
    @IBOutlet weak var dateCalendarIcon: UIImageView!
    
    @IBOutlet weak var dateCalendarLabelsView: UIView!
    @IBOutlet weak var dateCalendarDayLabel: UILabel!
    @IBOutlet weak var dateCalendarMonthLabel: UILabel!
    
    @IBOutlet var dateTodayTapGestureRecognizer: UITapGestureRecognizer!
    @IBOutlet var dateTomorrowTapGestureRecognizer: UITapGestureRecognizer!
    @IBOutlet var dateCalendarTapGestureRecognizer: UITapGestureRecognizer!
    
    // MARK: - View out

    var output: NewEventModuleInput?
    var viewIsReady: (() -> Void)?
    var calendarAction: (() -> Void)?
    var searchGameAction: (() -> Void)?
    var searchMembersAction: (() -> Void)?

    // MARK: - View in

    func setupInitialState() {
        dateTodayView.layer.borderWidth = 2
        dateTodayView.layer.borderColor = R.color.actionAccent()?.cgColor
        timePicker.subviews[0].subviews[1].backgroundColor = .clear
        timePicker.subviews[0].subviews[2].backgroundColor = .clear
        timePicker.setValue(R.color.textPrimary(), forKeyPath: "textColor")
        timePicker.tintColor = R.color.textPrimary()
        mainActionButton.isEnabled = false
        mainActionButton.alpha = 0.5
        gamesCollectionView.register(
            UINib(resource: R.nib.newEventGameCell),
            forCellWithReuseIdentifier: R.reuseIdentifier.newEventGameCell.identifier
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
        gamesCollectionView.reloadData()
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
}

extension NewEventViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: R.reuseIdentifier.newEventGameCell.identifier, for: indexPath)
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