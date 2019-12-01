//
//  SearchProtocols.swift
//  AppleMusic
//
//  Created Vitaly on 24.11.2019.
//  Copyright © 2019 Vitaly. All rights reserved.
//
//  Template generated by Sakhabaev Egor @Banck
//  https://github.com/Banck/Swift-viper-template-for-xcode
//

import Foundation

//MARK: Wireframe -
enum SearchNavigationOption {
    //    case firstModule
    //    case secondModule(someData)
}

protocol SearchWireframeInterface: class {
    func navigate(to option: SearchNavigationOption)
}

//MARK: Presenter -
protocol SearchPresenterInterface: class {

    var interactor: SearchInteractorInput? { get set }
    
    func fetchData(searchText: String)
    
    // MARK: - Lifecycle -
    func viewDidLoad()
    func viewWillAppear()
    func viewDidAppear()
    func viewWillDisappear()
    func viewDidDisappear()

}
extension SearchPresenterInterface {
    func viewDidLoad() {/*leaves this empty*/}
    func viewWillAppear() {/*leaves this empty*/}
    func viewDidAppear() {/*leaves this empty*/}
    func viewWillDisappear() {/*leaves this empty*/}
    func viewDidDisappear() {/*leaves this empty*/}
}


//MARK: Interactor -
protocol SearchInteractorOutput: class {
    func fetchedSearchList(lists: [Songs])
    func fetchedSearchList(error: Error)
    func fetchedFully()
    /* Interactor -> Presenter */
}

protocol SearchInteractorInput: class {

    var presenter: SearchInteractorOutput?  { get set }
    func fetchSearchingData(searchText: String)
    /* Presenter -> Interactor */
}

//MARK: View -
protocol SearchView: class {

    var presenter: SearchPresenterInterface?  { get set }
    func displayFetchedSongs(songs: [SearchCell.Data])
    /* Presenter -> ViewController */
}
