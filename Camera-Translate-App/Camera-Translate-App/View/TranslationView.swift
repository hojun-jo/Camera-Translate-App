//
//  TranslationView.swift
//  Camera-Translate-App
//
//  Created by Moon on 2023/10/10.
//

import UIKit

protocol TranslationViewDelegate: AnyObject {
    func didTappedOriginalLanguageButton()
    func didTappedSwitchLanguageButton()
    func didTappedTranslateLanguageButton()
    func didTappedPauseImageView()
}

final class TranslationView: UIView {
    private let originalLanguageButton: UIButton = {
        let button = UIButton()
        button.setTitle("한국어", for: .normal)
        button.titleLabel?.font = .preferredFont(forTextStyle: .title2)
        button.setImage(.init(systemName: "chevron.down"), for: .normal)
        button.tintColor = .black
        button.setTitleColor(.black, for: .normal)
        
        return button
    }()
    
    private let switchLanguageButton: UIButton = {
        let button = UIButton()
        button.setImage(.init(systemName: "arrow.left.arrow.right"), for: .normal)
        button.tintColor = .black
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 12
        
        return button
    }()
    
    private let translateLanguageButton: UIButton = {
        let button = UIButton()
        button.setTitle("영어", for: .normal)
        button.titleLabel?.font = .preferredFont(forTextStyle: .title2)
        button.setImage(.init(systemName: "chevron.down"), for: .normal)
        button.tintColor = .black
        button.setTitleColor(.black, for: .normal)
        
        return button
    }()
    
    private let topItemStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 20
        stackView.directionalLayoutMargins = .init(top: 10, leading: 20, bottom: 10, trailing: 20)
        stackView.isLayoutMarginsRelativeArrangement = true
        
        return stackView
    }()
    
    private let cameraView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .yellow
        
        return imageView
    }()
    
    private let pauseImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "pause.circle")
        imageView.tintColor = .black
        imageView.layer.cornerRadius = 50
        imageView.layer.backgroundColor = UIColor.white.cgColor
        imageView.isUserInteractionEnabled = true
        
        return imageView
    }()
    
    private let contentStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        
        return stackView
    }()
    
    weak var delegate: TranslationViewDelegate?
    private var tapGestureRecognizer = UITapGestureRecognizer()
    
    init() {
        super.init(frame: .zero)
        
        configureUI()
        setUpActions()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpActions() {
        originalLanguageButton.addAction(.init(
            handler: { [weak self] _ in
            self?.delegate?.didTappedOriginalLanguageButton()
        }), for: .touchUpInside)
        
        switchLanguageButton.addAction(.init(
            handler: { [weak self] _ in
            self?.delegate?.didTappedSwitchLanguageButton()
        }), for: .touchUpInside)
        
        translateLanguageButton.addAction(.init(
            handler: { [weak self] _ in
            self?.delegate?.didTappedTranslateLanguageButton()
        }), for: .touchUpInside)
        
        tapGestureRecognizer.addTarget(self, action: #selector(didTappedPauseImageView))
        pauseImageView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc
    private func didTappedPauseImageView() {
        self.delegate?.didTappedPauseImageView()
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
        [originalLanguageButton, switchLanguageButton, translateLanguageButton].forEach {
            topItemStackView.addArrangedSubview($0)
        }
        
        [topItemStackView, cameraView].forEach {
            contentStackView.addArrangedSubview($0)
        }
        
        [contentStackView, pauseImageView].forEach {
            self.addSubview($0)
        }
    }
    
    private func setUpConstraints() {
        setUpContentStackViewConstraints()
        setUpPauseImageViewConstraints()
    }
    
    private func setUpContentStackViewConstraints() {
        contentStackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            contentStackView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor),
            contentStackView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor),
            contentStackView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
            contentStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
    
    private func setUpPauseImageViewConstraints() {
        pauseImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            pauseImageView.widthAnchor.constraint(equalToConstant: 100),
            pauseImageView.heightAnchor.constraint(equalToConstant: 100),
            pauseImageView.centerXAnchor.constraint(equalTo: contentStackView.centerXAnchor),
            pauseImageView.bottomAnchor.constraint(equalTo: contentStackView.bottomAnchor, constant: -60)
        ])
    }
}
