//
//  DocPageViewController.swift
//  DocsList
//
//  Created by Александр Медведев on 12.04.2024.
//

import UIKit

final class DocPageViewController: UIViewController {
    
    var user: User
    
    private lazy var avatar: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 25
        return imageView
    }()
    
    private var avatarStub = UIImage(named: "avatarStub")
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.text = "\(user.lastName)\n\(user.firstName) \(user.patronymic)"
        label.font = .systemFont(ofSize: 16, weight: .bold)
        label.numberOfLines = 2
        label.textColor = .black
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        return label
    }()
    
    lazy private var infoStack: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    private lazy var seniority: UILabel = {
        let label = UILabel()
        
        let fullString = NSMutableAttributedString(string: "")
        let imageAttachment = NSTextAttachment()
        imageAttachment.image = UIImage(named: "wallWatch")
        let imageString = NSAttributedString(attachment: imageAttachment)
        fullString.append(imageString)
        fullString.append(NSAttributedString(string: "   Опыт работы: \(user.seniority) лет"))
        label.attributedText = fullString
        
        label.font = .systemFont(ofSize: 16)
        label.numberOfLines = 1
        label.textColor = .lightGray
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        return label
    }()
    
    private lazy var category: UILabel = {
        let label = UILabel()
        
        let fullString = NSMutableAttributedString(string: "")
        let imageAttachment = NSTextAttachment()
        imageAttachment.image = UIImage(named: "firstAidKit")
        let imageString = NSAttributedString(attachment: imageAttachment)
        fullString.append(imageString)
        fullString.append(NSAttributedString(string: "   \(user.scientificDegreeLabel.capitalizedSentence)"))
        label.attributedText = fullString
        
        label.font = .systemFont(ofSize: 16)
        label.numberOfLines = 1
        label.textColor = .lightGray
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        return label
    }()
    
    private lazy var higherEducation: UILabel = {
        let label = UILabel()
        
        let fullString = NSMutableAttributedString(string: "")
        let imageAttachment = NSTextAttachment()
        imageAttachment.image = UIImage(named: "graduationHat")
        let imageString = NSAttributedString(attachment: imageAttachment)
        fullString.append(imageString)
        if !user.higherEducation.isEmpty {
            fullString.append(NSAttributedString(string: "   \(user.higherEducation[0].university.capitalizedSentence)"))
        } else {
            fullString.append(NSAttributedString(string: "   Пока нет информации"))
        }
        label.attributedText = fullString
        
        label.font = .systemFont(ofSize: 16)
        label.numberOfLines = 1
        label.textColor = .lightGray
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        return label
    }()
    
    private lazy var workPlace: UILabel = {
        let label = UILabel()
        
        let fullString = NSMutableAttributedString(string: "")
        let imageAttachment = NSTextAttachment()
        imageAttachment.image = UIImage(named: "geoPosition")
        let imageString = NSAttributedString(attachment: imageAttachment)
        fullString.append(imageString)
        if !user.workExpirience.isEmpty {
            fullString.append(NSAttributedString(string: "   \(user.workExpirience[0].organization.capitalizedSentence)"))
        } else {
            fullString.append(NSAttributedString(string: "   Пока нет информации"))
        }
        label.attributedText = fullString
        
        label.font = .systemFont(ofSize: 16)
        label.numberOfLines = 1
        label.textColor = .lightGray
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        return label
    }()
    
    private lazy var staticLabel: UILabel = {
        let label = UILabel()
        label.text = "Стоимость услуг"
        label.font = .systemFont(ofSize: 16, weight: .bold)
        label.numberOfLines = 1
        label.textColor = .black
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        return label
    }()
    
    private lazy var pricesButton: UIButton = {
        let button = UIButton()
        button.contentHorizontalAlignment = .right
        if let minPrice = [user.textChatPrice,
                           user.videoChatPrice,
                           user.homePrice,
                           user.hospitalPrice].min() {
            button.setTitle("от \(minPrice) ₽", for: .normal)
        } else {
            button.setTitle("от ??? ₽", for: .normal)
        }
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .white
        button.addTarget(self, action: #selector(didTapPricesButton), for: .touchUpInside)
        return button
    }()
    
    private lazy var signUpButton: UIButton = {
       let button = UIButton()
        if !user.freeReceptionTime.isEmpty {
            button.setTitle("Записаться", for: .normal)
            button.setTitleColor(.white, for: .normal)
            button.backgroundColor = .systemPink
        } else {
            button.setTitle("Нет свободного расписания", for: .normal)
            button.setTitleColor(.black, for: .normal)
            button.backgroundColor = .lightGray
        }
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 8
        return button
    }()
    
    init(user: User) {
        self.user = user
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        view.backgroundColor = .backgroundColor  
        //print(user.firstName)
        setupHeader()
        setupUI()
        setupLayout()
    }
    
    private func setupHeader() {
        //navigationController?.navigationBar.prefersLargeTitles = true
        if !user.specialization.isEmpty {
            navigationItem.title = "\(user.specialization[0].name)"
        } else {
            navigationItem.title = ""
        }
    }
    
    private func setupUI() {
        
        [avatar,
         nameLabel,
         infoStack,
         pricesButton,
         staticLabel,
         signUpButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
        
        if let userAvatar = user.avatar {
            let url = URL(string: userAvatar)
            avatar.kf.indicatorType = .activity
            avatar.kf.setImage(with: url, placeholder: avatarStub)
        } else {
            avatar.image = avatarStub
        }
        
        [seniority,
         category,
         higherEducation,
         workPlace].forEach {
         infoStack.addArrangedSubview($0)
        }
    }
    
    private func setupLayout() {
        let viewSafe = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            avatar.heightAnchor.constraint(equalToConstant: 50),
            avatar.widthAnchor.constraint(equalToConstant: 50),
            avatar.topAnchor.constraint(equalTo: viewSafe.topAnchor, constant: 16),
            avatar.leadingAnchor.constraint(equalTo: viewSafe.leadingAnchor, constant: 16),
            
            nameLabel.heightAnchor.constraint(equalToConstant: 48),
            nameLabel.widthAnchor.constraint(equalToConstant: 205),
            nameLabel.topAnchor.constraint(equalTo: viewSafe.topAnchor, constant: 16),
            nameLabel.leadingAnchor.constraint(equalTo: viewSafe.leadingAnchor, constant: 82),
            
            infoStack.heightAnchor.constraint(equalToConstant: 126),
            infoStack.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 20),
            infoStack.leadingAnchor.constraint(equalTo: viewSafe.leadingAnchor, constant: 16),
            infoStack.trailingAnchor.constraint(equalTo: viewSafe.trailingAnchor, constant: -16),
            
            pricesButton.heightAnchor.constraint(equalToConstant: 60),
            pricesButton.leadingAnchor.constraint(equalTo: viewSafe.leadingAnchor, constant: 16),
            pricesButton.trailingAnchor.constraint(equalTo: viewSafe.trailingAnchor, constant: -16),
            pricesButton.topAnchor.constraint(equalTo: infoStack.bottomAnchor, constant: 20),
            
            staticLabel.heightAnchor.constraint(equalToConstant: 24),
            staticLabel.widthAnchor.constraint(equalToConstant: 127),
            staticLabel.topAnchor.constraint(equalTo: pricesButton.topAnchor, constant: 18),
            staticLabel.leadingAnchor.constraint(equalTo: pricesButton.leadingAnchor, constant: 16),
            
            signUpButton.heightAnchor.constraint(equalToConstant: 56),
            signUpButton.bottomAnchor.constraint(equalTo: viewSafe.bottomAnchor, constant: -10),
            signUpButton.leadingAnchor.constraint(equalTo: viewSafe.leadingAnchor, constant: 16),
            signUpButton.trailingAnchor.constraint(equalTo: viewSafe.trailingAnchor, constant: -16),
            
        ])
    }
    
    @objc private func didTapPricesButton() {
        print("didTapPricesButton")
    }
}
