//
//  ViewController.swift
//  NewsApp
//
//  Created by Arundas MK on 07/01/23.
//

import UIKit

class HomeViewController: UIViewController {
    
    private let newsTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(NewsTableViewCell.self, forCellReuseIdentifier: NewsTableViewCell.identifier)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.estimatedRowHeight = 500
        tableView.rowHeight = UITableView.automaticDimension
        return tableView
    }()
    
    private var viewModels = [NewsTableViewCellViewModel]()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "News"
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = true
        view.addSubview(newsTableView)
        newsTableView.dataSource = self
        newsTableView.delegate = self
        APIService.shared.getTopStories { [weak self] result in
            switch result {
            case .success(let articles):
                self?.viewModels = articles.compactMap({
                    NewsTableViewCellViewModel(title: $0.title ?? "", description: $0.description ?? "", imageURL: URL(string: $0.urlToImage ?? ""))
                })
                DispatchQueue.main.async {
                    self?.newsTableView.reloadData()
                }
            case .failure(let error):
                break
            }
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        NSLayoutConstraint.activate([
            newsTableView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16.0),
            newsTableView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16.0),
            newsTableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 16.0),
            newsTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -16.0)
        ])
    }


}

extension HomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: NewsTableViewCell.identifier) as? NewsTableViewCell else { fatalError() }
        cell.configure(withViewModel: viewModels[indexPath.row])
        return cell
    }
}

extension HomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //tableView.deselectRow(at: indexPath, animated: true)
    }
}
