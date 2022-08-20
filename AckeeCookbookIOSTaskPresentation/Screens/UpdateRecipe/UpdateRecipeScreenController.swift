//
//  UpdateRecipeScreenController.swift
//  AckeeCookbookIOSTaskPresentation
//
//  Created by Ihor Myroniuk on 03.05.2020.
//  Copyright © 2020 Ihor Myroniuk. All rights reserved.
//

import AUIKit
import AFoundation

protocol UpdateRecipeScreenDelegate: class {
    func updateRecipeScreenBack(_ updateRecipeScreen: UpdateRecipeScreenController)
    func updateRecipeScreenUpdateRecipe(_ recipe: UpdatingRecipe)
}

class UpdateRecipeScreenController: AUIStatusBarScreenController, AUITextViewControllerDidChangeTextObserver, AUIControlControllerDidValueChangedObserver {
    
    // MARK: Data
    
    private var recipe: RecipeInDetails
    
    // MARK: Initializer
    
    init(view: UIView, recipe: RecipeInDetails) {
        self.recipe = recipe
        super.init(view: view)
    }

    // MARK: AddRecipeScreen

    weak var delegate: UpdateRecipeScreenDelegate?

    // MARK: Localization

    private let localizer: Localizer = {
        let bundle = Bundle(for: RecipesListScreenController.self)
        let tableName = "UpdateRecipeScreenStrings"
        let textLocalizer = TableNameBundleTextLocalizer(tableName: tableName, bundle: bundle)
        let localizator = CompositeLocalizer(textLocalization: textLocalizer)
        return localizator
    }()

    // MARK: AddRecipeScreenView

    private var updateRecipeScreenView: UpdateRecipeScreenView! {
        return view as? UpdateRecipeScreenView
    }

    // MARL: Controllers

    private let nameTextViewController = AUIEmptyTextViewController()
    private let infoTextViewController = AUIEmptyTextViewController()
    private var ingredientInputViewControllers: [AUIResponsiveTextViewTextInputViewController] = []
    private let descriptionTextViewController = AUIEmptyTextViewController()
    private let durationTextViewController = AUIEmptyTextViewController()
    private let durationDatePickerControler = AUIEmptyCountDownDurationDatePickerController()

    // MARK: Setup

    override func setup() {
        super.setup()
        updateRecipeScreenView.backButton.addTarget(self, action: #selector(back), for: .touchUpInside)
        updateRecipeScreenView.addButton.addTarget(self, action: #selector(add), for: .touchUpInside)
        nameTextViewController.textView = updateRecipeScreenView.nameTextInputView.textView
        nameTextViewController.addDidChangeTextObserver(self)
        infoTextViewController.textView = updateRecipeScreenView.infoTextInputView.textView
        infoTextViewController.addDidChangeTextObserver(self)
        descriptionTextViewController.textView = updateRecipeScreenView.descriptionInputView.textView
        descriptionTextViewController.addDidChangeTextObserver(self)
        updateRecipeScreenView.addIngredientButton.addTarget(self, action: #selector(addIngredient), for: .touchUpInside)
        durationTextViewController.textView = updateRecipeScreenView.durationInputView.textField
        durationTextViewController.inputViewController = durationDatePickerControler
        durationDatePickerControler.countDownDuration = 50
        durationDatePickerControler.countDownDuration = 50
        durationDatePickerControler.minuteInterval = 10
        durationDatePickerControler.addDidValueChangedObserver(self)
        for ingredient in recipe.ingredients {
            let ingredientInputView = updateRecipeScreenView.addIngredientInputView()
            ingredientInputView.placeholderLabel.text = "ingredient"
            let textViewController = AUIEmptyTextViewController()
            textViewController.addDidChangeTextObserver(self)
            let textViewTextInputController = AUIResponsiveTextViewTextInputViewController()
            textViewTextInputController.textViewController = textViewController
            textViewTextInputController.responsiveTextInputView = ingredientInputView
            ingredientInputViewControllers.append(textViewTextInputController)
            textViewController.text = ingredient
        }
        setContent()
    }

    // MARK: Events

    func textViewControllerDidChangeText(_ textViewController: AUITextViewController) {
        updateRecipeScreenView.setNeedsLayout()
        updateRecipeScreenView.layoutIfNeeded()
    }
    
    func controlControllerDidValueChanged(_ controlController: AUIControlController) {
        if controlController === durationDatePickerControler {
            pickDuration()
        }
    }

    // MARK: Actions

    @objc private func back() {
        delegate?.updateRecipeScreenBack(self)
    }

    @objc private func add() {
        guard let name = nameTextViewController.text else {
            return
        }
        guard let description = descriptionTextViewController.text else {
            return
        }
        let ingredients = ingredientInputViewControllers.map({ $0.textViewController?.text }).compactMap({ $0 })
        guard let info = infoTextViewController.text else {
            return
        }
        let id = recipe.id
        let updatingRecipe = UpdatingRecipe(id: id, name: name, duration: 100, description: description, info: info, ingredients: ingredients)
        delegate?.updateRecipeScreenUpdateRecipe(updatingRecipe)
    }

    @objc private func addIngredient() {
        let ingredientInputView = updateRecipeScreenView.addIngredientInputView()
        ingredientInputView.placeholderLabel.text = "ingredient"
        let textViewController = AUIEmptyTextViewController()
        textViewController.addDidChangeTextObserver(self)
        let textViewTextInputController = AUIResponsiveTextViewTextInputViewController()
        textViewTextInputController.textViewController = textViewController
        textViewTextInputController.responsiveTextInputView = ingredientInputView
        ingredientInputViewControllers.append(textViewTextInputController)
    }
    
    private func pickDuration() {
        let durationInSeconds = durationDatePickerControler.countDownDuration
        let durationInMinutes = Int(durationInSeconds / 60)
        updateRecipeScreenView.durationInputView.textField.text = localizer.localizeText("durationInMinutes", "\(durationInMinutes)")
    }

    // MARK: Content

    private func setContent() {
        updateRecipeScreenView.backButton.setTitle(localizer.localizeText("back"), for: .normal)
        updateRecipeScreenView.addButton.setTitle(localizer.localizeText("update"), for: .normal)
        updateRecipeScreenView.titleLabel.text = localizer.localizeText("title")
        updateRecipeScreenView.nameTextInputView.titleLabel.text = localizer.localizeText("recipeName")?.uppercased()
        updateRecipeScreenView.infoTextInputView.titleLabel.text = localizer.localizeText("recipeInfo")?.uppercased()
        updateRecipeScreenView.ingredientsLabel.text = localizer.localizeText("recipeIngredients")?.uppercased()
        updateRecipeScreenView.addIngredientButton.setTitle(localizer.localizeText("recideAddIngredient")?.uppercased(), for: .normal)
        updateRecipeScreenView.descriptionInputView.titleLabel.text = localizer.localizeText("recideDescription")?.uppercased()
        updateRecipeScreenView.durationInputView.titleLabel.text = localizer.localizeText("recideDuration")
        setRecipeContent()
    }
    
    private func setRecipeContent() {
        nameTextViewController.text = recipe.name
        descriptionTextViewController.text = recipe.description
        infoTextViewController.text = recipe.info
        durationDatePickerControler.countDownDuration = TimeInterval(recipe.duration)
    }

}

