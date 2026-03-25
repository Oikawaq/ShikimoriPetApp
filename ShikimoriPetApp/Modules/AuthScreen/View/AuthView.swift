
import UIKit
import SnapKit

class AuthView: UIView {
    
    //MARK: UI-elements
    let activityIndicator: UIActivityIndicatorView = {
        let ai = UIActivityIndicatorView()
        ai.style = .medium
        return ai
    }()

    let label: UILabel = {
        let label = UILabel()
        label.text = L10n.Auth.label
        label.textColor = .chalkWhite
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 36, weight: .bold)
        label.numberOfLines = 2
        return label
    }()
    lazy var authButton = makePrimaryButton(title: L10n.Auth.loginButton)
    
    lazy var redeemCodeButton = makePrimaryButton(title: L10n.Auth.redeemCodeButton, isHidden: true)
    
    
    let backgroundImage: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "background")
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        return image
    }()
    
    
    let codeTextField : UITextField = {
        let tf = UITextField()
        tf.textColor = .chalkWhite
        tf.placeholder = L10n.Auth.placeholder
        tf.addLeftPadding(padding: 16.0)
        tf.enablePasswordToggle()
        tf.placeHolderTextColor(.chalkWhite.withAlphaComponent(0.5))
        tf.font = .monospacedSystemFont(ofSize: 15, weight: .medium)
        tf.layer.borderWidth = 2
        tf.layer.cornerRadius = 12
        tf.layer.borderColor = UIColor.lightGray.cgColor
        tf.keyboardType = .asciiCapable
        tf.isHidden = true
        return tf
    }()
    
    //MARK: Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        addViews()
        setupContraints()	
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK -> Setup UI
    private func addViews() {
        addSubview(backgroundImage)
        addSubview(label)
        addSubview(authButton)
        addSubview(redeemCodeButton)
        addSubview(codeTextField)
        
    }
    
    private func setupContraints() {

        backgroundImage.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        label.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(safeAreaLayoutGuide.snp.top).offset(16)
        }
        codeTextField.snp.makeConstraints { (make) in
            make.height.equalTo(50)
            make.top.equalTo(label.snp.bottom).offset(16)
            make.left.right.equalToSuperview().inset(16)
        }
        authButton.snp.makeConstraints { (make) in
            make.top.equalTo(label.snp.bottom).offset(16)
            make.centerX.equalToSuperview()
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.height.equalTo(36)
        }
        redeemCodeButton.snp.makeConstraints { (make) in
            make.top.equalTo(codeTextField.snp.bottom).offset(16)
            make.centerX.equalToSuperview()
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.height.equalTo(36)
        }
    }
    
    private func makePrimaryButton(title:String, isHidden: Bool = false)->UIButton{
        let btn = UIButton()
        btn.setTitle(title, for: .normal)
        btn.backgroundColor = .lightGray
        btn.titleLabel?.font = .systemFont(ofSize: 20, weight: .bold)
        btn.layer.cornerRadius = 10
        btn.isHidden = isHidden
        return btn
    }
}

extension UITextField {
    func addLeftPadding(padding: CGFloat) {
        leftView = UIView(frame: CGRect(x: 0, y: 0, width: padding, height: 0))
        leftViewMode = .always
    }

    func enablePasswordToggle() {
            let button = UIButton(type: .custom)
            
            button.setImage(UIImage(systemName: "eye"), for: .normal)
            
            button.setImage(UIImage(systemName: "eye.slash"), for: .selected)

            button.tintColor = .basalt

            let iconSize: CGFloat = 25
            let padding: CGFloat = 8
            let containerWidth = iconSize + padding
            
            let containerView = UIView(frame: CGRect(x: 0, y: 0, width: containerWidth, height: 40))
            button.frame = CGRect(x: 0, y: 0, width: iconSize, height: 40)
            button.center = containerView.center
            button.frame.origin.x = 0
            
            containerView.addSubview(button)

            self.rightView = containerView
            self.rightViewMode = .always

            button.addTarget(self, action: #selector(togglePasswordVisibility(_:)), for: .touchUpInside)

            self.isSecureTextEntry = true
        }
        
        @objc private func togglePasswordVisibility(_ sender: UIButton) {

            sender.isSelected.toggle()
            self.isSecureTextEntry.toggle()

            if let existingSelectedTextRange = self.selectedTextRange {
                self.selectedTextRange = nil
                self.selectedTextRange = existingSelectedTextRange
            }
        }
    
    func placeHolderTextColor(_ color: UIColor){
        self.attributedPlaceholder = NSAttributedString(string: self.placeholder ?? "", attributes: [.foregroundColor: color])
    }
}

