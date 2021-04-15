//
//  UserTableViewCell.swift
//  Messenger
//
//  Created by user on 15/04/2021.
//

import UIKit

class UserTableViewCell: UITableViewCell {
    static let identifier = "UserTableViewCell"
    
    private let userImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "person.crop.circle")
        return imageView
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .regular)
        label.textColor = .label
        return label
    }()
    
    private let dividerView: UIView = {
        let divider = UIView()
        divider.backgroundColor = .systemGray4
        return divider
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.clipsToBounds = true
        contentView.addSubview(userImageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(dividerView)
        
        userImageView.layer.masksToBounds = true
        userImageView.layer.cornerRadius = 25
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let imageSize = 50
        userImageView.frame = CGRect(x: 16, y: 5, width: imageSize, height: imageSize)
        nameLabel.frame = CGRect(x: userImageView.right + 10, y: (contentView.height - 30)/2, width: contentView.width - userImageView.width - 31, height: 30)
        dividerView.frame = CGRect(x: nameLabel.left, y: contentView.bottom - 1.2, width: nameLabel.width+5, height: 1.2)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        nameLabel.text = ""
        userImageView.image = UIImage(systemName: "person.crop.circle")
    }
    
    public func configure (with viewModel:  UserViewModel) {
        nameLabel.text = viewModel.fullName
        userImageView.sd_setImage(with: viewModel.photoURL)
    }
}
