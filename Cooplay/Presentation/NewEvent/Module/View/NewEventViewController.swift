//
//  NewEventViewController.swift
//  Cooplay
//
//  Created by Alexandr Ovchinnikov on 20/01/2020.
//

import UIKit

final class NewEventViewController: UIViewController, NewEventViewInput {

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
    @IBOutlet var dateTodayTapGestureRecognizer: UITapGestureRecognizer!
    @IBOutlet var dateTomorrowTapGestureRecognizer: UITapGestureRecognizer!
    @IBOutlet var dateCalendarTapGestureRecognizer: UITapGestureRecognizer!
    
    // MARK: - View out

    var output: NewEventModuleInput?
    var viewIsReady: (() -> Void)?

    // MARK: - View in

    func setupInitialState() {
        dateTodayView.layer.borderWidth = 2
        dateTodayView.layer.borderColor = R.color.actionAccent()?.cgColor
        timePicker.subviews[0].subviews[1].backgroundColor = .clear
        timePicker.subviews[0].subviews[2].backgroundColor = .clear
        mainActionButton.isEnabled = false
        mainActionButton.alpha = 0.5
    }

	// MARK: - Life cycle

	override func viewDidLoad() {
		super.viewDidLoad()
		viewIsReady?()
	}
    
    // MARK: - Actions
    
    @IBAction func selectGameButtonTapped() {
        
    }
    
    @IBAction func selectMembersButtonTapped() {
        
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
            dateCalendarIcon.tintColor = R.color.actionAccent()
        case dateTomorrowTapGestureRecognizer:
            dateTomorrowView.layer.borderWidth = 2
            dateTomorrowView.layer.borderColor = R.color.actionAccent()?.cgColor
            dateTomorrowLabel.textColor = R.color.textPrimary()
            dateTodayView.layer.borderWidth = 0
            dateTodayLabel.textColor = R.color.actionAccent()
            dateCalendarView.layer.borderWidth = 0
            dateCalendarIcon.tintColor = R.color.actionAccent()
        case dateCalendarTapGestureRecognizer:
            dateCalendarView.layer.borderWidth = 2
            dateCalendarView.layer.borderColor = R.color.actionAccent()?.cgColor
            dateCalendarIcon.tintColor = R.color.textPrimary()
            dateTodayView.layer.borderWidth = 0
            dateTodayLabel.textColor = R.color.actionAccent()
            dateTomorrowView.layer.borderWidth = 0
            dateTomorrowLabel.textColor = R.color.actionAccent()
        default: break
        }
    }
    
    
}
