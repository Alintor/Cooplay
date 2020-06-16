//
//  RegistrationViewController.swift
//  Cooplay
//
//  Created by Alexandr Ovchinnikov on 27/05/2020.
//

import UIKit

final class RegistrationViewController: UIViewController, RegistrationViewInput {
    
    private enum Constant {
        
        static let topConstraint: CGFloat = GlobalConstant.isSmallScreen ? 24 : 70
        static let mainButtonBottomConstraint: CGFloat = GlobalConstant.isSmallScreen ? 8 : 16
        static let animationDelay: TimeInterval = 0.05
        static let keyboardHeightKey = "KeyboardHeight"
        static let durationKey = "Duration"
        static let textFieldLeftPadding: CGFloat = 16
        static let textFieldRightPadding: CGFloat = 42
        static let passworSecurityAnimationDuration: TimeInterval = 0.2
    }
    
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var emailErrorLabel: UILabel!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var passwordSymbolsCountErrorLabel: UILabel!
    @IBOutlet weak var passwordSymbolsCountErrorImageView: UIImageView!
    @IBOutlet weak var passwordBigSymbolsErrorLabel: UILabel!
    @IBOutlet weak var passwordBigSymbolsErrorImageView: UIImageView!
    @IBOutlet weak var passwordNumericSymbolErrorLabel: UILabel!
    @IBOutlet weak var passwordNumericSymbolErrorImageView: UIImageView!
    @IBOutlet weak var passwordConfirmTextField: UITextField!
    @IBOutlet weak var passwordConfirmErrorLabel: UILabel!
    @IBOutlet weak var actionButton: UIButton!
    @IBOutlet weak var loginMessageLabel: UILabel!
    @IBOutlet weak var togglePasswordSecurityButton: UIButton!
    @IBOutlet weak var togglePasswordConfirmSecurityButton: UIButton!
    @IBOutlet weak var emailSpinner: UIActivityIndicatorView!
    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    @IBOutlet weak var mainButtonTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var mainButtonBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var mainActionBackgroundView: UIView!
    
    var keyboardWillShowObserver: NSObjectProtocol?
    var keyboardWillHideObserver: NSObjectProtocol?

    // MARK: - View out

    var output: RegistrationModuleInput?
    var viewIsReady: (() -> Void)?
    var fieldValueChanged: ((_ field: RegistrationField) -> Void)?
    var nextAction: (() -> Void)?
    var checkEmail: (() -> Void)?
    var loginAction: (() -> Void)?

    // MARK: - View in

    func setupInitialState() {
        registerForKeyboardEvents()
        setNextButtonEnabled(false)
        topConstraint.constant = Constant.topConstraint
        hideEmailChecking()
        let gradient = CAGradientLayer(layer: mainActionBackgroundView.layer)
        gradient.colors = [R.color.background()!.withAlphaComponent(0).cgColor, R.color.background()!.cgColor]
        gradient.startPoint = CGPoint(x:1, y:0)
        gradient.endPoint = CGPoint(x:1, y:0.3)
        gradient.frame = mainActionBackgroundView.bounds
        mainActionBackgroundView.layer.insertSublayer(gradient, at: 0)
        passwordSymbolsCountErrorLabel.text = R.string.localizable.registrationPasswordSymbolsCountLabelTitle(8)
        emailTextField.attributedPlaceholder = NSAttributedString(
            string: R.string.localizable.registrationEmailTextFieldPlaceholder(),
            attributes: [NSAttributedString.Key.foregroundColor: R.color.textSecondary()!]
        )
        emailTextField.setState(.normal)
        emailTextField.setPaddingPoints(
            left: Constant.textFieldLeftPadding,
            right: Constant.textFieldRightPadding
        )
        passwordTextField.attributedPlaceholder = NSAttributedString(
            string: R.string.localizable.registrationPasswordTextFieldPlaceholder(),
            attributes: [NSAttributedString.Key.foregroundColor: R.color.textSecondary()!]
        )
        passwordTextField.setState(.normal)
        passwordTextField.setPaddingPoints(
            left: Constant.textFieldLeftPadding,
            right: Constant.textFieldRightPadding
        )
        passwordConfirmTextField.attributedPlaceholder = NSAttributedString(
            string: R.string.localizable.registrationPasswordConfirmTextFieldPlaceholder(),
            attributes: [NSAttributedString.Key.foregroundColor: R.color.textSecondary()!]
        )
        passwordConfirmTextField.setState(.normal)
        passwordConfirmTextField.setPaddingPoints(
            left: Constant.textFieldLeftPadding,
            right: Constant.textFieldRightPadding
        )
        let loginMessage = R.string.localizable.registrationLoginMessage()
        let loginMessageAttributed = NSMutableAttributedString(string: loginMessage)
        if let range = loginMessage.range(
            of: R.string.localizable.registrationLoginMessageHighlight()) {
            loginMessageAttributed.addAttribute(
                .foregroundColor,
                value: R.color.actionAccent()!,
                range: NSRange(range, in: loginMessage)
            )
        }
        loginMessageLabel.textColor = R.color.textPrimary()
        loginMessageLabel.attributedText = loginMessageAttributed
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
    
    func showErrorMessage(_ message: String, forField field: RegistrationField) {
        switch field {
        case .email:
            emailErrorLabel.text = message
            emailTextField.setState(.error)
        case .confirmPassword:
            passwordConfirmErrorLabel.text = message
            passwordConfirmTextField.setState(.error)
        case .password:
            break
        }
    }
    
    func cleanErrorMessage(forField field: RegistrationField) {
        switch field {
        case .email:
            emailErrorLabel.text = " "
            emailTextField.setState(.normal)
        case .confirmPassword:
            passwordConfirmErrorLabel.text = " "
            passwordConfirmTextField.setState(.normal)
        case .password:
            break
        }
    }
    
    func cleanErrorMessages() {
        cleanErrorMessage(forField: .email(value: nil))
        cleanErrorMessage(forField: .confirmPassword(value: nil))
    }
    
    func setSymbolsCountErrorState(_ state: PasswordValidationState) {
        switch state {
        case .correct:
            passwordSymbolsCountErrorLabel.textColor = R.color.green()
            passwordSymbolsCountErrorImageView.tintColor = R.color.green()
            passwordSymbolsCountErrorImageView.image = R.image.statusNormalOntime()
        case .error:
            passwordSymbolsCountErrorLabel.textColor = R.color.red()
            passwordSymbolsCountErrorImageView.tintColor = R.color.red()
            passwordSymbolsCountErrorImageView.image = R.image.statusNormalDeclined()
        case .clear:
            passwordSymbolsCountErrorLabel.textColor = R.color.textSecondary()
            passwordSymbolsCountErrorImageView.tintColor = R.color.textSecondary()
            passwordSymbolsCountErrorImageView.image = R.image.statusNormalOntime()
        }
    }
    
    func setBigSymbolsErrorState(_ state: PasswordValidationState) {
        switch state {
        case .correct:
            passwordBigSymbolsErrorLabel.textColor = R.color.green()
            passwordBigSymbolsErrorImageView.tintColor = R.color.green()
            passwordBigSymbolsErrorImageView.image = R.image.statusNormalOntime()
        case .error:
            passwordBigSymbolsErrorLabel.textColor = R.color.red()
            passwordBigSymbolsErrorImageView.tintColor = R.color.red()
            passwordBigSymbolsErrorImageView.image = R.image.statusNormalDeclined()
        case .clear:
            passwordBigSymbolsErrorLabel.textColor = R.color.textSecondary()
            passwordBigSymbolsErrorImageView.tintColor = R.color.textSecondary()
            passwordBigSymbolsErrorImageView.image = R.image.statusNormalOntime()
        }
    }
    
    func setNumericSymbolErrorState(_ state: PasswordValidationState) {
        switch state {
        case .correct:
            passwordNumericSymbolErrorLabel.textColor = R.color.green()
            passwordNumericSymbolErrorImageView.tintColor = R.color.green()
            passwordNumericSymbolErrorImageView.image = R.image.statusNormalOntime()
        case .error:
            passwordNumericSymbolErrorLabel.textColor = R.color.red()
            passwordNumericSymbolErrorImageView.tintColor = R.color.red()
            passwordNumericSymbolErrorImageView.image = R.image.statusNormalDeclined()
        case .clear:
            passwordNumericSymbolErrorLabel.textColor = R.color.textSecondary()
            passwordNumericSymbolErrorImageView.tintColor = R.color.textSecondary()
            passwordNumericSymbolErrorImageView.image = R.image.statusNormalOntime()
        }
    }
    
    func setState(_ state: PasswordValidationState, forField field: RegistrationField) {
        let textField: UITextField
        switch field {
        case .email:
            textField = emailTextField
        case .password:
            textField = passwordTextField
        case .confirmPassword:
            textField = passwordConfirmTextField
        }
        switch state {
        case .correct:
            textField.setState(.correct)
        case .error:
            textField.setState(.error)
        case .clear:
            textField.setState(.normal)
        }
    }
    
    func setEmail(_ text: String) {
        emailTextField.text = text
        checkEmail?()
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
        let contentInset = UIEdgeInsets(
            top: 0,
            left: 0,
            bottom: keyboardHeight + actionButton.frame.height
                + Constant.mainButtonBottomConstraint * 2,
            right: 0
        )
        scrollView.contentInset = contentInset
        topConstraint.constant = 0
        mainButtonBottomConstraint.constant = Constant.mainButtonBottomConstraint + keyboardHeight
        mainButtonBottomConstraint.isActive = true
        mainButtonTopConstraint.isActive = false
        UIView.animate(
            withDuration: duration,
            animations: { [weak self] in
                self?.titleLabel.alpha = 0
                if GlobalConstant.isSmallScreen {
                    self?.titleLabel.text = nil
                }
                self?.view.layoutIfNeeded()
            },
            completion: { [weak self] (_) in
                self?.navigationItem.title = R.string.localizable.registrationTitle()
            }
        )
    }
    
    func keyboardWillHide(keyboardHeight: CGFloat, duration: TimeInterval) {
        scrollView.contentInset = .zero
        topConstraint.constant = Constant.topConstraint
        mainButtonBottomConstraint.isActive = false
        mainButtonTopConstraint.isActive = true
        navigationItem.title = nil
        UIView.animate(withDuration: duration) { [weak self] in
            self?.titleLabel.alpha = 1
            if GlobalConstant.isSmallScreen {
                self?.titleLabel.text = R.string.localizable.registrationTitle()
            }
            self?.view.layoutIfNeeded()
        }
    }
    
    // MARK: - Actions
    
    @IBAction func actionButtonTapped() {
        view.endEditing(true)
        guard actionButton.isEnabled else { return }
        nextAction?()
    }
    
    
    @IBAction func loginMessageTapped(_ sender: Any) {
        loginAction?()
    }
    
    @IBAction func togglePasswordSecurityButtonTapped(_ sender: UIButton) {
        var secureTextEntry = true
        switch sender {
        case togglePasswordSecurityButton:
            secureTextEntry = !passwordTextField.isSecureTextEntry
            passwordTextField.isSecureTextEntry = secureTextEntry
        case togglePasswordConfirmSecurityButton:
            secureTextEntry = !passwordConfirmTextField.isSecureTextEntry
            passwordConfirmTextField.isSecureTextEntry = secureTextEntry
        default:
            break
        }
        let image = secureTextEntry ? R.image.commonShow() : R.image.commonHide()
        sender.setImage(image, for: .normal)
    }
    
    @IBAction func textFieldEditingChanged(_ sender: UITextField) {
        let value = sender.text
        switch sender {
        case emailTextField:
            fieldValueChanged?(.email(value: value))
        case passwordTextField:
            fieldValueChanged?(.password(value: value))
        case passwordConfirmTextField:
            fieldValueChanged?(.confirmPassword(value: value))
        default: break
        }
    }
}

extension RegistrationViewController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.setState(.highlighted)
        switch textField {
        case passwordTextField:
            UIView.animate(withDuration: Constant.passworSecurityAnimationDuration) {
                self.togglePasswordSecurityButton.alpha = 1
            }
        case passwordConfirmTextField:
        UIView.animate(withDuration: Constant.passworSecurityAnimationDuration) {
            self.togglePasswordConfirmSecurityButton.alpha = 1
        }
        default: break
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        switch textField {
        case passwordTextField,
             passwordConfirmTextField:
            let text = textField.text
            if text == nil || text!.isEmpty {
                textField.setState(.normal)
            }
        default:
            textField.setState(.normal)
        }
        switch textField {
        case passwordTextField:
            UIView.animate(withDuration: Constant.passworSecurityAnimationDuration) {
                self.togglePasswordSecurityButton.alpha = 0
            }
        case passwordConfirmTextField:
        UIView.animate(withDuration: Constant.passworSecurityAnimationDuration) {
            self.togglePasswordConfirmSecurityButton.alpha = 0
        }
        case emailTextField:
            checkEmail?()
        default: break
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case emailTextField:
            passwordTextField.becomeFirstResponder()
        case passwordTextField:
            passwordConfirmTextField.becomeFirstResponder()
        case passwordConfirmTextField:
            actionButtonTapped()
        default:
            textField.resignFirstResponder()
        }
        return true
    }
}
