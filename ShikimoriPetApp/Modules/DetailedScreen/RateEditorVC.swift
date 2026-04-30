//
//  RateEditorVCTest.swift
//  ShikimoriPetApp
//
//  Created by Иван Илькив on 3/18/26.
//

import UIKit
import SnapKit
import Combine

class RateEditorVC: UIViewController {
    
    private let viewModel: RateEditorViewModel
    private var cancellables = Set<AnyCancellable>()
        //MARK: UIComponents
    
    lazy var scoreLabel = createLabel(title: "Оценка")
    lazy var episodesLabel = createLabel(title: "Эпизоды")
    lazy var statusLabel = createLabel(title: "Статус")
    lazy var currentEpisodesField: UITextField = {
        let field = UITextField()
        field.text = "\(viewModel.currentEpisodes) "
        field.textColor = .systemBlue
        field.font = .systemFont(ofSize: 16, weight: .regular)
        field.keyboardType = .numberPad
        field.textAlignment = .left
        field.delegate = self
        field.inputAccessoryView = makeToolbar()
        return field
    }()
    lazy var maxEpisodesLabel = createLabel(title: " / \(viewModel.maxEpisodes) ")
    lazy var scoreButton: UIButton = createMenuButton(title: viewModel.currentScore == 0 ? "Без оценки" : "\(viewModel.currentScore)")
    lazy var statusButton: UIButton = createMenuButton(title: viewModel.watchingStatus.ruDescription)
    lazy var cancelButton: UIButton = createMenuButton(title: "Отмена", congfigButton: true)
    lazy var saveButton: UIButton = createMenuButton(title: "Сохранить", congfigButton: true)
    lazy var stepper: UIStepper = {
        let stepper = UIStepper()
        stepper.stepValue = 1
        stepper.minimumValue = 0
        stepper.maximumValue = Double(viewModel.maxEpisodes)
        stepper.backgroundColor = .basalt.withAlphaComponent(0.5)
        
        stepper.layer.cornerRadius = 10
        stepper.value = Double(viewModel.currentEpisodes)
        return stepper
    }()
    lazy var actionButtonsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 16
        stackView.distribution = .fillEqually
        return stackView
    }()
        //MARK: lifecycle
    init(viewModel: RateEditorViewModel){
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        updateScore()
        updateStatus()
        setupBindings()
        setupTargets()

    }
    private func setupTargets(){
        cancelButton.addTarget(self, action: #selector(cancelTapped), for: .touchUpInside)
        saveButton.addTarget(self, action: #selector(saveTapped), for: .touchUpInside)
        stepper.addTarget(self, action: #selector(stepperTapped), for: .valueChanged)
    }
        //MARK: setupUI
    private func setupUI(){
        view.backgroundColor = .basalt

        [scoreLabel, episodesLabel, statusLabel, maxEpisodesLabel,scoreButton,statusButton,actionButtonsStackView,stepper,currentEpisodesField]
            .forEach({view.addSubview($0)})
        
        actionButtonsStackView.addArrangedSubview(cancelButton)
        actionButtonsStackView.addArrangedSubview(saveButton)
        
        
        scoreLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(32)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().inset(16)
        }
        scoreButton.snp.makeConstraints { make in
            make.top.equalTo(scoreLabel.snp.bottom).offset(16)
            make.leading.equalToSuperview().offset(16)
            make.height.equalTo(44)
            make.width.greaterThanOrEqualTo(72)
        }
        episodesLabel.snp.makeConstraints { make in
            make.top.equalTo(scoreButton.snp.bottom).offset(16)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().inset(16)
        }
        currentEpisodesField.snp.makeConstraints { make in
            make.top.equalTo(episodesLabel.snp.bottom).offset(16)
            make.leading.equalToSuperview().offset(16)
        }
        maxEpisodesLabel.snp.makeConstraints { make in
            make.top.equalTo(episodesLabel.snp.bottom).offset(16)
            make.left.equalTo(currentEpisodesField.snp.right)
            make.centerY.equalTo(currentEpisodesField.snp.centerY)
        }
        stepper.snp.makeConstraints { make in
            make.height.equalTo(30)
            make.centerY.equalTo(maxEpisodesLabel.snp.centerY)
            make.left.equalTo(maxEpisodesLabel.snp.right).offset(8)
        }
        statusLabel.snp.makeConstraints { make in
            make.top.equalTo(maxEpisodesLabel.snp.bottom).offset(16)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().inset(16)
        }
        statusButton.snp.makeConstraints { make in
            make.top.equalTo(statusLabel.snp.bottom).offset(16)
            make.leading.equalToSuperview().offset(16)
            make.height.equalTo(44)
            make.width.greaterThanOrEqualTo(72)
        }
        actionButtonsStackView.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(32)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().inset(16)
        }
    }
        //MARK: bindings
    private func setupBindings(){
        viewModel.$currentStatus
              .sink { [weak self] status in
                  guard let self else { return }
                  self.statusButton.setTitle(status.ruDescription, for: .normal)
              }
              .store(in: &cancellables)
        viewModel.$currentEpisodes
            .sink { [weak self] score in
                guard let self else { return }
                self.currentEpisodesField.text = "\(score)"
            }
            .store(in: &cancellables)
    }
    private func updateScore(){
        let actions = (0...10).map { score in
            let title = score == 0 ? "Без оценки" : "\(score)"
            
            return UIAction(title: title, state: score == viewModel.currentScore ? .on : .off) {[weak self] _ in
                guard let self = self else { return }
                viewModel.currentScore = score
                self.scoreButton.setTitle(title, for: .normal)
                self.updateScore()
            }
        }
        
        scoreButton.menu = UIMenu(children: actions)
    }
        //MARK: Objc funcs
    @objc private func saveTapped() {
        viewModel.save()
        dismiss(animated: true)
    }
    @objc private func cancelTapped() { dismiss(animated: true) }
    @objc private func stepperTapped(){
        viewModel.currentEpisodes = Int(stepper.value)
    }
    @objc private func dismissKeyboard() {
        currentEpisodesField.resignFirstResponder()
    }
    
    private func updateStatus(){
        let statuses: [WatchingStatus] = [.watching, .completed, .onHold, .planned, .dropped, .none]

        let actions = statuses.map { status in
            return UIAction(title: status.ruDescription, state: status == viewModel.watchingStatus ? .on : .off) {[weak self] _ in
                guard let self = self else { return }
                self.viewModel.currentStatus = status
                self.updateStatus()
            }
        }
        statusButton.menu = UIMenu(children: actions)
    }
 
    private func createLabel(title: String) -> UILabel {
        let label = UILabel()
        label.textColor = .chalkWhite
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 16, weight: .regular)
        label.text = title
        return label
    }

    private func createMenuButton(title: String, congfigButton: Bool = false) -> UIButton {
        var config = UIButton.Configuration.filled()
        config.title = title
        config.image = UIImage(systemName: "chevron.down")
        config.imagePlacement = .trailing
        config.titleAlignment = .leading
        config.imagePadding = 10
        config.baseBackgroundColor = .basalt
        config.baseForegroundColor = .chalkWhite
        config.background.strokeColor = .chalkWhite
        config.background.strokeWidth = 1.0
        config.cornerStyle = .medium
        if congfigButton {
            config.image = nil
        }
        let button = UIButton(configuration: config)
        
        button.showsMenuAsPrimaryAction = true
        return button
    }
    private func makeToolbar() -> UIToolbar {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let done = UIBarButtonItem(title: "Готово", style: .prominent, target: self, action: #selector(dismissKeyboard))
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolbar.items = [spacer, done]
        return toolbar
    }
  
}
extension RateEditorVC: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.selectAll(nil)
        sheetPresentationController?.animateChanges {
            self.sheetPresentationController?.selectedDetentIdentifier = .large
        }
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let text = textField.text, let value = Int(text) else { return }
 
        let clamped = min(value, viewModel.maxEpisodes)
        viewModel.currentEpisodes = clamped
        stepper.value = Double(clamped)
        textField.text = "\(clamped)"
        sheetPresentationController?.animateChanges {
            self.sheetPresentationController?.selectedDetentIdentifier = .medium
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
       
        return true
    }
}
