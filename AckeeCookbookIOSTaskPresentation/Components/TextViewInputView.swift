//
//  TextViewInputView.swift
//  AckeeCookbookIOSTaskPresentation
//
//  Created by Ihor Myroniuk on 4/2/20.
//  Copyright © 2020 Ihor Myroniuk. All rights reserved.
//

import AUIKit

class TextViewInputView: AUIView, AUITextViewTextInputView {

    // MARK: Subviews

    let titleLabel = UILabel()
    let textView = UITextView()
    private let underlineLayer = CALayer()

    // MARK: Setup

    override func setup() {
        super.setup()
        addSubview(titleLabel)
        setupTitleLabel()
        addSubview(textView)
        setupTextView()
        layer.addSublayer(underlineLayer)
        setupUnderlineLayer()
    }

    private func setupTitleLabel() {
        titleLabel.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        titleLabel.textColor = Colors.blue
    }

    private func setupTextView() {
        textView.isScrollEnabled = false
        textView.alwaysBounceVertical = false
        textView.bounces = false
        textView.font = UIFont.systemFont(ofSize: 16)
        textView.tintColor = Colors.blue
        textView.textContainer.lineFragmentPadding = 0
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
        let x: CGFloat = 0
        let y: CGFloat = titleLabel.frame.origin.y + titleLabel.frame.size.height
        let origin = CGPoint(x: x, y: y)
        let possibleWidth: CGFloat = bounds.width
        let possibleHeight = CGFloat.greatestFiniteMagnitude
        let possibleSize = CGSize(width: possibleWidth, height: possibleHeight)
        var size = textView.sizeThatFits(possibleSize)
        size.width = possibleWidth
        let frame = CGRect(origin: origin, size: size)
        textView.frame = frame
    }

    private func layoutUnderlineLayer() {
        let x: CGFloat = textView.frame.origin.x
        let y: CGFloat = textView.frame.origin.y + textView.frame.size.height
        let width = textView.frame.width
        let height: CGFloat = 1
        let frame = CGRect(x: x, y: y, width: width, height: height)
        underlineLayer.frame = frame
    }

    // MARK: Size

    override func sizeThatFits(_ size: CGSize) -> CGSize {
        let titleLabelsize = titleLabel.sizeThatFits(size)
        let textViewSize = textView.sizeThatFits(size)
        let sizeThatFits = CGSize(width: size.width, height: titleLabelsize.height + textViewSize.height + 1)
        return sizeThatFits
    }

}

class IngredientInputView: AUIView, AUITextViewTextInputView, AUIResponsiveTextInputView {

    // MARK: Elements

    let placeholderLabel = UILabel()
    let textView = UITextView()
    let underlineLayer = CALayer()

    // MARK: Setup

    override func setup() {
        super.setup()
        addSubview(textView)
        setupTextView()
        layer.addSublayer(underlineLayer)
        setupUnderlineLayer()
        addSubview(placeholderLabel)
        setupPlaceholderLabel()
    }

    private func setupTextView() {
        textView.isScrollEnabled = false
        textView.alwaysBounceVertical = false
        textView.bounces = false
        textView.font = UIFont.systemFont(ofSize: 16)
        textView.tintColor = Colors.blue
        textView.textContainer.lineFragmentPadding = 0
    }

    private func setupUnderlineLayer() {
        underlineLayer.backgroundColor = UIColor.lightGray.withAlphaComponent(0.5).cgColor
    }

    private func setupPlaceholderLabel() {
        placeholderLabel.textColor = UIColor.lightGray.withAlphaComponent(0.5)
        placeholderLabel.font = UIFont.systemFont(ofSize: 16)
    }

    // MARK: Layout

    override func layoutSubviews() {
        super.layoutSubviews()
        layoutTextView()
        layoutUnderlineLayer()
        layoutPlaceholderLabel()
    }

    private func layoutTextView() {
        let x: CGFloat = 0
        let y: CGFloat = 0
        let origin = CGPoint(x: x, y: y)
        var size = textView.sizeThatFits(bounds.size)
        size.width = bounds.width
        let frame = CGRect(origin: origin, size: size)
        textView.frame = frame
    }

    private func layoutUnderlineLayer() {
        let x: CGFloat = 0
        let y = textView.frame.height
        let width = textView.frame.width
        let height = underlineLayerHeight
        let frame = CGRect(x: x, y: y, width: width, height: height)
        underlineLayer.frame = frame
    }

    private func layoutPlaceholderLabel() {
        let frame = textView.frame
        placeholderLabel.frame = frame
    }

    // MARK: Size

    private let underlineLayerHeight: CGFloat = 1
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        let width: CGFloat = size.width
        let textViewSize = textView.sizeThatFits(size)
        let height: CGFloat = textViewSize.height + underlineLayerHeight
        let sizeThatFits = CGSize(width: width, height: height)
        return sizeThatFits
    }

    // MARK: AUIResponsiveTextInputView
    
    func responsiveTextInputViewDidBeginEditingEmpty(animated: Bool) {
        placeholderLabel.isHidden = false
    }

    func responsiveTextInputViewDidBeginEditingNonempty(animated: Bool) {
        placeholderLabel.isHidden = true
    }

    func responsiveTextInputViewDidBecomeEmpty(animated: Bool) {
        placeholderLabel.isHidden = false
    }

    func responsiveTextInputViewDidBecomeNonEmpty(animated: Bool) {
        placeholderLabel.isHidden = true
    }

    func responsiveTextInputViewDidEndEditingEmpty(animated: Bool) {
        placeholderLabel.isHidden = false
    }

    func responsiveTextInputViewDidEndEditingNonempty(animated: Bool) {
        placeholderLabel.isHidden = true
    }

}
