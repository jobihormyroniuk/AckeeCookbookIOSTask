//
//  ScoreStarsView.swift
//  AckeeCookbookIOSTaskPresentation
//
//  Created by Ihor Myroniuk on 4/4/20.
//  Copyright © 2020 Ihor Myroniuk. All rights reserved.
//

import AUIKit

class ScoreStarsView: UIView {

    // MARK: Subviews

    private var starImageViews: [UIImageView] = []

    // MARK: Star

    var starImageTintColor: UIColor = Colors.red
    private var starImageView: UIImageView {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = Images.star.withTintColor(starImageTintColor)
        return imageView
    }

    // MARK: Value

    func setScore(_ score: Float) {
        starImageViews.forEach({ $0.removeFromSuperview() })
        let count = Int(score.rounded(.toNearestOrAwayFromZero))
        var array: [UIImageView] = []
        for _ in 0..<count {
            let imageView = starImageView
            array.append(imageView)
            addSubview(imageView)
        }
        starImageViews = array
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
        for starImageView in starImageViews {
            let origin = CGPoint(x: x, y: y)
            let frame = CGRect(origin: origin, size: size)
            starImageView.frame = frame
            x += widthHeight + starImageViewsSpace
        }
    }

    // MARK: Size

    override func sizeThatFits(_ size: CGSize) -> CGSize {
        let height = starImageViewsWidthHeight
        var width = ((starImageViewsWidthHeight + starImageViewsSpace) * CGFloat(starImageViews.count)) - starImageViewsSpace
        if width < 0 { width = 0 }
        let sizeThatFits = CGSize(width: width, height: height)
        return sizeThatFits
    }
}
