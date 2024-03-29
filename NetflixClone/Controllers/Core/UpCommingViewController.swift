//
//  UpCommingViewController.swift
//  NetflixClone
//
//  Created by Furkan on 19.06.2023.
//

import UIKit

class UpCommingViewController: UIViewController {

    
    private var titles: [Title] = [Title]()
    
    private let upcomingtable: UITableView = {
       
        let table = UITableView()
        table.register(TitleTableViewCell.self, forCellReuseIdentifier: TitleTableViewCell.identifier)
        return table
        
    }()
    override func viewDidLoad() {
        super.viewDidLoad()

        
        view.backgroundColor = .systemBackground
        title = "Upcoming"
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        
        
        
        
        view.addSubview(upcomingtable)
        upcomingtable.delegate = self
        upcomingtable.dataSource = self
        
        fetchUpComing()
    }
    
    //!Important!
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        upcomingtable.frame = view.bounds
    }
    
    
    private func fetchUpComing() {
        APICaller.shared.getUpCommingMovies { [weak self] result in
            switch result {
            case .success((let titles)):
                self?.titles = titles
                DispatchQueue.main.async {
                    self?.upcomingtable.reloadData()
                }
                
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    

}

extension UpCommingViewController : UITableViewDelegate, UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TitleTableViewCell.identifier, for: indexPath) as? TitleTableViewCell else {
            return UITableViewCell()
        }
        let title = titles[indexPath.row]
        cell.configure(with: TitleViewModel(titleName: (title.original_title ?? title.original_name) ?? "Unknown title name", posterURL: title.poster_path ?? ""))
        return cell
    }
    
    //Item size
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let title = titles[indexPath.row]
        
        guard let titleName = title.original_name ?? title.original_title else {return}
        
        APICaller.shared.getMovie(with: titleName) { [weak self] result in
            switch result {
            case .success(let videoElement):
                DispatchQueue.main.async {
                    let vc = TitlePreviewViewController()
                    vc.configure(with: TitlePreviewViewModel(title: titleName, youtubeView: videoElement, titleOverview: title.overview ?? ""))
                    self?.navigationController?.pushViewController(vc, animated: true)
                }
                
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
}
