//
//  PersonalisationViewController.swift
//  Cooplay
//
//  Created by Alexandr Ovchinnikov on 16/06/2020.
//

import UIKit

final class PersonalisationViewController: UIViewController, PersonalisationViewInput {
    
    private enum Constant {
        
        static let textFieldLeftPadding: CGFloat = 16
        static let textFieldRightPadding: CGFloat = 42
        static let actionButtonBottomIndent: CGFloat = 16
    }
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var avatarView: AvatarView!
    @IBOutlet weak var cameraImageView: UIImageView!
    @IBOutlet weak var nickNameTextField: UITextField!
    @IBOutlet weak var nickNameErrorLabel: UILabel!
    @IBOutlet weak var actionButton: UIButton!
    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    
    var keyboardWillShowObserver: NSObjectProtocol?
    var keyboardWillHideObserver: NSObjectProtocol?
    
    // MARK: - View out

    var output: PersonalisationModuleInput?
    var viewIsReady: (() -> Void)?
    var confirmAction: (() -> Void)?
    var changeAvatarAction: (() -> Void)?
    var nickNameChanged: ((_ nickName: String?) -> Void)?

    // MARK: - View in

    func setupInitialState() {
        registerForKeyboardEvents()
        navigationItem.setHidesBackButton(true, animated: false)
        nickNameTextField.becomeFirstResponder()
        setConfirmButtonEnabled(false)
        nickNameTextField.attributedPlaceholder = NSAttributedString(
            string: R.string.localizable.personalisationNickNameTextFieldPlaceholder(),
            attributes: [NSAttributedString.Key.foregroundColor: R.color.textSecondary()!]
        )
        nickNameTextField.setState(.normal)
        nickNameTextField.setPaddingPoints(
            left: Constant.textFieldLeftPadding,
            right: Constant.textFieldRightPadding
        )

    }
    
    func updateAvatar(with model: AvatarViewModel) {
        avatarView.update(with: model)
        cameraImageView.isHidden = model.firstNameLetter != ""
    }
    
    func showNickNameErrorMessage(_ message: String) {
        nickNameErrorLabel.text = message
        nickNameTextField.setState(.error)
    }
    
    func clearNickNameErrorMessage() {
        nickNameErrorLabel.text = " "
        nickNameTextField.setState(.highlighted)
    }
    
    func setConfirmButtonEnabled(_ isEnabled: Bool) {
        actionButton.isEnabled = isEnabled
        actionButton.alpha = isEnabled ? 1 : 0.5
    }

	// MARK: - Life cycle

	override func viewDidLoad() {
		super.viewDidLoad()
		viewIsReady?()
	}
    
    deinit {
        unregisterFromKeyboardEvents()
    }
    
    // MARK: - Actions
    @IBAction func actionButtonTapped() {
        confirmAction?()
    }
    
    @IBAction func avatarTapped(_ sender: UITapGestureRecognizer) {
        changeAvatarAction?()
    }
    
    @IBAction func textFieldEditingChanged(_ sender: UITextField) {
        let value = sender.text
        switch sender {
        case nickNameTextField:
            nickNameChanged?(value)
        default: break
        }
    }
    
    // MARK: - Keyboard handler
    
    func keyboardWillShow(keyboardHeight: CGFloat, duration: TimeInterval) {
        let bottomDistance = view.frame.height - (actionButton.frame.origin.y + actionButton.frame.height)
        let diff = bottomDistance - (keyboardHeight + Constant.actionButtonBottomIndent)
        if diff < 0 {
            topConstraint.constant += diff
            UIView.animate(
                withDuration: duration,
                animations: { [weak self] in
                    self?.titleLabel.alpha = 0
                    if GlobalConstant.isSmallScreen {
                        self?.titleLabel.text = " "
                    }
                    self?.view.layoutIfNeeded()
                },
                completion: { [weak self] (_) in
                    self?.navigationItem.title = R.string.localizable.personalisationTitle()
                }
            )
        }
        
    }
    
    func keyboardWillHide(keyboardHeight: CGFloat, duration: TimeInterval) {
        navigationItem.title = nil
        UIView.animate(withDuration: duration) { [weak self] in
            self?.titleLabel.alpha = 1
            if GlobalConstant.isSmallScreen {
                self?.titleLabel.text = R.string.localizable.personalisationTitle()
            }
            self?.view.layoutIfNeeded()
        }
    }
    
}

extension PersonalisationViewController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.setState(.highlighted)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.setState(.normal)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case nickNameTextField:
            actionButtonTapped()
        default:
            break
        }
        return true
    }
}
