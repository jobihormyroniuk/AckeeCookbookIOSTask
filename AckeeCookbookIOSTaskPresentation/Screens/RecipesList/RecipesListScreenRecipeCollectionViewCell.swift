//
//  RecipeListItemCollectionViewCell.swift
//  AckeeCookbookIOSTaskPresentation
//
//  Created by Ihor Myroniuk on 4/2/20.
//  Copyright © 2020 Ihor Myroniuk. All rights reserved.
//

import AUIKit

class RecipesListScreenRecipeCollectionViewCell: AUICollectionViewCell {

    // MARK: Subviews

    private let pictureImageView = UIImageView()
    let nameLabel = UILabel()
    let scoreView = ScoreStarsView()
    private let durationImageView = UIImageView()
    let durationLabel = UILabel()

    // MARK: Setup
    
    override func setup() {
        super.setup()
        contentView.clipsToBounds = true
        contentView.layer.cornerRadius = 4
        contentView.addSubview(pictureImageView)
        setupPictureImageView()
        contentView.addSubview(durationImageView)
        setupDurationImageView()
        contentView.addSubview(durationLabel)
        setupDurationLabel()
        contentView.addSubview(scoreView)
        contentView.addSubview(nameLabel)
        setupNameLabel()
    }
    
    private func setupPictureImageView() {
        pictureImageView.contentMode = .scaleAspectFit
        pictureImageView.image = Images.ackeeRecipe
        pictureImageView.clipsToBounds = true
        pictureImageView.layer.cornerRadius = 4
    }

    private func setupDurationImageView() {
        durationImageView.contentMode = .scaleAspectFit
        durationImageView.image = Images.clock
    }

    private func setupDurationLabel() {
        durationLabel.font = UIFont.systemFont(ofSize: 12)
    }

    private func setupNameLabel() {
        nameLabel.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        nameLabel.numberOfLines = 0
        nameLabel.lineBreakMode = .byTruncatingTail
        nameLabel.minimumScaleFactor = 0.5
        nameLabel.textColor = Colors.blue
    }

    // MARK: Layout

    override func layoutSubviews() {
        super.layoutSubviews()
        layoutPictureImageView()
        layoutDurationImageView()
        layoutDurationLabel()
        layoutScoreView()
        layoutNameLabel()
    }

    private let pictureImageViewWidthHeight: CGFloat = 76
    private func layoutPictureImageView() {
        let origin = CGPoint.zero
        let widthHeight: CGFloat = pictureImageViewWidthHeight
        let size = CGSize(width: widthHeight, height: widthHeight)
        let frame = CGRect(origin: origin, size: size)
        pictureImageView.frame = frame
    }

    private let durationImageVieWwidthHeight: CGFloat = 12
    private func layoutDurationImageView() {
        let widthHeight: CGFloat = durationImageVieWwidthHeight
        let size = CGSize(width: widthHeight, height: widthHeight)
        let x = pictureImageViewWidthHeight + 8
        let y = pictureImageViewWidthHeight - 4 - widthHeight
        let origin = CGPoint(x: x, y: y)
        let frame = CGRect(origin: origin, size: size)
        durationImageView.frame = frame
    }

    private func layoutDurationLabel() {
        let x = pictureImageViewWidthHeight + 8 + durationImageVieWwidthHeight + 4
        let height = durationImageVieWwidthHeight
        let availableWidth = bounds.width - x
        let availableSize = CGSize(width: availableWidth, height: height)
        var sizeThatFits = durationLabel.sizeThatFits(availableSize)
        if sizeThatFits.height > height {
            sizeThatFits.height = height
        }
        let y = durationImageView.frame.origin.y
        let origin = CGPoint(x: x, y: y)
        let frame = CGRect(origin: origin, size: sizeThatFits)
        durationLabel.frame = frame
    }

    private func layoutScoreView() {
        scoreView.starImageViewsWidthHeight = 12
        scoreView.starImageViewsSpace = 2
        let x = pictureImageViewWidthHeight + 8
        let availableHeight = CGFloat.greatestFiniteMagnitude
        let availableWidth = bounds.width - x
        let availableSize = CGSize(width: availableWidth, height: availableHeight)
        let sizeThatFits = scoreView.sizeThatFits(availableSize)
        let y = pictureImageViewWidthHeight - 4 - durationImageVieWwidthHeight - ((sizeThatFits.height - durationImageVieWwidthHeight) / 2) - 4 - sizeThatFits.height
        let origin = CGPoint(x: x, y: y)
        let frame = CGRect(origin: origin, size: sizeThatFits)
        scoreView.frame = frame
    }

    private func layoutNameLabel() {
        let x = pictureImageViewWidthHeight + 8
        let y: CGFloat = 4
        let availableWidth = bounds.width - x
        let availableHeight = scoreView.frame.origin.y - 4 - 4
        let availableSize = CGSize(width: availableWidth, height: availableHeight)
        var sizeThatFits = nameLabel.sizeThatFits(availableSize)
        if sizeThatFits.height > availableHeight {
            sizeThatFits.height = availableHeight
        }
        let origin = CGPoint(x: x, y: y)
        let frame = CGRect(origin: origin, size: sizeThatFits)
        nameLabel.frame = frame
    }

    // MARK: Events

    override func prepareForReuse() {
        super.prepareForReuse()
        setNeedsLayout()
        layoutIfNeeded()
    }

}
