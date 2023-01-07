//
//  NewsTableViewCell.swift
//  NewsApp
//
//  Created by Arundas MK on 08/01/23.
//

import UIKit

class NewsTableViewCellViewModel {
    let title: String
    let description: String
    let imageURL: URL?
    var imageData: Data?
    
    init(title: String, description: String, imageURL: URL?, imageData: Data? = nil) {
        self.title = title
        self.description = description
        self.imageURL = imageURL
        self.imageData = imageData
    }
}

class NewsTableViewCell: UITableViewCell {
    static let identifier = "NewsTableViewCell"
    
    private let newsTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 2
        label.font = .systemFont(ofSize: 16.0, weight: .medium)
        return label
    }()
    
    private let newsDescriptionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 16.0, weight: .regular)
        return label
    }()
    
    private let newsImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.backgroundColor = .secondarySystemBackground
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        contentView.addSubview(newsImageView)
        contentView.addSubview(newsTitleLabel)
        contentView.addSubview(newsDescriptionLabel)
        self.layoutIfNeeded()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        NSLayoutConstraint.activate([
            newsImageView.widthAnchor.constraint(equalToConstant: 120.0),
            newsImageView.heightAnchor.constraint(equalTo: newsImageView.widthAnchor, multiplier: 1.0),
            newsImageView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 16.0),
            newsImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16.0),
            newsImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16.0),
            
            newsTitleLabel.leftAnchor.constraint(equalTo: newsImageView.rightAnchor, constant: 8.0),
            newsTitleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16.0),
            newsTitleLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -16.0),

            newsDescriptionLabel.leftAnchor.constraint(equalTo: newsImageView.rightAnchor, constant: 8.0),
            newsDescriptionLabel.topAnchor.constraint(equalTo: newsTitleLabel.bottomAnchor, constant: 8.0),
            newsDescriptionLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -16.0),
            newsDescriptionLabel.bottomAnchor.constraint(equalTo: newsImageView.bottomAnchor, constant: 0),
            
        ])
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        newsTitleLabel.text = nil
        newsDescriptionLabel.text = nil
        newsImageView.image = nil
    }
    
    func configure(withViewModel viewModel: NewsTableViewCellViewModel) {
        newsTitleLabel.text = viewModel.title
        newsDescriptionLabel.text = viewModel.description
        if let imageData = viewModel.imageData {
            newsImageView.image = UIImage(data: imageData)
        } else if let url = viewModel.imageURL {
            URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
                guard let data = data, error == nil else {
                    return
                }
                viewModel.imageData = data
                DispatchQueue.main.async {
                    self?.newsImageView.image = UIImage(data: data)
                }
            }.resume()
        }
    }
}
