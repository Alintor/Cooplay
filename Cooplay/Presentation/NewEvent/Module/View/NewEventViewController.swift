//
//  NewEventViewController.swift
//  Cooplay
//
//  Created by Alexandr Ovchinnikov on 20/01/2020.
//

import UIKit

final class NewEventViewController: UIViewController, NewEventViewInput {

    @IBOutlet weak var gamesCollectionView: UICollectionView!
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
        gamesCollectionView.isHidden = !isShow
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
