//
//  CarMakingViewController.swift
//  iOS_H3
//
//  Created by  sangyeon on 2023/08/15.
//

import UIKit
import Combine

final class CarMakingViewController: UIViewController {

    enum Constants {
        static let titleBarHeight = 50.0
        static let bottomModalViewHeight = 129.0
    }

    // MARK: - UI properties

    private var titleBar: OhMyCarSetTitleBar!

    private var carMakingContentView: CarMakingContentView<PageSection>!

    private let bottomModalView = BottomModalView()

    // MARK: - Properties

    private let mode: CarMakingMode

    private let viewModel: CarMakingViewModel

    private let viewDidLoadSubject = PassthroughSubject<Void, Never>()

    private let stepDidChanged = CurrentValueSubject<CarMakingStep, Never>(.powertrain)

    private let optionDidSelected = PassthroughSubject<(step: CarMakingStep, optionIndex: Int), Never>()

    private let optionCategoryDidChanged = CurrentValueSubject<OptionCategoryType, Never>(.system)

    private var dictionaryButtonPressed = PassthroughSubject<Void, Never>()

    private let nextButtonDidTapped = PassthroughSubject<Void, Never>()

    private var isBlockedNextButton = false

    private var cancellables = Set<AnyCancellable>()

    private var carMakingContentViewBottomConstraint: NSLayoutConstraint?

    // MARK: - Lifecycles

    init(mode: CarMakingMode, viewModel: CarMakingViewModel) {
        self.viewModel = viewModel
        self.mode = mode
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        self.mode = .selfMode
        self.viewModel = CarMakingViewModel(
            selfModeUsecase: SelfModeUsecase(
                carInfoRepository: CarInfoRepository(networkService: NetworkService()),
                introRepsitory: IntroRepository(networkService: NetworkService())
            )
        )
        super.init(coder: coder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupProperties()
        setupViews()
        bind()
        viewDidLoadSubject.send(())
    }

    // MARK: - Helpers
}

// MARK: - binding with ViewModel

extension CarMakingViewController {

    private func bind() {
        let input = CarMakingViewModel.Input(
            viewDidLoad: viewDidLoadSubject,
            carMakingStepDidChanged: stepDidChanged,
            optionDidSelected: optionDidSelected,
            optionCategoryDidChanged: optionCategoryDidChanged,
            dictionaryButtonPressed: dictionaryButtonPressed,
            nextButtonDidTapped: nextButtonDidTapped
        )
        let output = viewModel.transform(input)

        output.estimateSummary
            .receive(on: DispatchQueue.main)
            .sink { [weak self] summary in
                self?.updateBottomModalView(with: summary)
                self?.carMakingContentView.updateEstimateCell(with: summary)
            }
            .store(in: &cancellables)

        output.currentStepInfo
            .receive(on: DispatchQueue.main)
            .sink { [weak self] info in
                self?.updateCurrentStepInfo(with: info)
            }
            .store(in: &cancellables)

        output.optionInfoDidUpdated
            .sink { [weak self] optionInfo in
                self?.carMakingContentView.updateOptionCard(with: optionInfo)

                self?.carMakingContentView.updateEstimateCell(options: optionInfo)

            }
            .store(in: &cancellables)

        output.optionInfoForCategory
            .receive(on: DispatchQueue.main)
            .sink { [weak self] optionInfo in
                self?.carMakingContentView.updateOptionCardForCategory(
                    with: optionInfo,
                    step: self?.stepDidChanged.value ?? .powertrain
                )
            }
            .store(in: &cancellables)

        output.numberOfSelectedAdditionalOption
            .receive(on: DispatchQueue.main)
            .sink { [weak self] selectedOptionCount in
                self?.carMakingContentView.updateSelectedOptionCountLabel(to: selectedOptionCount)
            }
            .store(in: &cancellables)

        output.feedbackComment
            .receive(on: DispatchQueue.main)
            .sink { [weak self] feedbackComment in
                guard let feedbackComment else {
                    self?.carMakingContentView.moveNextStep()
                    self?.isBlockedNextButton = false
                    return
                }
                self?.carMakingContentView.playFeedbackAnimation(with: feedbackComment) { [weak self] in
                    self?.carMakingContentView.moveNextStep()
                    self?.isBlockedNextButton = false
                }
            }
            .store(in: &cancellables)

        output.showIndicator
            .sink { [weak self] showIndicator in
                self?.showIndicator(showIndicator)
            }
            .store(in: &cancellables)
    }

    private func updateBottomModalView(with estimateData: EstimateSummary) {
        bottomModalView.updateEstimateSummary(estimateData)
    }

    private func updateCurrentStepInfo(with info: CarMakingStepInfo) {
        carMakingContentView.configureCurrentStep(with: info)
    }

    private func showIndicator(_ show: Bool) {
        if show {
            view.showLoadingIndicator()
        } else {
            view.hideLoadingIndicator()
        }
    }
}

// MARK: - OhMyCarSetTitleBar Delegate

extension CarMakingViewController: OhMyCarSetTitleBarDelegate {

    func titleBarBackButtonPressed(_ titleBar: OhMyCarSetTitleBar) {
        let exitPopupViewController = ExitPopupViewController()
        exitPopupViewController.modalPresentationStyle = .overFullScreen
        self.present(exitPopupViewController, animated: false)
    }

    func titleBarTitleButtonTapped(_ titleBar: OhMyCarSetTitleBar) {
        let modeChangePopupViewController = ModeChangePopupViewController(currentMode: self.mode)
        modeChangePopupViewController.modalPresentationStyle = .overFullScreen
        self.present(modeChangePopupViewController, animated: false)
    }

    func titleBarDictionaryButtonPressed(_ titleBar: OhMyCarSetTitleBar) {
        let isOn = TextEffectManager.shared.isDictionaryFunctionActive
        TextEffectManager.shared.applyEffectSubviews(!isOn, on: self.view)
    }

    func titleBarChangeModelButtonPressed(_ titleBar: OhMyCarSetTitleBar) {
        let exitPopupViewController = ModelChangePopupViewController()
        exitPopupViewController.modalPresentationStyle = .overFullScreen
        self.present(exitPopupViewController, animated: false)
    }
}

// MARK: - CarMakingContentView Delegate

extension CarMakingViewController: CarMakingContentViewDelegate {

    func carMakingContentView(stepDidChanged stepIndex: Int) {
        if let step = CarMakingStep(rawValue: stepIndex) {
            stepDidChanged.send(step)
        }
    }

    func carMakingContentView(optionDidSelectedAt optionIndex: Int, in stepIndex: Int) {
        if let step = CarMakingStep(rawValue: stepIndex) {
            optionDidSelected.send((step, optionIndex))
        }
    }

    func carMakingContentView(categoryDidSelected category: OptionCategoryType) {
        optionCategoryDidChanged.send(category)
    }

    func carMakingContentViewEstimateCellDidShow() {
        bottomModalView.isHidden = true
        carMakingContentViewBottomConstraint?.constant = 0
        carMakingContentView.updateEstimateResult(to: 500)
    }
}

// MARK: - BottomModalView Delegate

extension CarMakingViewController: BottomModalViewDelegate {

    func bottomModalViewBackButtonDidTapped(_ bottomModalView: BottomModalView) {
        carMakingContentView.movePrevStep()
    }

    func bottomModalViewCompletionButtonDidTapped(_ bottomModalView: BottomModalView) {
        if !isBlockedNextButton {
            nextButtonDidTapped.send(())
            isBlockedNextButton = true
        }
    }
}

// MARK: - Setup Properties

extension CarMakingViewController {

    private func setupProperties() {
        setupTitleBar()
        setupContentView()
        setupBottomModalView()
    }

    private func setupTitleBar() {
        let titleBarType: OhMyCarSetTitleBar.NavigationBarType = (mode == .selfMode) ? .selfMode : .guideMode
        titleBar = OhMyCarSetTitleBar(type: titleBarType)
        titleBar.isDictionaryButtonOn = TextEffectManager.shared.isDictionaryFunctionActive
        titleBar.delegate = self
        titleBar.translatesAutoresizingMaskIntoConstraints = false
    }

    private func setupContentView() {
        carMakingContentView = CarMakingContentView(frame: .zero, mode: mode)
        carMakingContentView.delegate = self
        carMakingContentView.translatesAutoresizingMaskIntoConstraints = false
    }

    private func setupBottomModalView() {
        bottomModalView.delegate = self
        bottomModalView.translatesAutoresizingMaskIntoConstraints = false
    }
}

// MARK: - SetupViews

extension CarMakingViewController {

    private func setupViews() {
        view.backgroundColor = .white
        addSubviews()
        setupConstraints()
    }

    private func addSubviews() {
        [titleBar, carMakingContentView, bottomModalView].forEach {
            view.addSubview($0)
        }
    }

    private func setupConstraints() {
        setupTitleBarConstraints()
        setupContentViewConstraints()
        setupBottomModalViewConstraints()
    }

    private func setupTitleBarConstraints() {
        NSLayoutConstraint.activate([
            titleBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            titleBar.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            titleBar.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            titleBar.heightAnchor.constraint(equalToConstant: Constants.titleBarHeight)
        ])
    }

    private func setupContentViewConstraints() {
        carMakingContentViewBottomConstraint = carMakingContentView.bottomAnchor.constraint(
            equalTo: view.safeAreaLayoutGuide.bottomAnchor,
            constant: -Constants.bottomModalViewHeight
        )

        NSLayoutConstraint.activate([
            carMakingContentView.topAnchor.constraint(equalTo: titleBar.bottomAnchor),
            carMakingContentView.leadingAnchor.constraint(equalTo: titleBar.leadingAnchor),
            carMakingContentView.trailingAnchor.constraint(equalTo: titleBar.trailingAnchor),
            carMakingContentViewBottomConstraint!
        ])
    }

    private func setupBottomModalViewConstraints() {
        NSLayoutConstraint.activate([
            bottomModalView.leadingAnchor.constraint(equalTo: titleBar.leadingAnchor),
            bottomModalView.trailingAnchor.constraint(equalTo: titleBar.trailingAnchor),
            bottomModalView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}
