//
//  SearchViewController.swift
//  AppleMusic
//
//  Created Vitaly on 24.11.2019.
//  Copyright © 2019 Vitaly. All rights reserved.
//
//  Template generated by Sakhabaev Egor @Banck
//  https://github.com/Banck/Swift-viper-template-for-xcode
//

import UIKit
import TableKit
import Lottie

class SearchViewController: UIViewController {
    
    // MARK: - Properties
    var presenter: SearchPresenterInterface?
    var tableDirector: TableDirector!
    let searchController = UISearchController(searchResultsController: nil)
    private var timer: Timer?
    private var emptyView = AnimationView()
    
    
    // MARK: - IBOutlets
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableDirector = TableDirector(tableView: tableView)
        }
    }
    
    // MARK: - Lifecycle -
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        presenter?.viewDidLoad()
    }
    
}

// MARK: - SearchView
extension SearchViewController: SearchView {
    func displayEmptyResults() {
        tableDirector.clear()
        view.insertSubview(emptyView, aboveSubview: tableView)
        emptyView.fillSuperview()
        emptyView.animation = Animation.named("empty")
        emptyView.loopMode = .loop
        emptyView.play()
    }
    
    func displayFetchedSongs(songs: [SearchCell.Data]) {
        emptyView.removeFromSuperview()
        tableDirector.clear()
        let section = TableSection()
        let rows = songs.map{TableRow<SearchCell>(item: $0, actions: [])}
        section.append(rows: rows)
        tableDirector += [section]
        tableDirector.reload()
    }
    
}

// MARK: - UI Configuration
extension SearchViewController {
    func configureUI() {
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        searchController.obscuresBackgroundDuringPresentation = false
        definesPresentationContext = true
        searchController.searchBar.delegate = self
        view.backgroundColor = #colorLiteral(red: 0.9764705882, green: 0.9764705882, blue: 0.9803921569, alpha: 1)
        tableView.backgroundColor = #colorLiteral(red: 0.9764705882, green: 0.9764705882, blue: 0.9803921569, alpha: 1)
        tableView.separatorColor = .lightGray
        tableView.tableFooterView = UIView()
    }
}

extension SearchViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { (_) in
           self.presenter?.fetchData(searchText: searchText)
        })
    }
}


