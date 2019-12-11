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
import Motion

class SearchViewController: UIViewController {
    
    // MARK: - Properties
    var presenter: SearchPresenterInterface?
    private var tableDirector: TableDirector!
    private let searchController = UISearchController(searchResultsController: nil)
    private var timer: Timer?
    private let emptyView = LottieView()
    private var songsViewModel: [Songs]?
    weak var tabBarDelegate: MainTabBarControllerDelegate?
    var didTouchCell: ((Songs) -> Void)?
    
    
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
        searchBar(searchController.searchBar, textDidChange: "Billie")
    }
}

// MARK: - SearchView
extension SearchViewController: SearchView {
    func displayEmptyView(animationName: String, title: String, message: String) {
        self.view.insertSubview(self.emptyView, belowSubview: self.tableView)
        self.emptyView.fillSuperview()
        emptyView.update(title: title, subTitle: message, lottieName: animationName, animationViewContentMode: .scaleAspectFill)
        emptyView.animate(.fade(1))
        tableView.animate(.fade(0))
    }
    
    func displayFetchedSongs(songs: [Songs]) {
        self.songsViewModel = songs
        emptyView.animate(.fade(0))
        tableView.animate(.fade(1))
        tableDirector.clear()
        let section = TableSection()
        let configureAction = TableRowAction<SearchCell>.init(.configure) { (options) in
            options.cell?.backgroundColor = .cellBackground
        }
        let rowSelectionAction = TableRowAction<SearchCell>.init(.select) { [weak self] options in
            guard let self = self else { return }
            let index: Int = options.indexPath.row
            let cellViewModel = songs[index]
            self.didTouchCell?(cellViewModel)
            self.tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 64, right: 0)
        }
        let rows: [TableRow<SearchCell>] = songs.enumerated().map{
            TableRow<SearchCell>(item: $0.element, actions: [configureAction, rowSelectionAction])
        }
        tableDirector.appendAndFill(section, with: rows, animation: .fade(duration: 0.2))
    }
    
}

// MARK: - UI Configuration
extension SearchViewController {
    private func configureUI() {
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        searchController.obscuresBackgroundDuringPresentation = false
        definesPresentationContext = true
        searchController.searchBar.delegate = self
        view.backgroundColor = .background
        configureTableView()
    }
    private func configureTableView() {
        tableView.backgroundColor = .background
        tableView.separatorColor = .separatorColor
        tableView.tableFooterView = UIView()
        tableView.keyboardDismissMode = .onDrag
    }
}

extension SearchViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { (_) in
            if !searchText.isEmpty {
                self.presenter?.fetchData(searchText: searchText)
            }
        })
    }
}

extension SearchViewController: TrackMovingDelegate {
    
    private func getTrack(isForwardTrack: Bool) -> Songs? {
        guard let indexPath = tableView.indexPathForSelectedRow else { return nil }
        tableView.deselectRow(at: indexPath, animated: true)
        var nextIndexPath: IndexPath!
        if isForwardTrack {
            nextIndexPath = IndexPath(row: indexPath.row + 1, section: indexPath.section)
            if nextIndexPath.row == songsViewModel?.count {
                nextIndexPath.row = 0
            }
        } else {
            nextIndexPath = IndexPath(row: indexPath.row - 1, section: indexPath.section)
            if nextIndexPath.row == -1 {
                nextIndexPath.row = (songsViewModel?.count ?? 0) - 1
            }
        }
        tableView.selectRow(at: nextIndexPath, animated: true, scrollPosition: .none)
        let song = songsViewModel?[nextIndexPath.row]
        return song
    }
    
    func moveBackForPreviousTrack() -> Songs? {
        return getTrack(isForwardTrack: false)
    }
    
    func moveForwardForNextTrack() -> Songs? {
        return getTrack(isForwardTrack: true)
    }
}
