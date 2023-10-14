//
//  TranslationView.swift
//  Camera-Translate-App
//
//  Created by Moon on 2023/10/10.
//

import UIKit

protocol TranslationViewDelegate: AnyObject {
    func didTapOriginalLanguageButton(_ language: Language)
    func didTapSwitchLanguageButton()
    func didTapTranslateLanguageButton(_ language: Language)
    func didTapPauseImageView()
}

final class TranslationView: UIView {
    private lazy var sourceLanguageButton: UIButton = {
        let button = UIButton()
        button.menu = UIMenu(
            children: [
                UIAction(title: Language.korean.rawValue, handler: { _ in
                    self.delegate?.didTapOriginalLanguageButton(.korean)
                }),
                UIAction(title: Language.english.rawValue, handler: { _ in
                    self.delegate?.didTapOriginalLanguageButton(.english)
                })
            ])
        button.changesSelectionAsPrimaryAction = true
        button.showsMenuAsPrimaryAction = true
        
        button.titleLabel?.font = .preferredFont(forTextStyle: .title3)
        button.setImage(.init(systemName: "chevron.down"), for: .normal)
        button.tintColor = .black
        button.setTitleColor(.black, for: .normal)
        
        return button
    }()
    
    private let switchLanguageButton: UIButton = {
        let button = UIButton()
        button.setImage(.init(named: "changeButton"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        
        return button
    }()
    
    private lazy var targetLanguageButton: UIButton = {
        let button = UIButton()
        button.menu = UIMenu(
            children: [
                UIAction(title: Language.english.rawValue, handler: { _ in
                    self.delegate?.didTapOriginalLanguageButton(.english)
                }),
                UIAction(title: Language.korean.rawValue, handler: { _ in
                    self.delegate?.didTapOriginalLanguageButton(.korean)
                })
            ])
        button.changesSelectionAsPrimaryAction = true
        button.showsMenuAsPrimaryAction = true
        button.titleLabel?.font = .preferredFont(forTextStyle: .title3)
        button.setImage(.init(systemName: "chevron.down"), for: .normal)
        button.tintColor = .black
        button.setTitleColor(.black, for: .normal)
        
        return button
    }()
    
    let topItemStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 20
        stackView.directionalLayoutMargins = .init(top: 10, leading: 20, bottom: 10, trailing: 20)
        stackView.isLayoutMarginsRelativeArrangement = true
        
        return stackView
    }()
    
    let cameraView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray5
        
        return view
    }()
    
    private let pauseImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "pause.rectangle.fill")
        imageView.tintColor = .yellow1
        imageView.isUserInteractionEnabled = true
        
        return imageView
    }()
    
    private let contentStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        
        return stackView
    }()
    
    weak var delegate: TranslationViewDelegate?
    private var isPaused = false
    
    init() {
        super.init(frame: .zero)
        
        configureUI()
        setUpActions()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpActions() {
        switchLanguageButton.addAction(.init(
            handler: { [weak self] _ in
                self?.delegate?.didTapSwitchLanguageButton()
            }), for: .touchUpInside)
        
        pauseImageView.addGestureRecognizer(UITapGestureRecognizer(
            target: self,
            action: #selector(didTapPauseImageView)))
    }
    
    @objc
    private func didTapPauseImageView() {
        self.delegate?.didTapPauseImageView()
        togglePauseImage(isPaused: self.isPaused)
    }
    
    private func togglePauseImage(isPaused: Bool) {
        if isPaused {
            pauseImageView.image = UIImage(systemName: "pause.rectangle.fill")
        } else {
            pauseImageView.image = UIImage(systemName: "play.rectangle.fill")
        }
        
        self.isPaused = !isPaused
    }
}

// MARK: - Configure UI

extension TranslationView {
    private func configureUI() {
        setUpView()
        addSubviews()
        setUpConstraints()
    }
    
    private func setUpView() {
        self.backgroundColor = .systemBackground
    }
    
    private func addSubviews() {
        [sourceLanguageButton, switchLanguageButton, targetLanguageButton].forEach {
            topItemStackView.addArrangedSubview($0)
        }
        
        [topItemStackView, cameraView].forEach {
            contentStackView.addArrangedSubview($0)
        }
        
        [contentStackView, pauseImageView].forEach {
            addSubview($0)
        }
    }
    
    private func setUpConstraints() {
        setUpSwitchLanguageButtonConstraints()
        setUpContentStackViewConstraints()
        setUpPauseImageViewConstraints()
    }
    
    private func setUpSwitchLanguageButtonConstraints() {
        switchLanguageButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            switchLanguageButton.heightAnchor.constraint(equalTo: widthAnchor, multiplier: 0.1)
        ])
    }
    
    private func setUpContentStackViewConstraints() {
        contentStackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            contentStackView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            contentStackView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            contentStackView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            contentStackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    private func setUpPauseImageViewConstraints() {
        pauseImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            pauseImageView.widthAnchor.constraint(equalToConstant: 70),
            pauseImageView.heightAnchor.constraint(equalToConstant: 70),
            pauseImageView.centerXAnchor.constraint(equalTo: contentStackView.centerXAnchor),
            pauseImageView.bottomAnchor.constraint(equalTo: contentStackView.bottomAnchor, constant: -60)
        ])
    }
}
