//
//  RecipeInDetailsScreenView.swift
//  AckeeCookbookIOSTaskPresentation
//
//  Created by Ihor Myroniuk on 4/6/20.
//  Copyright © 2020 Ihor Myroniuk. All rights reserved.
//

import AUIKit

class RecipeDetailsScreenView: ScreenViewWithNavigationBar, UIScrollViewDelegate {
    
    // MARK: Subviews

    let titleLabel = UILabel()
    let deleteButton = AlphaHighlightButton()
    let updateButton = AlphaHighlightButton()
    let backButton = AlphaHighlightButton()
    let scrollView = UIScrollView()
    let refreshControl = UIRefreshControl()
    let pictureImageView = DarkenImageView()
    let nameLabel = UILabel()
    let scoreDurationView = ScoreDurationView()
    let infoLabel = UILabel()
    let ingredientsLabel = UILabel()
    private var ingredientsViews: [IngredientListItemView] = []
    let descriptionTitleLabel = UILabel()
    let descriptionLabel = UILabel()
    private let setScoreView = SetScoreView()
    var setScoreButtons: [UIButton] {
        return setScoreView.scoreView.starButtons
    }
    var setScoreLabel: UILabel {
        return setScoreView.label
    }
    
    // MARK: Setup
    
    override func setup() {
        super.setup()
        backgroundColor = .white
        insertSubview(scrollView, belowSubview: statusBarView)
        setupScrollView()
    }

    override func setupStatusBarView() {
        super.setupStatusBarView()
        statusBarView.backgroundColor = .white
    }

    override func setupNavigationBarView() {
        super.setupNavigationBarView()
        navigationBarView.backgroundColor = .clear
        navigationBarView.addSubview(backButton)
        setupBackButton()
        navigationBarView.addSubview(deleteButton)
        setupDeleteButton()
        navigationBarView.addSubview(updateButton)
        setupUpdateButton()
        navigationBarView.addSubview(titleLabel)
        setupTitleLabel()
    }

    private func setupBackButton() {
        backButton.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        backButton.setTitleColor(Colors.white, for: .normal)
        let image = Images.back
        backButton.setImage(image.withTintColor(Colors.white), for: .normal)
        backButton.setImage(image.withTintColor(Colors.white), for: .highlighted)
    }

    private func setupDeleteButton() {
        deleteButton.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        deleteButton.setTitleColor(Colors.white, for: .normal)
    }
    
    private func setupUpdateButton() {
        updateButton.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        updateButton.setTitleColor(Colors.white, for: .normal)
    }

    private func setupTitleLabel() {
        titleLabel.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        titleLabel.textColor = .black
        titleLabel.numberOfLines = 3
        titleLabel.lineBreakMode = .byTruncatingTail
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.textAlignment = .center
    }

    private func setupScrollView() {
        scrollView.alwaysBounceVertical = true
        if #available(iOS 11.0, *) {
            scrollView.contentInsetAdjustmentBehavior = .never
        }
        scrollView.addSubview(refreshControl)
        setupRefreshControl()
        scrollView.addSubview(pictureImageView)
        setupPictureImageView()
        scrollView.addSubview(scoreDurationView)
        scrollView.addSubview(nameLabel)
        setupNameLabel()
        scrollView.addSubview(infoLabel)
        setupInfoLabel()
        scrollView.addSubview(ingredientsLabel)
        setupSectionTitleLabel(ingredientsLabel)
        scrollView.addSubview(descriptionTitleLabel)
        setupSectionTitleLabel(descriptionTitleLabel)
        scrollView.addSubview(descriptionLabel)
        setupDescriptionLabel()
        scrollView.addSubview(setScoreView)
    }
    
    private func setupRefreshControl() {
        refreshControl.tintColor = .white
    }
    
    private func setupPictureImageView() {
        pictureImageView.contentMode = .scaleAspectFill
        pictureImageView.image = Images.ackeeRecipe
        pictureImageView.darkenAmount = 0.4
    }
    
    private func setupNameLabel() {
        nameLabel.textColor = Colors.white
        nameLabel.font = UIFont.systemFont(ofSize: 32, weight: .semibold)
        nameLabel.lineBreakMode = .byWordWrapping
        nameLabel.numberOfLines = 2
    }
    
    private func setupInfoLabel() {
        infoLabel.lineBreakMode = .byWordWrapping
        infoLabel.numberOfLines = 0
    }
    
    private func setupDescriptionLabel() {
        descriptionLabel.numberOfLines = 0
        descriptionLabel.lineBreakMode = .byWordWrapping
    }
    
    private func setupSectionTitleLabel(_ label: UILabel) {
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.textColor = Colors.blue
        label.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
    }
    
    // MARK: Layout
    
    override func setNeedsLayout() {
        scoreDurationView.setNeedsLayout()
        super.setNeedsLayout()
    }
    
    override func layoutIfNeeded() {
        scoreDurationView.layoutIfNeeded()
        super.layoutIfNeeded()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layoutBackButton()
        layoutDeleteButton()
        layoutUpdateButton()
        layoutTitleLabel()
        layoutScrollView()
        layoutScoreDurationView()
        layoutNameLabel()
        layoutPictureImageView()
        layoutInfoLabel()
        layoutIngredientsLabel()
        layoutIngredientsViews()
        layoutDescriptionTitleLabel()
        layoutDescriptionLabel()
        layoutSetScoreView()
        setScrollViewContentSize()
    }

    private func layoutBackButton() {
        let titleEdgeInsets = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: -5)
        backButton.titleEdgeInsets = titleEdgeInsets
        let contentEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 5)
        backButton.contentEdgeInsets = contentEdgeInsets
        let possibleHeight = navigationBarView.bounds.height
        let possibleWidth = navigationBarView.bounds.width / 4
        let possibleSize = CGSize(width: possibleWidth, height: possibleHeight)
        let size = backButton.sizeThatFits(possibleSize)
        let width: CGFloat = size.width
        let height: CGFloat = size.height
        let x: CGFloat = 8
        let y: CGFloat = (navigationBarView.bounds.height - height) / 2
        let frame = CGRect(x: x, y: y, width: width, height: height)
        backButton.frame = frame
    }

    private func layoutDeleteButton() {
        let possibleHeight = navigationBarView.bounds.height
        let possibleWidth = navigationBarView.bounds.width / 4
        let possibleSize = CGSize(width: possibleWidth, height: possibleHeight)
        let size = deleteButton.sizeThatFits(possibleSize)
        let width: CGFloat = size.width
        let height: CGFloat = size.height
        let x: CGFloat = navigationBarView.bounds.width - 8 - width
        let y: CGFloat = (navigationBarView.bounds.height - height) / 2
        let frame = CGRect(x: x, y: y, width: width, height: height)
        deleteButton.frame = frame
    }
    
    private func layoutUpdateButton() {
        let possibleHeight = navigationBarView.bounds.height
        let possibleWidth = navigationBarView.bounds.width / 4
        let possibleSize = CGSize(width: possibleWidth, height: possibleHeight)
        let size = updateButton.sizeThatFits(possibleSize)
        let width: CGFloat = size.width
        let height: CGFloat = size.height
        let x: CGFloat = deleteButton.frame.origin.x - 8 - width
        let y: CGFloat = (navigationBarView.bounds.height - height) / 2
        let frame = CGRect(x: x, y: y, width: width, height: height)
        updateButton.frame = frame
    }

    private func layoutTitleLabel() {
        let possibleWidth: CGFloat = navigationBarView.bounds.width - 2 * (navigationBarView.bounds.width - deleteButton.frame.origin.x + 8)
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
    
    func layoutPictureImageView() {
        let x: CGFloat = 0
        let scrollViewContentOffsetY = scrollView.contentOffset.y
        let y: CGFloat = scrollViewContentOffsetY < 0 ? scrollViewContentOffsetY : 0
        let width = scrollView.bounds.width
        let height = width - (scrollViewContentOffsetY < 0 ? scrollViewContentOffsetY : 0)
        let frame = CGRect(x: x, y: y, width: width, height: height)
        pictureImageView.frame = frame
        //pictureImageView.setNeedsLayout()
        pictureImageView.layoutIfNeeded()
    }
    
    private func layoutScoreDurationView() {
        let x = pictureImageView.frame.origin.x
        let y = pictureImageView.frame.width - 64
        let width = pictureImageView.bounds.width
        let height: CGFloat = 64
        let frame = CGRect(x: x, y: y, width: width, height: height)
        scoreDurationView.frame = frame
    }
    
    private func layoutNameLabel() {
        let x: CGFloat = 24
        let possibleHeight: CGFloat = CGFloat.greatestFiniteMagnitude
        let possibleWidth = scrollView.bounds.width - x * 2
        let possibleSize = CGSize(width: possibleWidth, height: possibleHeight)
        let size = nameLabel.sizeThatFits(possibleSize)
        let y: CGFloat = scoreDurationView.frame.origin.y - size.height - 24
        let origin = CGPoint(x: x, y: y)
        let frame = CGRect(origin: origin, size: size)
        nameLabel.frame = frame
    }

    private func layoutScrollView() {
        let x: CGFloat = 0
        let y: CGFloat = 0
        let width = bounds.size.width
        let height = bounds.height - y
        let frame = CGRect(x: x, y: y, width: width, height: height)
        scrollView.frame = frame
        let df = navigationBarView.bounds.height + statusBarView.bounds.height
        scrollView.scrollIndicatorInsets = UIEdgeInsets(top: navigationBarView.bounds.height, left: 0, bottom: 0, right: 0)
        refreshControl.bounds.origin.y = -df
    }
    
    private func layoutInfoLabel() {
        let x: CGFloat = 24
        let y: CGFloat = pictureImageView.frame.origin.y + pictureImageView.frame.size.height + 30
        let origin = CGPoint(x: x, y: y)
        let possibleHeight: CGFloat = CGFloat.greatestFiniteMagnitude
        let possibleWidth = scrollView.bounds.width - x * 2
        let possibleSize = CGSize(width: possibleWidth, height: possibleHeight)
        let size = infoLabel.sizeThatFits(possibleSize)
        let frame = CGRect(origin: origin, size: size)
        infoLabel.frame = frame
    }
    
    private func layoutIngredientsLabel() {
        let x: CGFloat = 24
        let y: CGFloat = infoLabel.frame.origin.y + infoLabel.frame.size.height + 30
        let origin = CGPoint(x: x, y: y)
        let possibleHeight: CGFloat = CGFloat.greatestFiniteMagnitude
        let possibleWidth = scrollView.bounds.width - x * 2
        let possibleSize = CGSize(width: possibleWidth, height: possibleHeight)
        let size = ingredientsLabel.sizeThatFits(possibleSize)
        let frame = CGRect(origin: origin, size: size)
        ingredientsLabel.frame = frame
    }
    
    private func layoutIngredientsViews() {
        let x: CGFloat = 32
        var y: CGFloat = ingredientsLabel.frame.origin.y + ingredientsLabel.frame.size.height + 15
        let width = scrollView.bounds.width - 36 - 24
        for ingredientInputView in ingredientsViews {
            let origin = CGPoint(x: x, y: y)
            let possibleHeight: CGFloat = CGFloat.greatestFiniteMagnitude
            let possibleSize = CGSize(width: width, height: possibleHeight)
            let sizeThatFits = ingredientInputView.sizeThatFits(possibleSize)
            let frame = CGRect(origin: origin, size: sizeThatFits)
            ingredientInputView.frame = frame
            y += sizeThatFits.height
        }
    }
    
    private func layoutDescriptionTitleLabel() {
        let x: CGFloat = 24
        let previousView = ingredientsViews.last ?? ingredientsLabel
        let y: CGFloat = previousView.frame.origin.y + previousView.frame.size.height + 30
        let origin = CGPoint(x: x, y: y)
        let possibleHeight: CGFloat = CGFloat.greatestFiniteMagnitude
        let possibleWidth = scrollView.bounds.width - x * 2
        let possibleSize = CGSize(width: possibleWidth, height: possibleHeight)
        let size = descriptionTitleLabel.sizeThatFits(possibleSize)
        let frame = CGRect(origin: origin, size: size)
        descriptionTitleLabel.frame = frame
    }
    
    private func layoutDescriptionLabel() {
        let x: CGFloat = 24
        let y: CGFloat = descriptionTitleLabel.frame.origin.y + descriptionTitleLabel.frame.size.height + 15
        let origin = CGPoint(x: x, y: y)
        let possibleHeight: CGFloat = CGFloat.greatestFiniteMagnitude
        let possibleWidth = scrollView.bounds.width - x * 2
        let possibleSize = CGSize(width: possibleWidth, height: possibleHeight)
        let size = descriptionLabel.sizeThatFits(possibleSize)
        let frame = CGRect(origin: origin, size: size)
        descriptionLabel.frame = frame
    }
    
    private func layoutSetScoreView() {
        setScoreView.scoreView.starImageViewsWidthHeight = (bounds.width - 96) / 5
        setScoreView.scoreView.starImageViewsSpace = 0
        let x: CGFloat = 0
        let y: CGFloat = descriptionLabel.frame.origin.y + descriptionLabel.frame.size.height + 30
        let origin = CGPoint(x: x, y: y)
        let possibleHeight: CGFloat = CGFloat.greatestFiniteMagnitude
        let possibleWidth = scrollView.bounds.width
        let possibleSize = CGSize(width: possibleWidth, height: possibleHeight)
        let size = setScoreView.sizeThatFits(possibleSize)
        let frame = CGRect(origin: origin, size: size)
        setScoreView.frame = frame
    }
    
    private func setScrollViewContentSize() {
        let width = scrollView.frame.size.width
        let height: CGFloat = setScoreView.frame.origin.y + setScoreView.frame.size.height
        let size = CGSize(width: width, height: height)
        scrollView.contentSize = size
    }
    
    // MARK: Setters
    
    func setIngredients(_ ingredients: [String]) {
        ingredientsViews.forEach({ $0.removeFromSuperview() })
        ingredientsViews = []
        for ingredient in ingredients {
            let view = IngredientListItemView()
            view.label.text = ingredient
            scrollView.addSubview(view)
            ingredientsViews.append(view)
        }
    }
    
    func setScore(_ score: Float) {
        scoreDurationView.scoreView.setScore(score)
        layoutScoreDurationView()
        setScoreView.scoreView.setSelectedScore(score)
    }
    
    func setDuration(_ duration: String?) {
        scoreDurationView.durationLabel.text = duration
    }
    
    func beginSetScoreActivity() {
        setScoreView.activityIndicatorView.startAnimating()
    }
    
    func endSetScoreActivity() {
        setScoreView.activityIndicatorView.stopAnimating()
    }
    
}

private class IngredientListItemView: AUIView {
    
    // MARK: Subviews
    
    private let bulletView = UIView()
    let label = UILabel()
    
    // MARK: Setup
    
    override func setup() {
        super.setup()
        addSubview(bulletView)
        setupBulletView()
        addSubview(label)
        setupLabel()
    }
    
    private func setupBulletView() {
        bulletView.backgroundColor = .black
    }
    
    private func setupLabel() {
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
    }
    
    // MARK: Layout
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layoutBulletView()
        layoutLabel()
    }
    
    private func layoutBulletView() {
        let x: CGFloat = 9
        let y: CGFloat = 8
        let width: CGFloat = 4
        let height = width
        let frame = CGRect(x: x, y: y, width: width, height: height)
        bulletView.frame = frame
        bulletView.layer.cornerRadius = 2
        bulletView.layer.masksToBounds = true
    }
    
    private func layoutLabel() {
        let x: CGFloat = 30
        let y: CGFloat = 0
        let origin = CGPoint(x: x, y: y)
        let possibleHeight: CGFloat = CGFloat.greatestFiniteMagnitude
        let possibleWidth = bounds.width - x
        let possibleSize = CGSize(width: possibleWidth, height: possibleHeight)
        let size = label.sizeThatFits(possibleSize)
        let frame = CGRect(origin: origin, size: size)
        label.frame = frame
    }
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        let x: CGFloat = 30
        let possibleHeight: CGFloat = CGFloat.greatestFiniteMagnitude
        let possibleWidth = size.width - x
        let possibleSize = CGSize(width: possibleWidth, height: possibleHeight)
        var labelSize = label.sizeThatFits(possibleSize)
        labelSize.width = size.width
        return labelSize
    }
}

class ScoreDurationView: AUIView {
    
    // MARK: Subviews
    
    let scoreView = ScoreStarsView()
    let durationImageView = UIImageView()
    let durationLabel = UILabel()
    
    // MARK: Setup
    
    override func setup() {
        super.setup()
        backgroundColor = Colors.red
        addSubview(scoreView)
        scoreView.starImageTintColor = .white
        addSubview(durationImageView)
        setupDurationImageView()
        addSubview(durationLabel)
        durationLabel.textColor = .white
    }
    
    private func setupDurationImageView() {
        durationImageView.contentMode = .scaleAspectFit
        durationImageView.image = Images.clock.withTintColor(.white)
    }
    
    // MARK: Layout
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layoutDurationLabel()
        layoutDurationImageView()
        layoutScoreView()
    }
    
    private func layoutDurationLabel() {
        let availableHeight = bounds.height
        let availableWidth = bounds.width
        let availableSize = CGSize(width: availableWidth, height: availableHeight)
        let sizeThatFits = durationLabel.sizeThatFits(availableSize)
        let x = bounds.width - sizeThatFits.width - 24
        let y = (bounds.height - sizeThatFits.height) / 2
        let origin = CGPoint(x: x, y: y)
        let frame = CGRect(origin: origin, size: sizeThatFits)
        durationLabel.frame = frame
    }
    
    private func layoutDurationImageView() {
        let width: CGFloat = 16
        let height = width
        let x = durationLabel.frame.origin.x - width - 6
        let y = (bounds.height - height) / 2
        let frame = CGRect(x: x, y: y, width: width, height: height)
        durationImageView.frame = frame
    }
    
    private func layoutScoreView() {
        scoreView.starImageViewsWidthHeight = bounds.height * 0.4
        scoreView.starImageViewsSpace = 6
        let x: CGFloat = 24
        let y = (bounds.height - scoreView.starImageViewsWidthHeight) / 2
        let availableHeight = bounds.height * 0.4
        let availableWidth = bounds.width - x
        let availableSize = CGSize(width: availableWidth, height: availableHeight)
        let sizeThatFits = scoreView.sizeThatFits(availableSize)
        let origin = CGPoint(x: x, y: y)
        let frame = CGRect(origin: origin, size: sizeThatFits)
        scoreView.frame = frame
    }
    
}

private class SetScoreView: AUIView {
    
    // MARK: Subviews
    
    let label = UILabel()
    let scoreView = InteractiveScoreFiveStarsView()
    let activityIndicatorView = UIActivityIndicatorView()
    
    // MARK: Setup
    
    override func setup() {
        super.setup()
        backgroundColor = Colors.blue
        addSubview(label)
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.textColor = Colors.white
        label.textAlignment = .center
        addSubview(scoreView)
        scoreView.starImageTintColor = .white
        addSubview(activityIndicatorView)
        activityIndicatorView.color = Colors.white
        activityIndicatorView.backgroundColor = UIColor.black.withAlphaComponent(0.4)
    }
    
    // MARK: Layout
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layoutLabel()
        layoutScoreView()
        layoutActivityIndicatorView()
    }
    
    private func layoutLabel() {
        let possibleWidth: CGFloat = bounds.width - 2 * 24
        let possibleHeight: CGFloat = bounds.height
        let possibleSize = CGSize(width: possibleWidth, height: possibleHeight)
        let size = label.sizeThatFits(possibleSize)
        let x: CGFloat = (bounds.width - size.width) / 2
        let y: CGFloat = 24
        let origin = CGPoint(x: x, y: y)
        let frame = CGRect(origin: origin, size: size)
        label.frame = frame
    }
    
    private func layoutScoreView() {
        let possibleWidth: CGFloat = bounds.width - 2 * 24
        let possibleHeight: CGFloat = bounds.height
        let possibleSize = CGSize(width: possibleWidth, height: possibleHeight)
        let size = scoreView.sizeThatFits(possibleSize)
        let x: CGFloat = (bounds.width - size.width) / 2
        let y: CGFloat = label.frame.origin.y + label.frame.height + 8
        let origin = CGPoint(x: x, y: y)
        let frame = CGRect(origin: origin, size: size)
        scoreView.frame = frame
    }
    
    private func layoutActivityIndicatorView() {
        activityIndicatorView.frame = bounds
    }
    
    // MARK: Size
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        let possibleWidth: CGFloat = bounds.width - 2 * 24
        let possibleHeight: CGFloat = bounds.height
        let possibleSize = CGSize(width: possibleWidth, height: possibleHeight)
        let labelSize = label.sizeThatFits(possibleSize)
        let scoreViewSize = scoreView.sizeThatFits(possibleSize)
        let size = CGSize(width: size.width, height: labelSize.height + scoreViewSize.height + 24 + 24 + 8)
        return size
    }

}

private class InteractiveScoreFiveStarsView: AUIView {

    // MARK: Subviews

    var starButtons: [UIButton] = []

    // MARK: Star

    var starImageTintColor: UIColor = Colors.red {
        didSet {
            for button in starButtons {
                button.setImage(Images.star.withTintColor(starImageTintColor), for: .normal)
            }
        }
    }
    private var starButton: UIButton {
        let button = UIButton()
        button.contentMode = .scaleAspectFit
        button.setImage(Images.star.withTintColor(starImageTintColor), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.contentVerticalAlignment = .fill
        button.contentHorizontalAlignment = .fill
        return button
    }
    
    override func setup() {
        super.setup()
        for _ in 1...5 {
            let button = starButton
            addSubview(button)
            starButtons.append(button)
        }
    }

    // MARK: Value

    func setSelectedScore(_ score: Float) {
        let count = Int(score.rounded(.toNearestOrAwayFromZero))
        for i in 0..<starButtons.count {
            if i < count {
                starButtons[i].alpha = 1
            } else {
                starButtons[i].alpha = 0.4
            }
        }
    }

    // MARK: Layout Subviews

    var starImageViewsSpace: CGFloat = 2
    var starImageViewsWidthHeight: CGFloat = 12
    override func layoutSubviews() {
        super.layoutSubviews()
        layoutStarImageViews()
    }

    private func layoutStarImageViews() {
        var x: CGFloat = 0
        let y: CGFloat = 0
        let widthHeight = starImageViewsWidthHeight
        let size = CGSize(width: widthHeight, height: widthHeight)
        for starImageView in starButtons {
            let origin = CGPoint(x: x, y: y)
            let frame = CGRect(origin: origin, size: size)
            starImageView.frame = frame
            x += widthHeight + starImageViewsSpace
        }
    }

    // MARK: Size

    override func sizeThatFits(_ size: CGSize) -> CGSize {
        let height = starImageViewsWidthHeight
        var width = ((starImageViewsWidthHeight + starImageViewsSpace) * CGFloat(starButtons.count)) - starImageViewsSpace
        if width < 0 { width = 0 }
        let sizeThatFits = CGSize(width: width, height: height)
        return sizeThatFits
    }
}

