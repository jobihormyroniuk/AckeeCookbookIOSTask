//
//  AddRecipeScreenView.swift
//  AckeeCookbookIOSTaskPresentation
//
//  Created by Ihor Myroniuk on 3/31/20.
//  Copyright © 2020 Ihor Myroniuk. All rights reserved.
//

import AUIKit

class AddRecipeScreenView: ScreenViewWithNavigationBar {

    // MARK: Subview

    let titleLabel = UILabel()
    let addButton = AlphaHighlightButton()
    let backButton = AlphaHighlightButton()
    let scrollView = UIScrollView()
    let nameTextInputView = TextViewInputView()
    let infoTextInputView = TextViewInputView()
    let ingredientsLabel = UILabel()
    private var ingredientInputViews: [IngredientInputView] = []
    let addIngredientButton = AlphaHighlightButton()
    let descriptionInputView = TextViewInputView()
    let durationInputView = DurationInputView()

    // MARK: Setup

    override func setup() {
        super.setup()
        backgroundColor = .white
        addSubview(scrollView)
        setupScrollView()
    }

    override func setupStatusBarView() {
        super.setupStatusBarView()
        statusBarView.backgroundColor = .white
    }

    override func setupNavigationBarView() {
        super.setupNavigationBarView()
        navigationBarView.backgroundColor = .white
        navigationBarView.addSubview(backButton)
        setupBackButton()
        navigationBarView.addSubview(addButton)
        setupAddButton()
        navigationBarView.addSubview(titleLabel)
        setupTitleLabel()
    }

    private func setupBackButton() {
        backButton.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        backButton.setTitleColor(Colors.blue, for: .normal)
        let image = Images.back
        backButton.setImage(image.withTintColor(Colors.blue), for: .normal)
        backButton.setImage(image.withTintColor(Colors.blue), for: .highlighted)
    }

    private func setupAddButton() {
        addButton.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        addButton.setTitleColor(Colors.blue, for: .normal)
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
        scrollView.addSubview(nameTextInputView)
        scrollView.addSubview(infoTextInputView)
        scrollView.addSubview(ingredientsLabel)
        setupIngredientsLabel()
        scrollView.addSubview(addIngredientButton)
        setupAddIngredientButton()
        scrollView.addSubview(descriptionInputView)
        scrollView.addSubview(durationInputView)
    }

    private func setupIngredientsLabel() {
        ingredientsLabel.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        ingredientsLabel.textColor = Colors.blue
    }

    private func setupAddIngredientButton() {
        addIngredientButton.layer.borderColor = Colors.red.cgColor
        addIngredientButton.setTitleColor(Colors.red, for: .normal)
        addIngredientButton.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        let image = Images.plus
        addIngredientButton.setImage(image.withTintColor(Colors.red), for: .normal)
        addIngredientButton.setImage(image.withTintColor(Colors.red), for: .highlighted)
    }

    // MARK: Layout

    override func layoutSubviews() {
        super.layoutSubviews()
        layoutBackButton()
        layoutAddButton()
        layoutTitleLabel()
        layoutScrollView()
        layoutNameTextInput()
        layoutInfoTextInput()
        layoutIngredientsLabel()
        layoutIngredientInputViews()
        layoutAddIngredientButton()
        layoutDescriptionTextInput()
        layoutDurationInputView()
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

    private func layoutAddButton() {
        let possibleHeight = navigationBarView.bounds.height
        let possibleWidth = navigationBarView.bounds.width / 4
        let possibleSize = CGSize(width: possibleWidth, height: possibleHeight)
        let size = addButton.sizeThatFits(possibleSize)
        let width: CGFloat = size.width
        let height: CGFloat = size.height
        let x: CGFloat = navigationBarView.bounds.width - 8 - width
        let y: CGFloat = (navigationBarView.bounds.height - height) / 2
        let frame = CGRect(x: x, y: y, width: width, height: height)
        addButton.frame = frame
    }

    private func layoutTitleLabel() {
        let possibleWidth: CGFloat = navigationBarView.bounds.width - 2 * (navigationBarView.bounds.width - addButton.frame.origin.x + 8)
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

    private func layoutScrollView() {
        let x: CGFloat = 0
        let y = navigationBarView.frame.origin.y + navigationBarView.frame.height
        let width = bounds.size.width
        let height = bounds.height - y
        let frame = CGRect(x: x, y: y, width: width, height: height)
        scrollView.frame = frame
    }

    private func layoutNameTextInput() {
        let x: CGFloat = 24
        let y: CGFloat = 30
        let origin = CGPoint(x: x, y: y)
        let possibleHeight: CGFloat = CGFloat.greatestFiniteMagnitude
        let possibleWidth = scrollView.bounds.width - x * 2
        let possibleSize = CGSize(width: possibleWidth, height: possibleHeight)
        let size = nameTextInputView.sizeThatFits(possibleSize)
        let frame = CGRect(origin: origin, size: size)
        nameTextInputView.frame = frame
        nameTextInputView.setNeedsLayout()
        nameTextInputView.layoutIfNeeded()
    }

    private func layoutInfoTextInput() {
        let x: CGFloat = 24
        let y: CGFloat = nameTextInputView.frame.origin.y + nameTextInputView.frame.size.height + 30
        let origin = CGPoint(x: x, y: y)
        let possibleHeight: CGFloat = CGFloat.greatestFiniteMagnitude
        let possibleWidth = scrollView.bounds.width - x * 2
        let possibleSize = CGSize(width: possibleWidth, height: possibleHeight)
        let size = infoTextInputView.sizeThatFits(possibleSize)
        let frame = CGRect(origin: origin, size: size)
        infoTextInputView.frame = frame
        infoTextInputView.setNeedsLayout()
        infoTextInputView.layoutIfNeeded()
    }

    private func layoutIngredientsLabel() {
        let x: CGFloat = 24
        let y: CGFloat = infoTextInputView.frame.origin.y + infoTextInputView.frame.size.height + 30
        let origin = CGPoint(x: x, y: y)
        let possibleHeight: CGFloat = CGFloat.greatestFiniteMagnitude
        let possibleWidth = scrollView.bounds.width - x * 2
        let possibleSize = CGSize(width: possibleWidth, height: possibleHeight)
        let size = ingredientsLabel.sizeThatFits(possibleSize)
        let frame = CGRect(origin: origin, size: size)
        ingredientsLabel.frame = frame
    }

    private func layoutIngredientInputViews() {
        let x: CGFloat = 24
        var y: CGFloat = ingredientsLabel.frame.origin.y + ingredientsLabel.frame.size.height
        let width = scrollView.bounds.width - x * 2
        for ingredientInputView in ingredientInputViews {
            let origin = CGPoint(x: x, y: y)
            let possibleHeight: CGFloat = CGFloat.greatestFiniteMagnitude
            let possibleSize = CGSize(width: width, height: possibleHeight)
            let sizeThatFits = ingredientInputView.sizeThatFits(possibleSize)
            let frame = CGRect(origin: origin, size: sizeThatFits)
            ingredientInputView.frame = frame
            y += sizeThatFits.height
        }
    }

    private func layoutAddIngredientButton() {
        let titleEdgeInsets = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: -5)
        addIngredientButton.titleEdgeInsets = titleEdgeInsets
        let contentEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 10)
        addIngredientButton.contentEdgeInsets = contentEdgeInsets
        addIngredientButton.layer.cornerRadius = 6
        addIngredientButton.layer.borderWidth = 2
        let x: CGFloat = 24
        let upperView = ingredientInputViews.last ?? ingredientsLabel
        let y: CGFloat = upperView.frame.origin.y + upperView.frame.size.height + 16
        let origin = CGPoint(x: x, y: y)
        let possibleHeight: CGFloat = CGFloat.greatestFiniteMagnitude
        let possibleWidth = scrollView.bounds.width - x * 2
        let possibleSize = CGSize(width: possibleWidth, height: possibleHeight)
        let size = addIngredientButton.sizeThatFits(possibleSize)
        let frame = CGRect(origin: origin, size: size)
        addIngredientButton.frame = frame
    }

    private func layoutDescriptionTextInput() {
        let x: CGFloat = 24
        let y: CGFloat = addIngredientButton.frame.origin.y + addIngredientButton.frame.size.height + 30
        let origin = CGPoint(x: x, y: y)
        let possibleHeight: CGFloat = CGFloat.greatestFiniteMagnitude
        let possibleWidth = scrollView.bounds.width - x * 2
        let possibleSize = CGSize(width: possibleWidth, height: possibleHeight)
        let size = descriptionInputView.sizeThatFits(possibleSize)
        let frame = CGRect(origin: origin, size: size)
        descriptionInputView.frame = frame
        descriptionInputView.setNeedsLayout()
        descriptionInputView.layoutIfNeeded()
    }
    
    private func layoutDurationInputView() {
        let x: CGFloat = 24
        let y: CGFloat = descriptionInputView.frame.origin.y + descriptionInputView.frame.size.height + 30
        let origin = CGPoint(x: x, y: y)
        let possibleHeight: CGFloat = CGFloat.greatestFiniteMagnitude
        let possibleWidth = scrollView.bounds.width - x * 2
        let possibleSize = CGSize(width: possibleWidth, height: possibleHeight)
        let size = durationInputView.sizeThatFits(possibleSize)
        let frame = CGRect(origin: origin, size: size)
        durationInputView.frame = frame
        durationInputView.setNeedsLayout()
        durationInputView.layoutIfNeeded()
    }

    private func setScrollViewContentSize() {
        let width = scrollView.frame.size.width
        let height = durationInputView.frame.origin.y + durationInputView.frame.height + 30
        let size = CGSize(width: width, height: height)
        scrollView.contentSize = size
    }

    // MARK:

    func addIngredientInputView() -> IngredientInputView {
        let ingredientInputView = IngredientInputView()
        ingredientInputViews.append(ingredientInputView)
        scrollView.addSubview(ingredientInputView)
        setNeedsLayout()
        layoutIfNeeded()
        return ingredientInputView
    }

}

class DurationInputView: AUIView {
    
    // MARK: Subviews

    let titleLabel = UILabel()
    let textField = UITextView()
    private let dataPicker = UIDatePicker();
    private let underlineLayer = CALayer()

    // MARK: Setup

    override func setup() {
        super.setup()
        addSubview(titleLabel)
        setupTitleLabel()
        addSubview(textField)
        setupTextView()
        layer.addSublayer(underlineLayer)
        setupUnderlineLayer()
    }

    private func setupTitleLabel() {
        titleLabel.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
    }

    private func setupTextView() {
        textField.font = UIFont.systemFont(ofSize: 16)
        textField.tintColor = UIColor.clear
        textField.textColor = Colors.gray
        textField.textAlignment = .right
        textField.inputView = dataPicker
        textField.isScrollEnabled = false
        textField.alwaysBounceVertical = false
        textField.bounces = false
        textField.textContainer.lineFragmentPadding = 0
    }

    private func setupUnderlineLayer() {
        underlineLayer.backgroundColor = UIColor.lightGray.withAlphaComponent(0.5).cgColor
    }

    // MARK: Layout

    override func layoutSubviews() {
        super.layoutSubviews()
        layoutTitleLabel()
        layoutTextView()
        layoutUnderlineLayer()
    }

    private func layoutTitleLabel() {
        let origin = CGPoint.zero
        let possibleWidth: CGFloat = bounds.width
        let possibleHeight = CGFloat.greatestFiniteMagnitude
        let possibleSize = CGSize(width: possibleWidth, height: possibleHeight)
        let size = titleLabel.sizeThatFits(possibleSize)
        let frame = CGRect(origin: origin, size: size)
        titleLabel.frame = frame
    }

    private func layoutTextView() {
        let x: CGFloat = titleLabel.frame.size.width + 8
        let y: CGFloat = 0
        let origin = CGPoint(x: x, y: y)
        let possibleWidth: CGFloat = bounds.width - titleLabel.bounds.width - 8
        let possibleHeight = CGFloat.greatestFiniteMagnitude
        let possibleSize = CGSize(width: possibleWidth, height: possibleHeight)
        var size = textField.sizeThatFits(possibleSize)
        size.width = possibleWidth
        let frame = CGRect(origin: origin, size: size)
        textField.frame = frame
        titleLabel.frame.origin.y = (size.height - titleLabel.bounds.height) / 2
    }

    private func layoutUnderlineLayer() {
        let x: CGFloat = 0
        let y: CGFloat = textField.frame.origin.y + textField.frame.size.height
        let width = bounds.width
        let height: CGFloat = 1
        let frame = CGRect(x: x, y: y, width: width, height: height)
        underlineLayer.frame = frame
    }

    // MARK: Size

    override func sizeThatFits(_ size: CGSize) -> CGSize {
        let textViewSize = textField.sizeThatFits(size)
        let sizeThatFits = CGSize(width: size.width, height: textViewSize.height + 1)
        return sizeThatFits
    }
    
}
