//
//  LibraryViewController.swift
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

class LibraryViewController: UIViewController {
    // MARK: - Properties
	var presenter: LibraryPresenterInterface?
    private var tableDirector: TableDirector!
    var topLibraryView = TopLibraryView()
    weak var tabBarDelegate: MainTabBarControllerDelegate?
    private let emptyView = LottieView()
    private var songsViewModel: [SearchCell.ViewModel]?
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableDirector = TableDirector(tableView: tableView)
        }
    }
    // MARK: - Lifecycle -
    
    override func viewWillAppear(_ animated: Bool) {
        presenter?.viewWillAppear()
    }
	override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
}

// MARK: - LibraryView
extension LibraryViewController: LibraryView {
    func displayEmptyView(animationName: String, title: String, message: String) {
        self.view.insertSubview(self.emptyView, belowSubview: self.tableView)
        self.emptyView.fillSuperview()
        emptyView.update(title: title, subTitle: message, lottieName: animationName, animationViewContentMode: .scaleAspectFill)
        emptyView.animate(.fade(1))
        tableView.animate(.fade(0))
    }
    
    func displayFetchedSongs(songs: [SearchCell.ViewModel], shuffleButtonClicked: Bool) {
        tableDirector.clear()
        self.songsViewModel = songs
        let section = TableSection()
        
        let configureAction = TableRowAction<SearchCell>(.configure) { [weak self] cellOption in
            guard let self = self, let cell = cellOption.cell else { return }
            cell.backgroundColor = .cellBackground
            if shuffleButtonClicked {
                let firstSelectedIndex = IndexPath(row: 0, section: 0)
                self.tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 64, right: 0)
                self.tabBarDelegate?.maximizeTrackDetailController(viewModel: songs[firstSelectedIndex.row])
                self.tableView.selectRow(at: firstSelectedIndex, animated: false, scrollPosition: .none)
            }
        }
        
        let rowSelectionAction = TableRowAction<SearchCell>(.select) { [weak self] cellOption in
            guard let self = self, let cell = cellOption.cell, let cellViewModel = cell.songViewModel else { return }
            self.tabBarDelegate?.maximizeTrackDetailController(viewModel: cellViewModel)
            self.tableView.selectRow(at: cellOption.indexPath, animated: false, scrollPosition: .none)
            self.tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 64, right: 0)
        }
        let rowCanDeleteAction = TableRowAction<SearchCell>(.canDelete) { (options) -> Bool in
            return true
        }
        let rowDeleteAction = TableRowAction<SearchCell>(.clickDelete) { [weak self] cellOption in
            guard let self = self else { return }
            section.remove(rowAt: cellOption.indexPath.row)
            self.tableView.reloadData(inPlace: true)
        }
        print (songs.map({$0.trackName}))
        let rows1: [TableRow<SearchCell>] = songs.map {
            TableRow<SearchCell>(item: $0, actions: [configureAction, rowSelectionAction, rowCanDeleteAction, rowDeleteAction], editingActions: nil)
            }
//        let rows: [TableRow<SearchCell>] = (songsViewModel?.enumerated().map{
//            TableRow<SearchCell>(item: $0.element, actions: [configureAction, rowSelectionAction, rowCanDeleteAction, rowDeleteAction])
//            })!
        section.append(rows: rows1)
        tableDirector.append(section: section)
        tableDirector.reload()
    }
}

// MARK: - UI Configuration
extension LibraryViewController {
    private func configureUI() {
        view.backgroundColor = .background
        configureTableView()
    }
    
    private func configureTableView() {
        self.tableView.tableHeaderView = topLibraryView
        tableView.tableHeaderView?.frame.size.height = CGFloat(50).dp
        tableView.contentInset = UIEdgeInsets(top: -topLibraryView.frame.origin.y, left: 0, bottom: 0, right: 0)
        tableView.backgroundColor = .background
        tableView.separatorColor = .separatorColor
        tableView.tableFooterView = UIView()
        if #available(iOS 11.0, *) {
            tableView.contentInsetAdjustmentBehavior = .never
        }
        topLibraryView.shuffleButtonTouch = { [weak self] in
            guard let self = self else { return }
            var shuffled = [SearchCell.ViewModel]()
            if var songsVM = self.songsViewModel {
                for _ in 0..<songsVM.count
                {
                    let rand = Int(arc4random_uniform(UInt32(songsVM.count)))
                    shuffled.append(songsVM[rand])
                    songsVM.remove(at: rand)
                }
                self.displayFetchedSongs(songs: shuffled, shuffleButtonClicked: true)
            }
            
            
        }
    }
}

extension LibraryViewController: TrackMovingDelegate {
    private func getTrack(isForwardTrack: Bool) -> SearchCell.ViewModel? {
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
        tableView.selectRow(at: nextIndexPath, animated: true, scrollPosition: .middle)
        let song = songsViewModel?[nextIndexPath.row]
        return song
    }
    
    func moveBackForPreviousTrack() -> SearchCell.ViewModel? {
        return getTrack(isForwardTrack: false)
    }
    
    func moveForwardForNextTrack() -> SearchCell.ViewModel? {
        return getTrack(isForwardTrack: true)
    }
}

extension Array {
    mutating func shuffling() {
        for _ in indices {
            sort { (_,_) in arc4random() < arc4random() }
        }
    }
}

