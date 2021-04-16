//
//  TitleView.swift
//  Messenger
//
//  Created by user on 16/04/2021.
//

import UIKit

class TitleView: UIView {
    
    private let userImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "person.crop.circle")
        return imageView
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        label.textColor = .label
        
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        clipsToBounds = true
        addSubview(userImageView)
        addSubview(nameLabel)
        
        userImageView.layer.masksToBounds = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let imageSize = height - 10
        userImageView.frame = CGRect(x: 0, y: 5, width: imageSize, height: imageSize)
        userImageView.layer.cornerRadius = imageSize/2
        nameLabel.frame = CGRect(x: userImageView.right + 10, y: (height - 30)/2, width: width - userImageView.width - 10, height: 30)
    }
    
    public func configure (with viewModel:  UserViewModel) {
        nameLabel.text = viewModel.fullName
        userImageView.sd_setImage(with: viewModel.photoURL)
    }
}
