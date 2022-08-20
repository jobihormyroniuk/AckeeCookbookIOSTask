//
//  RecipesListScreenCollectionViewLayout.swift
//  AckeeCookbookIOSTaskPresentation
//
//  Created by Ihor Myroniuk on 17.05.2020.
//  Copyright © 2020 Ihor Myroniuk. All rights reserved.
//

import AUIKit

final class RecipesListScreenCollectionViewLayout: UICollectionViewLayout {

    // MARK: Setup
    
    override init() {
        super.init()
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let separatorCollectionReusableViewIdentifier = "separatorCollectionReusableViewIdentifier"
    func setup() {
        self.register(SeparatorCollectionReusableView.self, forDecorationViewOfKind: separatorCollectionReusableViewIdentifier)
    }
    
    private var y = 0
    override func prepare() {
        super.prepare()
        y = 0
        prepareRecipesInList()
        prepareLoading()
        prepareRepeatLoad()
    }
    
    private var recipesLayoutAttributes: [UICollectionViewLayoutAttributes] = []
    private var recipesSeparatorsLayoutAttributes: [UICollectionViewLayoutAttributes] = []
    private func prepareRecipesInList() {
        recipesLayoutAttributes = []
        recipesSeparatorsLayoutAttributes = []
        guard let collectionView = collectionView else { return }
        let section = RecipesListScreenController.recipesSection
        let numberOfItems = collectionView.numberOfItems(inSection: section)
        guard numberOfItems > 0 else { return }
        let bounds = collectionView.bounds
        let boundsWidth = Int(bounds.width)
        let x = 24
        let width = boundsWidth - x * 2
        let spacing = 16
        y += spacing
        let height = 76
        for item in 0..<numberOfItems {
            let indexPath = IndexPath(item: item, section: section)
            let recipeLayoutAttribute = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            recipeLayoutAttribute.frame = CGRect(x: x, y: y, width: width, height: height)
            recipesLayoutAttributes.append(recipeLayoutAttribute)
            y += height + spacing
            if item != numberOfItems - 1 {
                let recipeSeparatorLayoutAttribute = UICollectionViewLayoutAttributes(forDecorationViewOfKind: separatorCollectionReusableViewIdentifier, with: indexPath)
                recipeSeparatorLayoutAttribute.frame = CGRect(x: x, y: y, width: width, height: 1)
                recipesSeparatorsLayoutAttributes.append(recipeSeparatorLayoutAttribute)
                y += spacing + 1
            }
        }
    }
    
    private var loadingLayoutAttributes: [UICollectionViewLayoutAttributes] = []
    private func prepareLoading() {
        loadingLayoutAttributes = []
        guard let collectionView = collectionView else { return }
        let section = RecipesListScreenController.loadingSection
        let numberOfItems = collectionView.numberOfItems(inSection: section)
        let bounds = collectionView.bounds
        let boundsWidth = Int(bounds.width)
        if numberOfItems == 1 {
            y += 1
            let item = 0
            let x = 24
            let width = boundsWidth - x * 2
            let height = 38
            let indexPath = IndexPath(item: item, section: section)
            let recipesInListLoadLayoutAttribute = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            recipesInListLoadLayoutAttribute.frame = CGRect(x: x, y: y, width: width, height: height)
            y += height + 16
            loadingLayoutAttributes.append(recipesInListLoadLayoutAttribute)
        }
    }
    
    private var repeatLoadLayoutAttributes: [UICollectionViewLayoutAttributes] = []
    private func prepareRepeatLoad() {
        repeatLoadLayoutAttributes = []
        guard let collectionView = collectionView else { return }
        let section = RecipesListScreenController.repeatLoadSection
        let numberOfItems = collectionView.numberOfItems(inSection: section)
        let bounds = collectionView.bounds
        let boundsWidth = Int(bounds.width)
        if numberOfItems == 1 {
            y += 1
            let item = 0
            let x = 24
            let width = boundsWidth - x * 2
            let height = 38
            let indexPath = IndexPath(item: item, section: section)
            let recipesInListLoadLayoutAttribute = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            recipesInListLoadLayoutAttribute.frame = CGRect(x: x, y: y, width: width, height: height)
            y += height + 16
            repeatLoadLayoutAttributes.append(recipesInListLoadLayoutAttribute)
        }
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let layoutAttributes = recipesLayoutAttributes + recipesSeparatorsLayoutAttributes + loadingLayoutAttributes + repeatLoadLayoutAttributes
        let layoutAttributesInRect = layoutAttributes.filter({ $0.frame.intersects(rect) })
        return layoutAttributesInRect
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        let section = indexPath.section
        let item = indexPath.item
        if section == RecipesListScreenController.recipesSection {
            return recipesLayoutAttributes[item]
        }
        if section == RecipesListScreenController.loadingSection {
            return loadingLayoutAttributes.first
        }
        if section == RecipesListScreenController.repeatLoadSection {
            return repeatLoadLayoutAttributes.first
        }
        return nil
    }
    
    override func layoutAttributesForDecorationView(ofKind elementKind: String, at indexPath: IndexPath)
        -> UICollectionViewLayoutAttributes? {
        if elementKind == separatorCollectionReusableViewIdentifier {
            return recipesSeparatorsLayoutAttributes[indexPath.item]
        }
        return nil
    }
    
    override var collectionViewContentSize: CGSize {
        guard let collectionView = collectionView else { return .zero }
        let width = Int(collectionView.bounds.size.width)
        let height = y
        let size = CGSize(width: width, height: height)
        return size
    }
    
    // MARK: Updates
    
    private var deletedIndexPathsForDecorationView: [IndexPath] = []
    private var insertedIndexPathsForDecorationView: [IndexPath] = []
    override func prepare(forCollectionViewUpdates updateItems: [UICollectionViewUpdateItem]) {
        super.prepare(forCollectionViewUpdates: updateItems)
        guard let collectionView = collectionView else { return }
        for updateItem in updateItems {
            let updateAction = updateItem.updateAction
            switch updateAction {
            case .insert:
                guard let indexPath = updateItem.indexPathAfterUpdate else { return }
                let section = indexPath.section
                if section == RecipesListScreenController.recipesSection {
                    insertedIndexPathsForDecorationView.append(indexPath)
                }
            case .delete:
                guard var indexPath = updateItem.indexPathBeforeUpdate else { return }
                let section = indexPath.section
                let item = indexPath.item
                if section == RecipesListScreenController.recipesSection {
                    let numberOfItems = collectionView.numberOfItems(inSection: section)
                    if item == numberOfItems {
                        indexPath.item -= 1
                        deletedIndexPathsForDecorationView.append(indexPath)
                    } else {
                        deletedIndexPathsForDecorationView.append(indexPath)
                    }
                }
            default:
                break
            }
        }
    }

    override func indexPathsToDeleteForDecorationView(ofKind elementKind: String) -> [IndexPath] {
        return deletedIndexPathsForDecorationView
    }

    override func indexPathsToInsertForDecorationView(ofKind elementKind: String) -> [IndexPath] {
        return insertedIndexPathsForDecorationView
    }

    override func finalizeCollectionViewUpdates() {
        super.finalizeCollectionViewUpdates()
        deletedIndexPathsForDecorationView = []
        insertedIndexPathsForDecorationView = []
    }
    
}

private class SeparatorCollectionReusableView: AUICollectionReusableView {
    
    override func setup() {
        super.setup()
        backgroundColor = Colors.lightGray
    }
    
}
