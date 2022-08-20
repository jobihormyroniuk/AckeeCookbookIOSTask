//
//  RecipesListScreenView.swift
//  AckeeCookbookIOSTaskPresentation
//
//  Created by Ihor Myroniuk on 3/25/20.
//  Copyright © 2020 Ihor Myroniuk. All rights reserved.
//

import AUIKit

class RecipesListScreenView: ScreenViewWithNavigationBar {

    // MARK: Elements

    let titleLabel = UILabel()
    let addRecipeButton = AlphaHighlightButton()
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: RecipesListScreenCollectionViewLayout())
    let refreshControl = UIRefreshControl()

    // MARK: Setup

    override func setup() {
        super.setup()
        backgroundColor = .white
        addSubview(collectionView)
        setupCollectionView()
    }

    override func setupStatusBarView() {
        super.setupStatusBarView()
        statusBarView.backgroundColor = .white
    }

    override func setupNavigationBarView() {
        super.setupNavigationBarView()
        navigationBarView.backgroundColor = .white
        navigationBarView.addSubview(titleLabel)
        setupTitleLabel()
        navigationBarView.addSubview(addRecipeButton)
        setupAddRecipeButton()
    }

    private func setupTitleLabel() {
        titleLabel.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        titleLabel.textColor = .black
        titleLabel.numberOfLines = 0
        titleLabel.lineBreakMode = .byTruncatingTail
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.textAlignment = .center
    }

    private func setupAddRecipeButton() {
        let image = Images.plusInCircle
        addRecipeButton.setImage(image.withTintColor(Colors.blue), for: .normal)
        addRecipeButton.setImage(image.withTintColor(Colors.blue), for: .highlighted)
    }

    private let recipeCollectionViewCellIdentifier = "recipeCollectionViewCellIdentifier"
    private let loadingCollectionViewCellIdentifier = "loadingCollectionViewCellIdentifier"
    private let repeatLoadCollectionViewCellIdentifier = "repeatLoadCollectionViewCellIdentifier"
    private func setupCollectionView() {
        collectionView.alwaysBounceVertical = true
        if #available(iOS 11.0, *) {
            collectionView.contentInsetAdjustmentBehavior = .never
        }
        collectionView.backgroundColor = .white
        collectionView.register(RecipesListScreenRecipeCollectionViewCell.self, forCellWithReuseIdentifier: recipeCollectionViewCellIdentifier)
        collectionView.register(RecipesListScreenLoadingCollectionViewCell.self, forCellWithReuseIdentifier: loadingCollectionViewCellIdentifier)
        collectionView.register(RecipesListScreenRepeatLoadCollectionViewCell.self, forCellWithReuseIdentifier: repeatLoadCollectionViewCellIdentifier)
        collectionView.addSubview(refreshControl)
    }

    // MARK: Layout

    override func layoutSubviews() {
        super.layoutSubviews()
        layoutAddRecipeButton()
        layoutTitleLabel()
        layoutCollectionView()
    }

    private func layoutAddRecipeButton() {
        let width: CGFloat = 32
        let height: CGFloat = 32
        let x: CGFloat = navigationBarView.bounds.width - 8 - width
        let y: CGFloat = (navigationBarView.bounds.height - height) / 2
        let frame = CGRect(x: x, y: y, width: width, height: height)
        addRecipeButton.frame = frame
    }

    private func layoutTitleLabel() {
        let possibleWidth: CGFloat = navigationBarView.bounds.width - 2 * (navigationBarView.bounds.width - addRecipeButton.frame.origin.x + 8)
        let possibleHeight: CGFloat = navigationBarView.bounds.height
        let possibleSize = CGSize(width: possibleWidth, height: possibleHeight)
        var size = titleLabel.sizeThatFits(possibleSize)
        if size.height > possibleHeight {
            size.height = possibleHeight
        }
        let x: CGFloat = (navigationBarView.bounds.width - size.width) / 2
        let y: CGFloat = (navigationBarView.bounds.height - size.height) / 2
        let origin = CGPoint(x: x, y: y)
        let frame = CGRect(origin: origin, size: size)
        titleLabel.frame = frame
    }

    private func layoutCollectionView() {
        let x: CGFloat = 0
        let y = navigationBarView.frame.origin.y + navigationBarView.frame.height
        let width = bounds.size.width
        let height = bounds.height - y
        let frame = CGRect(x: x, y: y, width: width, height: height)
        collectionView.frame = frame
    }

    // MARK: Cells

    func recipeCollectionViewCell(_ indexPath: IndexPath) -> RecipesListScreenRecipeCollectionViewCell! {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: recipeCollectionViewCellIdentifier, for: indexPath) as? RecipesListScreenRecipeCollectionViewCell
        return cell
    }
    
    func loadingCollectionViewCell(_ indexPath: IndexPath) -> RecipesListScreenLoadingCollectionViewCell! {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: loadingCollectionViewCellIdentifier, for: indexPath) as? RecipesListScreenLoadingCollectionViewCell
        return cell
    }
    
    func repeatLoadCollectionViewCell(_ indexPath: IndexPath) -> RecipesListScreenRepeatLoadCollectionViewCell! {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: repeatLoadCollectionViewCellIdentifier, for: indexPath) as? RecipesListScreenRepeatLoadCollectionViewCell
        return cell
    }

}
