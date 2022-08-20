//
//  RecipesInListScreenLoadCollectionViewCell.swift
//  AckeeCookbookIOSTaskPresentation
//
//  Created by Ihor Myroniuk on 08.05.2020.
//  Copyright © 2020 Ihor Myroniuk. All rights reserved.
//

import AUIKit

class RecipesListScreenLoadingCollectionViewCell: AUICollectionViewCell {

    // MARK: Subviews

    private let activityIndicatorView = UIActivityIndicatorView()
    
    // MARK: Setup
    
    override func setup() {
        super.setup()
        contentView.addSubview(activityIndicatorView)
        activityIndicatorView.startAnimating()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        activityIndicatorView.startAnimating()
    }
    
    // MARK: Layout Subviews
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layoutActivityIndicatorView()
    }
    
    private func layoutActivityIndicatorView() {
        activityIndicatorView.frame = bounds
    }
    
}
