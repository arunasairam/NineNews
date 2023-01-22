//
//  NewsListViewModel.swift
//  NineNews
//
//  Created by Aruna Sairam on 20/1/2023.
//

import Foundation

protocol NewsListViewModelProvider {
    var newsAssets: [Asset] { get set }
    var sortingType: SortingType { get set }
    var onListUpdate: (() -> Void)? { get set }
    
    func loadNewsArticles(completion: @escaping (Result<[Asset], Error>) -> Void)
    func getViewModel(for indexPath: IndexPath) -> NewsCellViewModelProvider?
}

enum SortingType {
    case newest
    case oldest
}

class NewsListViewModel: NewsListViewModelProvider {
    var newsAssets = [Asset]()
    var onListUpdate: (() -> Void)?
    var sortingType: SortingType = .newest {
        didSet {
            updateBasedOnSelectedSortingType()
        }
    }
    
    private var newsAssetsNewsFirstSorted = [Asset]()
    private var newsAssetsOldestFirstSorted = [Asset]()
    private let manager: NewsManagerProtocol
    
    init(manager: NewsManagerProtocol = NewsManager()) {
        self.manager = manager
    }
    
    func loadNewsArticles(completion: @escaping (Result<[Asset], Error>) -> Void) {
        manager.loadNews { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case let .success(assets):
                self.sortByTime(assets: assets)
                self.updateBasedOnSelectedSortingType()
                completion(.success(self.newsAssets))
            
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }
    
    func getViewModel(for indexPath: IndexPath) -> NewsCellViewModelProvider? {
        guard indexPath.item < newsAssets.count else {
            return nil
        }
        
        let article = newsAssets[indexPath.item]
        let viewModel = NewsCellViewModel(article: article)
        
        return viewModel
    }
    
    private func sortByTime(assets: [Asset]) {
        newsAssetsNewsFirstSorted = assets.filter{
            $0.date != nil
        }.sorted(by: {
            $0.date?.compare($1.date ?? Date()) == .orderedDescending
        })
        
        newsAssetsOldestFirstSorted = assets.filter{
            $0.date != nil
        }.sorted(by: {
            $0.date?.compare($1.date ?? Date()) == .orderedAscending
        })
    }
    
    private func updateBasedOnSelectedSortingType() {
        newsAssets = sortingType == .newest ? newsAssetsNewsFirstSorted : newsAssetsOldestFirstSorted

        onListUpdate?()
    }
}
