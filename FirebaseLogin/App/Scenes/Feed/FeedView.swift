//
//  FeedView.swift
//  FirebaseLogin
//
//  Created by Diggo Silva on 03/02/25.
//

import UIKit

protocol FeedViewDelegate: AnyObject {
    func signoutButtonTapped()
}

class FeedView: UIView {
    
    lazy var welcomeLabel: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.numberOfLines = 0
        lbl.font = .systemFont(ofSize: 16, weight: .semibold)
        lbl.textAlignment = .center
        return lbl
    }()
    
    lazy var signoutButton = buildButton(title: "Fazer Logout", color: .systemRed, selector: #selector(signoutButtonTapped))
    
    var email: String = "" {
        didSet {
            welcomeLabel.text = "Seja bem-vindo, \(email)"
        }
    }
    
    weak var delegate: FeedViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setupView()
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    @objc func signoutButtonTapped() {
        delegate?.signoutButtonTapped()
    }
    
    private func setupView() {
        setHierarchy()
        setConstraints()
    }
    
    private func setHierarchy() {
        backgroundColor = .systemBackground
        addSubviews([welcomeLabel, signoutButton])
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            welcomeLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            welcomeLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            welcomeLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            welcomeLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            
            signoutButton.topAnchor.constraint(equalTo: welcomeLabel.bottomAnchor, constant: 20),
            signoutButton.centerXAnchor.constraint(equalTo: welcomeLabel.centerXAnchor),
        ])
    }
}
