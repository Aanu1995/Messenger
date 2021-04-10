//
//  LoadingView.swift
//  Messenger
//
//  Created by user on 10/04/2021.
//

import UIKit

final class LoadingView: UIView {
    
    private let spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(style: .large)
        spinner.color = .systemBackground
        spinner.startAnimating()
        return spinner
    }()
    
    private let label: UILabel = {
        let textLabel = UILabel()
        textLabel.textColor = .systemBackground
        textLabel.textAlignment = .center
        textLabel.font = .systemFont(ofSize: 12.0, weight: .semibold)
        textLabel.text = "Loading..."
        return textLabel
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .label
        clipsToBounds = true
        alpha = 0.9
        layer.cornerRadius = 10
        addSubview(spinner)
        addSubview(label)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        label.sizeToFit()
        label.frame = CGRect(x: 0, y: height - label.height - 10, width: width, height: label.height)
        spinner.frame = CGRect(x: (width - 40)/2, y: 12, width: 40, height: 40)
    }
    
    public func configure(with text: String){
        label.text = text
    }
}
