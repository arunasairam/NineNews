//
//  NewsListViewController.swift
//  NineNews
//
//  Created by Aruna Sairam on 19/1/2023.
//

import UIKit

class NewsListViewController: UIViewController {
    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var filterButton: UIButton!
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    
    var coordinator: NewsListCoordinator?
    var viewModel: NewsListViewModelProvider?
    
    lazy var oldestAction: UIAction = {
        let action = UIAction(title: "Oldest", image: UIImage(systemName: "repeat")) { [weak self] _ in
            self?.filterButton.setTitle("Oldest", for: .normal)
            self?.viewModel?.sortingType = .oldest
            self?.updateMenu()
            HapticFeedback.tapped()
        }
        
        return action
    }()
    
    lazy var newestAction: UIAction = {
        let action = UIAction(title: "Newest", image: UIImage(systemName: "repeat")) { [weak self] _ in
            self?.filterButton.setTitle("Newest", for: .normal)
            self?.viewModel?.sortingType = .newest
            self?.updateMenu()
            HapticFeedback.tapped()
        }
        
        return action
    }()
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        loadArticles()
    }
    
    private func loadArticles() {
        activityIndicator.startAnimating()
        
        viewModel?.loadNewsArticles() { [weak self] result in
            switch result {
            case .success:
                self?.collectionView.reloadData()
                
            case let .failure(error):
                switch error as? HTTPNetworkError {
                case .networkError:
                    self?.coordinator?.showAlert(title: "Error", message: error.localizedDescription, onRetry: { _ in
                        self?.loadArticles()
                    })

                default:
                    self?.coordinator?.showAlert(title: "Error", message: error.localizedDescription)
                }
            }
            
            self?.activityIndicator.stopAnimating()
        }
        
        viewModel?.onListUpdate = { [weak self] in
            self?.collectionView.reloadData()
            self?.collectionView.scrollToTop()
        }
    }
    
    private func setUpUI() {
        navigationController?.setNavigationBarHidden(true, animated: false)
        setupCollectionView()
        setupFilterButton()
    }
    
    private func setupFilterButton() {
        updateMenu()
        filterButton.layer.masksToBounds = true
        filterButton.layer.cornerRadius = filterButton.bounds.height / 2
        filterButton.setTitle("Newest", for: .normal)
        filterButton.showsMenuAsPrimaryAction = true
    }
    
    private func updateMenu() {
        filterButton.menu = UIMenu(title: "Choose an option", image: nil, children: [viewModel?.sortingType == .newest ? oldestAction : newestAction])
    }
    
    private func setupCollectionView() {
        collectionView?.register(NewsCell.cellNib, forCellWithReuseIdentifier: NewsCell.reuseIdentifier)
        collectionView.accessibilityIdentifier = AccessibilityIdentifier.collectionView
        
        let layout = CustomCollectionViewFlowLayout(minColumnWidth: UIDevice.current.userInterfaceIdiom == .pad ? 200 : 160, cellHeight: 260)
        layout.sectionInset = UIEdgeInsets(top: 15, left: 10, bottom: 10, right: 15)
        layout.minimumInteritemSpacing = 8
        layout.minimumLineSpacing = 8
        layout.sectionInsetReference = .fromSafeArea
        layout.scrollDirection = .vertical
       
        collectionView?.collectionViewLayout = layout
        collectionView?.delegate = self
        collectionView?.dataSource = self
    }
}

extension NewsListViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel?.newsAssets.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NewsCell.reuseIdentifier, for: indexPath) as? NewsCell else {
            return NewsCell()
        }
        
        cell.viewModel = viewModel?.getViewModel(for: indexPath)
        return cell
    }
}

extension NewsListViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let urlString = viewModel?.newsAssets[indexPath.row].url,
              let url = URL(string: urlString) else { return }
        
        coordinator?.showWebViewController(with: url)
        HapticFeedback.tapped()
    }
}

