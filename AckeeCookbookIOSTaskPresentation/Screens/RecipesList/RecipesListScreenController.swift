//
//  RecipesListScreenController.swift
//  AckeeCookbookIOSTaskPresentation
//
//  Created by Ihor Myroniuk on 3/25/20.
//  Copyright © 2020 Ihor Myroniuk. All rights reserved.
//

import AUIKit
import AFoundation

protocol RecipesListScreenDelegate: class {
    func recipesListScreenAddRecipe(_ recipesListScreen: RecipesListScreenController)
    func recipesListScreenGetRecipes(_ recipesListScreen: RecipesListScreenController, offset: Int, limit: Int, completionHandler: @escaping (Result<[RecipeInList], Error>) -> ())
    func recipesListScreenShowRecipeDetails(_ recipesListScreen: RecipesListScreenController, recipeInList: RecipeInList)
}

class RecipesListScreenController: AUIStatusBarScreenController, UICollectionViewDataSource, UICollectionViewDelegate, RecipesListScreenRepeatLoadCollectionViewCellDelegate {

    // MARK: RecipesListScreen

    weak var delegate: RecipesListScreenDelegate?

    func knowRecipeWasAdded(_ recipe: RecipeInList) {
        refreshList()
    }
    
    func knowRecipeWasDeleted(_ recipe: RecipeInList) {
        let id = recipe.id
        guard let item = recipesInList.firstIndex(where: { $0.id == id }) else { return }
        let section = RecipesListScreenController.recipesSection
        recipesInList.remove(at: item)
        recipesInListLoadOffset -= 1
        let indexPath = IndexPath(item: item, section: section)
        recipesListScreenView.collectionView.performBatchUpdates({
            self.recipesListScreenView.collectionView.deleteItems(at: [indexPath])
        }, completion: nil)
    }
    
    func knowRecipeScoreWasChanged(_ recipe: RecipeInList, score: Float) {
        let recipeId = recipe.id
        guard let item = recipesInList.firstIndex(where: { $0.id == recipeId }) else { return }
        let section = RecipesListScreenController.recipesSection
        recipesInList[item].score = score
        let indexPath = IndexPath(item: item, section: section)
        recipesListScreenView.collectionView.performBatchUpdates({
            self.recipesListScreenView.collectionView.reloadItems(at: [indexPath])
        }, completion: nil)
    }
    
    func knowRecipeWasUpdated(_ recipe: RecipeInList) {
        let recipeId = recipe.id
        guard let index = recipesInList.firstIndex(where: { $0.id == recipeId }) else { return }
        recipesInList[index] = recipe
        let section = RecipesListScreenController.recipesSection
        let indexPath = IndexPath(item: index, section: section)
        recipesListScreenView.collectionView.performBatchUpdates({
            self.recipesListScreenView.collectionView.reloadItems(at: [indexPath])
        }, completion: nil)
    }

    // MARK: Data

    private var recipesInListLoadOffset: Int = 0
    private let recipesInListLoadlimit: Int = 10
    private var recipesInList: [RecipeInList] = []
    private var lastDisplayedRecipeInListIndex: Int?
    private var isLoading = false
    private var isRepeatLoad = false

    // MARK: Localization

    private let localizer: Localizer = {
        let bundle = Bundle(for: RecipesListScreenController.self)
        let tableName = "RecipesListScreenStrins"
        let textLocalizer = TableNameBundleTextLocalizer(tableName: tableName, bundle: bundle)
        let localizator = CompositeLocalizer(textLocalization: textLocalizer)
        return localizator
    }()

    // MARK: RecipesListScreenView

    private var recipesListScreenView: RecipesListScreenView! {
        return view as? RecipesListScreenView
    }

    // MARK: Events

    override func viewDidLoad() {
        super.viewDidLoad()
        recipesListScreenView.collectionView.dataSource = self
        recipesListScreenView.collectionView.delegate = self
        recipesListScreenView.addRecipeButton.addTarget(self, action: #selector(addReceipe), for: .touchUpInside)
        recipesListScreenView.refreshControl.addTarget(self, action: #selector(refreshRecipesList), for: .valueChanged)
        setContent()
    }
    
    private var isFirstViewWillAppear = true
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if isFirstViewWillAppear {
            refreshList()
        }
        isFirstViewWillAppear = false
        if recipesListScreenView.refreshControl.isRefreshing {
            recipesListScreenView.refreshControl.beginRefreshing()
        }
    }
    
    func recipesListScreenRepeatLoadCollectionViewCellRepeatLoad(_ recipesListScreenRepeatLoadCollectionViewCell: RecipesListScreenRepeatLoadCollectionViewCell) {
        loadList()
    }

    // MARK: Actions

    private func refreshList() {
        lastDisplayedRecipeInListIndex = nil
        recipesInListLoadOffset = 0
        recipesListScreenView.refreshControl.beginRefreshing()
        let offset = recipesInListLoadOffset
        let limit = 2 * recipesInListLoadlimit
        delegate?.recipesListScreenGetRecipes(self, offset: offset, limit: limit, completionHandler: { [weak self] (result) in
            guard let self = self else { return }
            switch result {
            case .success(let recipes):
                self.recipesInListLoadOffset += limit
                var deletedIndexPaths: [IndexPath] = []
                let section = RecipesListScreenController.recipesSection
                for item in 0..<self.recipesInList.count {
                    let indexPath = IndexPath(item: item, section: section)
                    deletedIndexPaths.append(indexPath)
                }
                if self.isLoading {
                    self.isLoading = false
                    let indexPath = IndexPath(item: 0, section: RecipesListScreenController.loadingSection)
                    deletedIndexPaths.append(indexPath)
                }
                if self.isRepeatLoad {
                    self.isRepeatLoad = false
                    let indexPath = IndexPath(item: 0, section: RecipesListScreenController.repeatLoadSection)
                    deletedIndexPaths.append(indexPath)
                }
                var insertedIndexPaths: [IndexPath] = []
                for item in Int(offset)..<(Int(offset) + recipes.count) {
                    let indexPath = IndexPath(item: item, section: RecipesListScreenController.recipesSection)
                    insertedIndexPaths.append(indexPath)
                }
                self.recipesInList = recipes
                self.recipesListScreenView.collectionView.contentOffset = .zero
                self.recipesListScreenView.refreshControl.endRefreshing()
                self.recipesListScreenView.collectionView.performBatchUpdates({
                    self.recipesListScreenView.collectionView.deleteItems(at: deletedIndexPaths)
                    self.recipesListScreenView.collectionView.insertItems(at: insertedIndexPaths)
                }, completion: nil)
            case .failure:
                var deletedIndexPaths: [IndexPath] = []
                let section = RecipesListScreenController.recipesSection
                for item in 0..<self.recipesInList.count {
                    let indexPath = IndexPath(item: item, section: section)
                    deletedIndexPaths.append(indexPath)
                }
                if self.isLoading {
                    self.isLoading = false
                    let indexPath = IndexPath(item: 0, section: RecipesListScreenController.loadingSection)
                    deletedIndexPaths.append(indexPath)
                }
                if self.isRepeatLoad {
                    self.isRepeatLoad = false
                    let indexPath = IndexPath(item: 0, section: RecipesListScreenController.repeatLoadSection)
                    deletedIndexPaths.append(indexPath)
                }
                self.recipesInList = []
                self.recipesListScreenView.collectionView.contentOffset = .zero
                self.recipesListScreenView.refreshControl.endRefreshing()
                self.recipesListScreenView.collectionView.performBatchUpdates({
                    self.recipesListScreenView.collectionView.deleteItems(at: deletedIndexPaths)
                }, completion: nil)
            }
        })
    }

    private func loadList() {
        var insertedIndexPaths: [IndexPath] = []
        if !isLoading {
            isLoading = true
            let indexPath = IndexPath(item: 0, section: RecipesListScreenController.loadingSection)
            insertedIndexPaths.append(indexPath)
        }
        var deletedIndexPaths: [IndexPath] = []
        if isRepeatLoad {
            isRepeatLoad = false
            let indexPath = IndexPath(item: 0, section: RecipesListScreenController.repeatLoadSection)
            deletedIndexPaths.append(indexPath)
        }
        recipesListScreenView.collectionView.performBatchUpdates({
            self.recipesListScreenView.collectionView.insertItems(at: insertedIndexPaths)
            self.recipesListScreenView.collectionView.deleteItems(at: deletedIndexPaths)
        }, completion: nil)
        let offset = recipesInListLoadOffset
        let limit = recipesInListLoadlimit
        delegate?.recipesListScreenGetRecipes(self, offset: offset, limit: limit, completionHandler: { [weak self] (result) in
            guard let self = self else { return }
            switch result {
            case .success(let recipes):
                self.recipesInListLoadOffset += limit
                var deletedIndexPaths: [IndexPath] = []
                if self.isLoading {
                    self.isLoading = false
                    let indexPath = IndexPath(item: 0, section: RecipesListScreenController.loadingSection)
                    deletedIndexPaths.append(indexPath)
                }
                if self.isRepeatLoad {
                    self.isRepeatLoad = false
                    let indexPath = IndexPath(item: 0, section: RecipesListScreenController.repeatLoadSection)
                    deletedIndexPaths.append(indexPath)
                }
                var insertedIndexPaths: [IndexPath] = []
                for item in Int(offset)..<(Int(offset) + recipes.count) {
                    let indexPath = IndexPath(item: item, section: RecipesListScreenController.recipesSection)
                    insertedIndexPaths.append(indexPath)
                }
                self.recipesInList.append(contentsOf: recipes)
                self.recipesListScreenView.collectionView.performBatchUpdates({
                    self.recipesListScreenView.collectionView.deleteItems(at: deletedIndexPaths)
                    self.recipesListScreenView.collectionView.insertItems(at: insertedIndexPaths)
                }, completion: nil)
            case .failure:
                var deletedIndexPaths: [IndexPath] = []
                if self.isLoading {
                    self.isLoading = false
                    let indexPath = IndexPath(item: 0, section: RecipesListScreenController.loadingSection)
                    deletedIndexPaths.append(indexPath)
                }
                var insertedIndexPaths: [IndexPath] = []
                if !self.isRepeatLoad {
                    self.isRepeatLoad = true
                    let indexPath = IndexPath(item: 0, section: RecipesListScreenController.repeatLoadSection)
                    insertedIndexPaths.append(indexPath)
                }
                self.recipesListScreenView.collectionView.performBatchUpdates({
                    self.recipesListScreenView.collectionView.deleteItems(at: deletedIndexPaths)
                    self.recipesListScreenView.collectionView.insertItems(at: insertedIndexPaths)
                }, completion: nil)
            }
        })
    }

    @objc private func addReceipe() {
        delegate?.recipesListScreenAddRecipe(self)
    }

    @objc private func refreshRecipesList() {
        refreshList()
    }
    
    private func willDisplayRecipeInListAtIndex(_ index: Int) {
        func loadListAsync() {
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.loadList()
            }
        }
        guard recipesInListLoadOffset % recipesInListLoadlimit == 0 else { return }
        if Int(recipesInListLoadOffset) - (Int(recipesInListLoadlimit) / 2) == index {
            if let lastDisplayedRecipeInListIndex = self.lastDisplayedRecipeInListIndex {
                if index > lastDisplayedRecipeInListIndex {
                    self.lastDisplayedRecipeInListIndex  = index
                    loadListAsync()
                }
            } else {
                lastDisplayedRecipeInListIndex  = index
                loadListAsync()
            }
        }
    }

    // MARK: Content

    private func setContent() {
        recipesListScreenView.titleLabel.text = localizer.localizeText("title")
    }

    // MARK: UICollectionViewDataSource, UICollectionViewDelegate

    static let recipesSection = 0
    static let loadingSection = 1
    static let repeatLoadSection = 2
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return [RecipesListScreenController.recipesSection, RecipesListScreenController.loadingSection, RecipesListScreenController.repeatLoadSection].count
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case RecipesListScreenController.recipesSection:
            return recipesInList.count
        case RecipesListScreenController.loadingSection:
            return isLoading ? 1 : 0
        case RecipesListScreenController.repeatLoadSection:
            return isRepeatLoad ? 1 : 0
        default:
            return 0
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let section = indexPath.section
        let item = indexPath.item
        switch section {
        case RecipesListScreenController.recipesSection:
            let recipe = recipesInList[item]
            let cell: RecipesListScreenRecipeCollectionViewCell = recipesListScreenView.recipeCollectionViewCell(indexPath)
            cell.nameLabel.text = recipe.name
            cell.scoreView.setScore(recipe.score)
            cell.durationLabel.text = localizer.localizeText("durationInMinutes", "\(recipe.duration)")
            return cell
        case RecipesListScreenController.loadingSection:
            let cell: RecipesListScreenLoadingCollectionViewCell = recipesListScreenView.loadingCollectionViewCell(indexPath)
            return cell
        case RecipesListScreenController.repeatLoadSection:
            let cell: RecipesListScreenRepeatLoadCollectionViewCell = recipesListScreenView.repeatLoadCollectionViewCell(indexPath)
            cell.delegate = self
            cell.repeatLoadButton.setTitle(localizer.localizeText("repeatLoad"), for: .normal)
            return cell
        default:
            return UICollectionViewCell()
        }
    }

    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let section = indexPath.section
        let item = indexPath.item
        switch section {
        case RecipesListScreenController.recipesSection:
            willDisplayRecipeInListAtIndex(item)
        default:
            break
        }
        
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let section = indexPath.section
        switch section {
        case RecipesListScreenController.recipesSection:
            let recipe = recipesInList[indexPath.item]
            delegate?.recipesListScreenShowRecipeDetails(self, recipeInList: recipe)
        default:
            break
        }
    }

}
