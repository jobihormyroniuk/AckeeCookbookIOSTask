//
//  RecipeInDetailsScreenController.swift
//  AckeeCookbookIOSTaskPresentation
//
//  Created by Ihor Myroniuk on 4/6/20.
//  Copyright © 2020 Ihor Myroniuk. All rights reserved.
//

import AUIKit
import AFoundation

protocol RecipesDetailsScreenControllerDelegate: AnyObject {
    func recipeInDetailsScreenBack(_ recipeInDetailsScreen: RecipeDetailsScreenController)
    func recipeInDetailsScreenGetRecipeInDetails(_ recipeInDetailsScreen: RecipeDetailsScreenController, recipeInList: RecipeInList, completionHandler: @escaping (Result<RecipeInDetails, Error>) -> ())
    func recipeInDetailsScreenDeleteRecipeInDetails(_ recipeInDetailsScreen: RecipeDetailsScreenController, recipeInDetails: RecipeInDetails)
    func recipeInDetailsScreenUpdateRecipeInDetails(_ recipeInDetailsScreen: RecipeDetailsScreenController, recipeInDetails: RecipeInDetails)
    func recipeInDetailsScreenSetScore(_ recipeInDetailsScreen: RecipeDetailsScreenController, recipe: RecipeInDetails, score: Float, completionHandler: @escaping (Result<Float, Error>) -> ())
}

class RecipeDetailsScreenController: AUIStatusBarScreenController, UIScrollViewDelegate {
    
    // MARK: RecipeInDetailsScreen
    
    var delegate: RecipesDetailsScreenControllerDelegate?
    
    func updateRecipe(_ recipe: RecipeInDetails) {
        guard recipeInList.id == recipe.id else { return }
        let recipeInList = RecipeInList(id: recipe.id, name: recipe.name, duration: recipe.duration, score: recipe.score)
        self.recipeInList = recipeInList
        recipeInDetails = recipe
        setRecipeInDetailsContent(recipe)
        recipeInDetailsScreenView.setNeedsLayout()
        recipeInDetailsScreenView.layoutIfNeeded()
    }
    
    // MARK: Localization

    private let localizer: Localizer = {
        let bundle = Bundle(for: RecipesListScreenController.self)
        let tableName = "RecipeDetailsScreenStrings"
        let textLocalizer = TableNameBundleTextLocalizer(tableName: tableName, bundle: bundle)
        let localizator = CompositeLocalizer(textLocalization: textLocalizer)
        return localizator
    }()
    
    // MARK: Data
    
    private var recipeInList: RecipeInList
    private var recipeInDetails: RecipeInDetails?
    
    // MARK: Initializer
    
    init(view: UIView, recipeInList: RecipeInList) {
        self.recipeInList = recipeInList
        super.init(view: view)
    }
    
    // MARK: AddRecipeScreenView

    private var recipeInDetailsScreenView: RecipeDetailsScreenView! {
        return view as? RecipeDetailsScreenView
    }
    
    // MARK: Setup
    
    override func setup() {
        super.setup()
        recipeInDetailsScreenView.scrollView.delegate = self
        recipeInDetailsScreenView.backButton.addTarget(self, action: #selector(back), for: .touchUpInside)
        recipeInDetailsScreenView.deleteButton.addTarget(self, action: #selector(_delete), for: .touchUpInside)
        recipeInDetailsScreenView.updateButton.addTarget(self, action: #selector(update), for: .touchUpInside)
        recipeInDetailsScreenView.refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        for button in recipeInDetailsScreenView.setScoreButtons {
            button.addTarget(self, action: #selector(setScore), for: .touchUpInside)
        }
        statusBarStyle = .lightContent
        setContent()
    }

    // MARK: Events
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadDetailsIfNeeded()
    }
    
    // MARK: Actions
    
    @objc private func back() {
        delegate?.recipeInDetailsScreenBack(self)
    }

    @objc private func _delete() {
        guard let recipeInDetails = recipeInDetails else { return }
        delegate?.recipeInDetailsScreenDeleteRecipeInDetails(self, recipeInDetails: recipeInDetails)
    }
    
    @objc private func update() {
        guard let recipeInDetails = recipeInDetails else { return }
        delegate?.recipeInDetailsScreenUpdateRecipeInDetails(self, recipeInDetails: recipeInDetails)
    }
    
    @objc private func refresh() {
        delegate?.recipeInDetailsScreenGetRecipeInDetails(self, recipeInList: recipeInList, completionHandler: { [weak self] (result) in
            guard let self = self else { return }
            switch result {
            case .success(let recipe):
                self.recipeInDetails = recipe
                self.setRecipeInDetailsContent(recipe)
                self.recipeInDetailsScreenView.setNeedsLayout()
                self.recipeInDetailsScreenView.layoutIfNeeded()
                self.recipeInDetailsScreenView.refreshControl.endRefreshing()
            case .failure(let error):
                print(error)
                break
            }
        })
    }
    
    private func loadDetailsIfNeeded() {
        if recipeInDetails == nil {
            recipeInDetailsScreenView.refreshControl.beginRefreshing()
            refresh()
        }
    }
    
    @objc private func setScore(_ button: UIButton) {
        guard let recipe = self.recipeInDetails else { return }
        guard let index = recipeInDetailsScreenView.setScoreButtons.firstIndex(of: button) else { return }
        let score: Float = Float(index + 1)
        recipeInDetailsScreenView.beginSetScoreActivity()
        delegate?.recipeInDetailsScreenSetScore(self, recipe: recipe, score: score, completionHandler: { [weak self] (result) in
            guard let self = self else { return }
            switch result {
            case .success(let score):
                self.recipeInList.score = score
                self.recipeInDetails?.score = score
                self.recipeInDetailsScreenView.setScore(score)
                self.recipeInDetailsScreenView.endSetScoreActivity()
            case .failure:
                self.recipeInDetailsScreenView.endSetScoreActivity()
            }
        })
    }
    
    // MARK: UIScrollViewDelegate
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        recipeInDetailsScreenView.layoutPictureImageView()
        let p = recipeInDetailsScreenView.pictureImageView.bounds.height
        let n = recipeInDetailsScreenView.navigationBarView.frame.origin.y + recipeInDetailsScreenView.navigationBarView.bounds.height
        let r = recipeInDetailsScreenView.scoreDurationView.bounds.height
        let s = recipeInDetailsScreenView.scrollView.contentOffset.y
        var c = s / (p - r - n)
        if c < 0 {
            c = 0
        } else if c > 1 {
            c = 1
        }
        let _c = 1 - c
        let color = UIColor.white.withAlphaComponent(c)
        recipeInDetailsScreenView.statusBarView.backgroundColor = color
        recipeInDetailsScreenView.navigationBarView.backgroundColor = color
        let _color = UIColor(red: (0 + 255 * _c) / 255, green: (30 + 255 * _c) / 255, blue: (245 + 255 * _c) / 255, alpha: 1)
        recipeInDetailsScreenView.backButton.setTitleColor(_color, for: .normal)
        let image = Images.back
        statusBarStyle = _c > 0.5 ? .lightContent : .default
        recipeInDetailsScreenView.backButton.setImage(image.withTintColor(_color), for: .normal)
        recipeInDetailsScreenView.backButton.setImage(image.withTintColor(_color), for: .highlighted)
        recipeInDetailsScreenView.deleteButton.setTitleColor(_color, for: .normal)
        recipeInDetailsScreenView.updateButton.setTitleColor(_color, for: .normal)
    }
    
    // MARK: Content

    private func setContent() {
        recipeInDetailsScreenView.backButton.setTitle(localizer.localizeText("back"), for: .normal)
        recipeInDetailsScreenView.deleteButton.setTitle(localizer.localizeText("delete"), for: .normal)
        recipeInDetailsScreenView.updateButton.setTitle(localizer.localizeText("update"), for: .normal)
        recipeInDetailsScreenView.setScoreLabel.text = localizer.localizeText("score")
    }
    
    private func setRecipeInDetailsContent(_ recipe: RecipeInDetails) {
        recipeInDetailsScreenView.nameLabel.text = recipe.name
        recipeInDetailsScreenView.infoLabel.text = recipe.info
        recipeInDetailsScreenView.ingredientsLabel.text = localizer.localizeText("ingredients")
        recipeInDetailsScreenView.setIngredients(recipe.ingredients)
        recipeInDetailsScreenView.descriptionTitleLabel.text = localizer.localizeText("description")
        recipeInDetailsScreenView.descriptionLabel.text = recipe.description
        recipeInDetailsScreenView.setScore(recipe.score)
        recipeInDetailsScreenView.setDuration(localizer.localizeText("durationInMinutes", "\(recipe.duration)"))
    }
}
