//
//  DocCell.swift
//  DocsList
//
//  Created by Александр Медведев on 12.04.2024.
//

import UIKit
import Kingfisher

final class DocCell: UITableViewCell {
    
    static let reuseIdentifier = "DocCell"
    
    private var task: URLSessionDataTask?
    
    private lazy var whiteField: UIView = {
        let field = UIView()
        field.backgroundColor = .white
        field.layer.masksToBounds = true
        field.layer.cornerRadius = 8
        return field
    }()
    
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
        label.font = .systemFont(ofSize: 16, weight: .bold)
        label.numberOfLines = 2
        label.textColor = .black
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        return label
    }()
    
    private lazy var likeButton: UIButton = {
       let button = UIButton()
        button.setImage(UIImage(named: "like"), for: .normal)
        button.addTarget(self, action: #selector(didTapLikeButton), for: .touchUpInside)
        return button
    }()
    
    private lazy var starRating: UIImageView = {
        let rating = UIImageView()
        rating.contentMode = .scaleAspectFill
        return rating
    }()

    private lazy var specAndExp: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        label.numberOfLines = 1
        label.textColor = .lightGray
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        return label
    }()
    
    private lazy var minPrice: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .bold)
        label.numberOfLines = 1
        label.textColor = .black
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        return label
    }()
    
    private lazy var signUpButton: UIButton = {
       let button = UIButton()
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 8
        return button
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .backgroundColor
        setupUI()
        setupLayout()
        selectionStyle = .none
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        task?.cancel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(user: User) {
        
        if let userAvatar = user.avatar {
            let url = URL(string: userAvatar)
            avatar.kf.indicatorType = .activity
            avatar.kf.setImage(with: url, placeholder: avatarStub)
        } else {
            avatar.image = avatarStub
        }
        
        nameLabel.text = "\(user.lastName)\n\(user.firstName) \(user.patronymic)"
        
        if Int(floor(user.ratingsRating)) == 0 {
            starRating.image = UIImage(named: "zeroStars")
        } else if Int(floor(user.ratingsRating)) == 1 {
            starRating.image = UIImage(named: "oneStars")
        } else if Int(floor(user.ratingsRating)) == 2 {
            starRating.image = UIImage(named: "twoStars")
        } else if Int(floor(user.ratingsRating)) == 3 {
            starRating.image = UIImage(named: "threeStars")
        } else if Int(floor(user.ratingsRating)) == 4 {
            starRating.image = UIImage(named: "fourStars")
        } else if Int(floor(user.ratingsRating)) >= 5 {
            starRating.image = UIImage(named: "fiveStars")
        }
        
        if !user.specialization.isEmpty {
            specAndExp.text = "\(user.specialization[0].name)・стаж \(user.seniority) лет"
        } else {
            specAndExp.text = "・стаж \(user.seniority) лет"
        }
        
        if let minPrice = [user.textChatPrice,
                        user.videoChatPrice,
                        user.homePrice,
                           user.hospitalPrice].min() {
            self.minPrice.text = "от \(minPrice) ₽"
        } else {
            minPrice.text = "от ??? ₽"
        }
        
        if !user.freeReceptionTime.isEmpty {
            signUpButton.setTitle("Записаться", for: .normal)
            signUpButton.setTitleColor(.white, for: .normal)
            signUpButton.backgroundColor = .systemPink
        } else {
            signUpButton.setTitle("Нет свободного расписания", for: .normal)
            signUpButton.setTitleColor(.black, for: .normal)
            signUpButton.backgroundColor = .backgroundColor
        }
    }
    
    private func setupUI() {
        [whiteField,
         avatar,
         nameLabel,
         likeButton,
         starRating,
         specAndExp,
         minPrice,
         signUpButton,].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview($0)
        }
    }
    
    private func setupLayout() {
        NSLayoutConstraint.activate([
            whiteField.topAnchor.constraint(equalTo: contentView.topAnchor),
            whiteField.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
            whiteField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            whiteField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            whiteField.heightAnchor.constraint(equalToConstant: 224),
            whiteField.widthAnchor.constraint(equalToConstant: 343),
            
            avatar.heightAnchor.constraint(equalToConstant: 50),
            avatar.widthAnchor.constraint(equalTo: avatar.heightAnchor, multiplier: 1),
            avatar.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            avatar.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            
            nameLabel.heightAnchor.constraint(equalToConstant: 48),
            nameLabel.widthAnchor.constraint(equalToConstant: 205),
            nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 82),
                
            likeButton.heightAnchor.constraint(equalToConstant: 24),
            likeButton.widthAnchor.constraint(equalToConstant: 24),
            likeButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            likeButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            starRating.heightAnchor.constraint(equalToConstant: 12),
            starRating.widthAnchor.constraint(equalToConstant: 70),
            starRating.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
            starRating.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            
            specAndExp.heightAnchor.constraint(equalToConstant: 18),
            specAndExp.widthAnchor.constraint(equalToConstant: 142),
            specAndExp.topAnchor.constraint(equalTo: starRating.bottomAnchor, constant: 8),
            specAndExp.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 82),
            
            minPrice.heightAnchor.constraint(equalToConstant: 24),
            minPrice.widthAnchor.constraint(equalToConstant: 205),
            minPrice.topAnchor.constraint(equalTo: specAndExp.bottomAnchor, constant: 8),
            minPrice.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 82),
            
            signUpButton.heightAnchor.constraint(equalToConstant: 47),
            signUpButton.widthAnchor.constraint(equalToConstant: 311),
            signUpButton.topAnchor.constraint(equalTo: minPrice.bottomAnchor, constant: 15),
            signUpButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16)
        ])
    }
    
    @objc private func didTapLikeButton() {
        print("didTapLikeButton")
    }
}
