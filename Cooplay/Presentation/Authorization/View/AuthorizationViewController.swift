//
//  AuthorizationViewController.swift
//  Cooplay
//
//  Created by Alexandr Ovchinnikov on 22/04/2020.
//

import UIKit

final class AuthorizationViewController: UIViewController, AuthorizationViewInput {
    
    private enum Constant {
        
        static let topConstraint: CGFloat = 116
        static let mainButtonBottomConstraint: CGFloat = DeviceConstants.isSmallScreen ? 8 : 16
        static let animationDelay: TimeInterval = 0.05
        static let keyboardHeightKey = "KeyboardHeight"
        static let durationKey = "Duration"
        static let textFieldLeftPadding: CGFloat = 16
        static let textFieldRightPadding: CGFloat = 42
        static let passworSecurityAnimationDuration: TimeInterval = 0.2
    }

    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var emailErrorLabel: UILabel!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var passwordErrorLabel: UILabel!
    @IBOutlet weak var actionButton: UIButton!
    @IBOutlet weak var registerMessageLabel: UILabel!
    @IBOutlet weak var togglePasswordSecurityButton: UIButton!
    @IBOutlet weak var emailSpinner: UIActivityIndicatorView!
    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    @IBOutlet weak var mainButtonTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var mainButtonBottomConstraint: NSLayoutConstraint!
    
    var keyboardWillShowObserver: NSObjectProtocol?
    var keyboardWillHideObserver: NSObjectProtocol?
    
    // MARK: - View out

    var output: AuthorizationViewOutput?

    // MARK: - View in

    func setupInitialState() {
        registerForKeyboardEvents()
        setNextButtonEnabled(false)
        hideEmailChecking()
        emailTextField.attributedPlaceholder = NSAttributedString(
            string: R.string.localizable.authorizationEmailTextFieldPlaceholder(),
            attributes: [NSAttributedString.Key.foregroundColor: R.color.textSecondary()!]
        )
        emailTextField.setState(.normal)
        emailTextField.setPaddingPoints(
            left: Constant.textFieldLeftPadding,
            right: Constant.textFieldRightPadding
        )
        passwordTextField.attributedPlaceholder = NSAttributedString(
            string: R.string.localizable.authorizationPasswordTextFieldPlaceholder(),
            attributes: [NSAttributedString.Key.foregroundColor: R.color.textSecondary()!]
        )
        passwordTextField.setState(.normal)
        passwordTextField.setPaddingPoints(
            left: Constant.textFieldLeftPadding,
            right: Constant.textFieldRightPadding
        )
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
        registerMessageLabel.textColor = R.color.textPrimary()
        registerMessageLabel.attributedText = registerMessageAttributed
    }
    
    func showErrorMessage(_ message: String, forField field: AuthorizationField) {
        switch field {
        case .email:
            emailTextField.setState(.error)
            emailErrorLabel.text = message
        case .password:
            passwordTextField.setState(.error)
            passwordErrorLabel.text = message
        }
    }
    
    func cleanErrorMessage(forField field: AuthorizationField) {
        switch field {
        case .email:
            emailTextField.setState(.normal)
            emailErrorLabel.text = " "
        case .password:
            passwordTextField.setState(.normal)
            passwordErrorLabel.text = " "
        }
    }
    
    func cleanErrorMessages() {
        cleanErrorMessage(forField: .email(value: nil))
        cleanErrorMessage(forField: .password(value: nil))
    }
    
    func setNextButtonEnabled(_ isEnabled: Bool) {
        actionButton.isEnabled = isEnabled
        actionButton.alpha = isEnabled ? 1 : 0.5
    }
    
    func showEmailChecking() {
        emailSpinner.isHidden = false
        emailSpinner.startAnimating()
    }
    
    func hideEmailChecking() {
        emailSpinner.stopAnimating()
        emailSpinner.isHidden = true
    }
    
    func setEmail(_ text: String) {
        emailTextField.text = text
        output?.checkEmail()
    }

	// MARK: - Life cycle

	override func viewDidLoad() {
		super.viewDidLoad()
        output?.didLoad()
	}
    
    deinit {
        unregisterFromKeyboardEvents()
    }
    
    // MARK: - KeyboardHandler
    
    private var prevKeyboardHeight: CGFloat = 0
    private var prevDuration: TimeInterval = 0
    
    func keyboardWillShow(keyboardHeight: CGFloat, duration: TimeInterval) {
        var duration = duration
        if duration == 0 {
            duration = prevDuration
        }
        var userInfo: [String: Any] = [
            Constant.keyboardHeightKey: prevKeyboardHeight,
            Constant.durationKey: duration - Constant.animationDelay
        ]
        NSObject.cancelPreviousPerformRequests(
            withTarget: self,
            selector: #selector(animateKeyboardShowing),
            object: userInfo
        )
        userInfo[Constant.keyboardHeightKey] = keyboardHeight
        perform(
            #selector(animateKeyboardShowing),
            with: userInfo,
            afterDelay: Constant.animationDelay
        )
        prevKeyboardHeight = keyboardHeight
        prevDuration = duration
    }
    
    @objc func animateKeyboardShowing(userInfo: [String: Any]) {
        guard
            let keyboardHeight = userInfo[Constant.keyboardHeightKey] as? CGFloat,
            let duration = userInfo[Constant.durationKey] as? TimeInterval
        else { return }
        topConstraint.constant = 0
        mainButtonBottomConstraint.constant = Constant.mainButtonBottomConstraint + keyboardHeight
        mainButtonBottomConstraint.isActive = true
        mainButtonTopConstraint.isActive = false
        UIView.animate(
            withDuration: duration,
            animations: { [weak self] in
                self?.titleLabel.alpha = 0
                if DeviceConstants.isSmallScreen {
                    self?.titleLabel.text = nil
                }
                self?.view.layoutIfNeeded()
            },
            completion: { [weak self] (_) in
                self?.navigationItem.title = R.string.localizable.authorizationTitle()
            }
        )
    }
    
    func keyboardWillHide(keyboardHeight: CGFloat, duration: TimeInterval) {
        topConstraint.constant = Constant.topConstraint
        mainButtonBottomConstraint.isActive = false
        mainButtonTopConstraint.isActive = true
        navigationItem.title = nil
        UIView.animate(withDuration: duration) { [weak self] in
            self?.titleLabel.alpha = 1
            if DeviceConstants.isSmallScreen {
                self?.titleLabel.text = R.string.localizable.authorizationTitle()
            }
            self?.view.layoutIfNeeded()
        }
    }
    
    // MARK: - Actions
    
    @IBAction func actionButtonTapped() {
        view.endEditing(true)
        guard actionButton.isEnabled else { return }
        output?.didTapNext()
    }
    
    @IBAction func revoveryPasswordButtonTapped() {
        output?.didTapPasswordRecovery()
    }
    
    @IBAction func registerMessageTapped(_ sender: Any) {
        output?.didTapRegistration()
    }
    
    @IBAction func backgroundViewTapped() {
        view.endEditing(true)
    }
    
    @IBAction func togglePasswordSecurityButtonTapped() {
        let secureTextEntry = !passwordTextField.isSecureTextEntry
        passwordTextField.isSecureTextEntry = secureTextEntry
        let image = secureTextEntry ? R.image.commonShow() : R.image.commonHide()
        self.togglePasswordSecurityButton.setImage(image, for: .normal)
    }
    
    @IBAction func textFieldEditingChanged(_ sender: UITextField) {
        let value = sender.text
        switch sender {
        case emailTextField:
            output?.didChangeField(.email(value: value))
        case passwordTextField:
            output?.didChangeField(.password(value: value))
        default: break
        }
    }
}

extension AuthorizationViewController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.setState(.highlighted)
        switch textField {
        case passwordTextField:
            UIView.animate(withDuration: Constant.passworSecurityAnimationDuration) {
                self.togglePasswordSecurityButton.alpha = 1
            }
        default: break
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.setState(.normal)
        switch textField {
        case passwordTextField:
            UIView.animate(withDuration: Constant.passworSecurityAnimationDuration) {
                self.togglePasswordSecurityButton.alpha = 0
            }
        case emailTextField:
            output?.checkEmail()
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
