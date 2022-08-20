//
//  AddRecipeScreenController.swift
//  AckeeCookbookIOSTaskPresentation
//
//  Created by Ihor Myroniuk on 3/31/20.
//  Copyright © 2020 Ihor Myroniuk. All rights reserved.
//

import AUIKit
import AFoundation

protocol AddRecipeScreenControllerDelegate: AnyObject {
    func addRecipeScreenBack(_ addRecipeScreen: AddRecipeScreenController)
    func addRecipeScreenAddRecipe(_ addRecipeScreen: AddRecipeScreenController, _ recipe: AddingRecipe)
}

class AddRecipeScreenController: AUIStatusBarScreenController, AUITextViewControllerDidChangeTextObserver, AUIControlControllerDidValueChangedObserver {

    // MARK: AddRecipeScreen

    weak var delegate: AddRecipeScreenControllerDelegate?

    // MARK: Localization

    private let localizer: Localizer = {
        let bundle = Bundle(for: RecipesListScreenController.self)
        let tableName = "AddRecipeScreenStrings"
        let textLocalizer = TableNameBundleTextLocalizer(tableName: tableName, bundle: bundle)
        let localizator = CompositeLocalizer(textLocalization: textLocalizer)
        return localizator
    }()

    // MARK: AddRecipeScreenView

    private var addRecipeScreenView: AddRecipeScreenView! {
        return view as? AddRecipeScreenView
    }

    // MARL: Controllers

    private let nameTextViewController = AUIEmptyTextViewController()
    private let infoTextViewController = AUIEmptyTextViewController()
    private var ingredientInputViewControllers: [AUIResponsiveTextViewTextInputViewController] = []
    private let descriptionTextViewController = AUIEmptyTextViewController()
    private let durationTextViewController = AUIEmptyTextViewController()
    private let durationDatePickerControler = AUIEmptyCountDownDurationDatePickerController()
    private let tapGestureRecognizer = UITapGestureRecognizer()

    // MARK: Setup

    override func setup() {
        super.setup()
        addRecipeScreenView.addGestureRecognizer(tapGestureRecognizer)
        tapGestureRecognizer.addTarget(self, action: #selector(hideKeyboard))
        addRecipeScreenView.backButton.addTarget(self, action: #selector(back), for: .touchUpInside)
        addRecipeScreenView.addButton.addTarget(self, action: #selector(add), for: .touchUpInside)
        nameTextViewController.textView = addRecipeScreenView.nameTextInputView.textView
        nameTextViewController.addDidChangeTextObserver(self)
        infoTextViewController.textView = addRecipeScreenView.infoTextInputView.textView
        infoTextViewController.addDidChangeTextObserver(self)
        descriptionTextViewController.textView = addRecipeScreenView.descriptionInputView.textView
        descriptionTextViewController.addDidChangeTextObserver(self)
        addRecipeScreenView.addIngredientButton.addTarget(self, action: #selector(addIngredient), for: .touchUpInside)
        durationTextViewController.textView = addRecipeScreenView.durationInputView.textField
        durationTextViewController.inputViewController = durationDatePickerControler
        durationTextViewController.addDidChangeTextObserver(self)
        durationDatePickerControler.addDidValueChangedObserver(self)
        durationDatePickerControler.minuteInterval = 5
        durationDatePickerControler.countDownDuration = TimeInterval(30 * 60)
        setContent()
    }
    
    // MARK: Events

    func textViewControllerDidChangeText(_ textViewController: AUITextViewController) {
        addRecipeScreenView.setNeedsLayout()
        addRecipeScreenView.layoutIfNeeded()
    }
    
    func controlControllerDidValueChanged(_ controlController: AUIControlController) {
        if controlController === durationDatePickerControler {
            pickDuration()
        }
    }

    // MARK: Actions
    
    @objc func hideKeyboard() {
        view.endEditing(true)
    }

    @objc private func back() {
        delegate?.addRecipeScreenBack(self)
    }

    @objc private func add() {
        let name = nameTextViewController.text ?? ""
        let description = descriptionTextViewController.text ?? ""
        let ingredients = ingredientInputViewControllers.map({ $0.textViewController?.text }).compactMap({ $0 })
        let info = infoTextViewController.text ?? ""
        let duration = Int(durationDatePickerControler.countDownDuration)
        let recipe = AddingRecipe(name: name, description: description, ingredients: ingredients, duration: duration, info: info)
        delegate?.addRecipeScreenAddRecipe(self, recipe)
    }

    @objc private func addIngredient() {
        let ingredientInputView = addRecipeScreenView.addIngredientInputView()
        ingredientInputView.placeholderLabel.text = localizer.localizeText("ingredient")
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
        addRecipeScreenView.durationInputView.textField.text = localizer.localizeText("durationInMinutes", "\(durationInMinutes)")
    }

    // MARK: Content

    private func setContent() {
        addRecipeScreenView.backButton.setTitle(localizer.localizeText("back"), for: .normal)
        addRecipeScreenView.addButton.setTitle(localizer.localizeText("add"), for: .normal)
        addRecipeScreenView.titleLabel.text = localizer.localizeText("title")
        addRecipeScreenView.nameTextInputView.titleLabel.text = localizer.localizeText("recipeName")?.uppercased()
        addRecipeScreenView.infoTextInputView.titleLabel.text = localizer.localizeText("recipeInfo")?.uppercased()
        addRecipeScreenView.ingredientsLabel.text = localizer.localizeText("recipeIngredients")?.uppercased()
        addRecipeScreenView.addIngredientButton.setTitle(localizer.localizeText("recideAddIngredient")?.uppercased(), for: .normal)
        addRecipeScreenView.descriptionInputView.titleLabel.text = localizer.localizeText("recideDescription")?.uppercased()
        addRecipeScreenView.durationInputView.titleLabel.text = localizer.localizeText("recideDuration")
    }

}
