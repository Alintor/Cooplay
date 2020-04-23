//
//  AuthorizationViewController.swift
//  Cooplay
//
//  Created by Alexandr Ovchinnikov on 22/04/2020.
//

import UIKit

final class AuthorizationViewController: UIViewController, AuthorizationViewInput {

    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var actionButton: UIButton!
    @IBOutlet weak var registerMessageLabel: UILabel!
    @IBOutlet weak var togglePasswordSecurityButton: UIButton!
    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    
    var keyboardWillShowObserver: NSObjectProtocol?
    var keyboardWillHideObserver: NSObjectProtocol?
    
    // MARK: - View out

    var output: AuthorizationModuleInput?
    var viewIsReady: (() -> Void)?

    // MARK: - View in

    func setupInitialState() {
        registerForKeyboardEvents()
        emailTextField.attributedPlaceholder = NSAttributedString(
            string: R.string.localizable.authorizationEmailTextFieldPlaceholder(),
            attributes: [NSAttributedString.Key.foregroundColor: R.color.textSecondary()!]
        )
        emailTextField.layer.borderColor = R.color.shapeBackground()?.cgColor
        emailTextField.setPaddingPoints(left: 16, right: 16)
        passwordTextField.attributedPlaceholder = NSAttributedString(
            string: R.string.localizable.authorizationPasswordTextFieldPlaceholder(),
            attributes: [NSAttributedString.Key.foregroundColor: R.color.textSecondary()!]
        )
        passwordTextField.layer.borderColor = R.color.shapeBackground()?.cgColor
        passwordTextField.setPaddingPoints(left: 16, right: 48)
        let registerMessage = R.string.localizable.authorizationRegisterMessage()
        let registerMessageAttributed = NSMutableAttributedString(string: registerMessage)
        if let range = registerMessage.range(
            of: R.string.localizable.authorizationRegisterMessageHighlight()) {
            registerMessageAttributed.addAttribute(
                .foregroundColor,
                value: R.color.actionAccent()!,
                range: NSRange(range, in: registerMessage)
            )
        }
        registerMessageLabel.attributedText = registerMessageAttributed
    }

	// MARK: - Life cycle

	override func viewDidLoad() {
		super.viewDidLoad()
		viewIsReady?()
	}
    
    deinit {
        unregisterFromKeyboardEvents()
    }
    
    // MARK: - KeyboardHandler
    
    func keyboardWillShow(keyboardHeight: CGFloat, duration: TimeInterval) {
        topConstraint.constant = 0
        UIView.animate(
            withDuration: duration,
            animations: { [weak self] in
                self?.titleLabel.alpha = 0
                self?.view.layoutIfNeeded()
            },
            completion: { [weak self] (_) in
                self?.navigationItem.title = R.string.localizable.authorizationTitle()
            }
        )
    }
    
    func keyboardWillHide(keyboardHeight: CGFloat, duration: TimeInterval) {
        topConstraint.constant = 116
        navigationItem.title = nil
        UIView.animate(withDuration: duration) { [weak self] in
            self?.titleLabel.alpha = 1
            self?.view.layoutIfNeeded()
        }
    }
    
    // MARK: - Actions
    
    @IBAction func actionButtonTapped() {
        view.endEditing(true)
    }
    
    @IBAction func revoveryPasswordButtonTapped() {
    
    }
    
    @IBAction func registerMessageTapped(_ sender: Any) {
    
    }
    
    @IBAction func togglePasswordSecurityButtonTapped() {
        let secureTextEntry = !passwordTextField.isSecureTextEntry
        passwordTextField.isSecureTextEntry = secureTextEntry
        let image = secureTextEntry ? R.image.commonShow() : R.image.commonHide()
        self.togglePasswordSecurityButton.setImage(image, for: .normal)
    }
}

extension AuthorizationViewController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.layer.borderColor = R.color.actionAccent()?.cgColor
        switch textField {
        case passwordTextField:
            UIView.animate(withDuration: 0.2) {
                self.togglePasswordSecurityButton.alpha = 1
            }
        default: break
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.layer.borderColor = R.color.shapeBackground()?.cgColor
        switch textField {
        case passwordTextField:
            UIView.animate(withDuration: 0.2) {
                self.togglePasswordSecurityButton.alpha = 0
            }
        default: break
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case emailTextField:
            passwordTextField.becomeFirstResponder()
        case passwordTextField:
            actionButtonTapped()
        default:
            textField.resignFirstResponder()
        }
        return true
    }
}
