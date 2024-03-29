//
//  OptionListModeView.swift
//  iOS_H3
//
//  Created by KoJeongMin  on 2023/08/16.
//

import UIKit
import Combine

protocol OptionListModeViewDelegate: AnyObject {
    func optionListModeViewDidTapImageModeButton(with optionListModeView: OptionListModeView)
}

final class OptionListModeView: UIView, OptionCardButtonListViewable {

    enum Constants {
        static let cellHeight = 150.0
        static let spacing = 10.0
        static let labelHeight = 19.0
        static let margin = 16.0
        static let imageModeButtonHeight = 20.0
        static let imageModeButtonWidth = 20.0
        static let containerViewTopConstant = 62.0
    }

    enum Section {
        case optionCard
    }

    typealias CollectionViewDiffableDataSource = UICollectionViewDiffableDataSource<Section, OptionCardInfo>

    // MARK: - UI properties

    private let containerView: UIView = UIView()

    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "옵션을 골라주세요."
        label.font = Fonts.regularTitle3
        label.setupLineHeight(FontLineHeights.regularTitle3)
        label.setupLetterSpacing(FontLetterSpacings.regularTitle3)
        if let font = Fonts.mediumTitle3 {
            label.applyBoldToString(targetString: "옵션", font: font)
        }
        return label
    }()

    private lazy var imageModeButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "image_mode_button_img"), for: .normal)
        button.addTarget(self, action: #selector(tapImageModeButton), for: .touchDown)
        return button
    }()

    private var collectionView: UICollectionView!

    // MARK: - Properties

    private let carMakingMode: CarMakingMode

    private var dataSource: CollectionViewDiffableDataSource!

    private var buttonTapCancellableByIndex: [Int: AnyCancellable] = [:]

    weak var listModeViewDelegate: OptionListModeViewDelegate?

    weak var delegate: OptionCardButtonListViewDelegate?

    // MARK: - Lifecycles

    override init(frame: CGRect) {
        carMakingMode = .selfMode
        super.init(frame: frame)
        setupViews(step: .powertrain)
    }

    required init?(coder: NSCoder) {
        carMakingMode = .selfMode
        super.init(coder: coder)
        setupViews(step: .powertrain)
    }

    init(frame: CGRect = .zero, carMakingMode: CarMakingMode, step: CarMakingStep) {
        self.carMakingMode = carMakingMode
        super.init(frame: frame)
        setupViews(step: step)
    }

    // MARK: - Helpers

    func configure(with cardInfos: [OptionCardInfo], step: CarMakingStep) {
        updateSnapshot(item: cardInfos)
    }

    func reloadOptionCards(with cardInfos: [OptionCardInfo], step: CarMakingStep) {
        cardInfos.enumerated().forEach { (index, info) in
            let indexPath = IndexPath(row: index, section: 0)
            guard let cell = collectionView.cellForItem(at: indexPath) as? OptionCardCell else {
                return
            }
            cell.configure(carMakingMode: carMakingMode, info: info, step: step)
        }
    }

    func playFeedbackAnimation(with feedbackComment: FeedbackComment, completion: (() -> Void)? = nil) {
        let visibleIndexPaths = collectionView.indexPathsForVisibleItems
        var animationsCompletedCount = 0

        for indexPath in visibleIndexPaths {
            guard let cell = collectionView.cellForItem(at: indexPath) as? OptionCardCell else {
                continue
            }

            cell.playFeedbackAnimation(with: feedbackComment) {
                animationsCompletedCount += 1

                if animationsCompletedCount == visibleIndexPaths.count {
                    completion?()
                }
            }
        }

        if visibleIndexPaths.isEmpty {
            completion?()
        }
    }
}

// MARK: - Setup

extension OptionListModeView {
    private func setupViews(step: CarMakingStep) {
        addSubviews()
        setupCollectionView(step: step)
        setupConstraints()
    }

    private func addSubviews() {
        addSubview(containerView)
        containerView.addSubview(descriptionLabel)
        containerView.addSubview(imageModeButton)
    }

    private func setupCollectionView(step: CarMakingStep) {
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: createCollectionViewLayout())
        containerView.addSubview(collectionView)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        registerCollectionViewCell()
        setupCollectionViewDataSource(step: step)
        setupSnapshot()
    }

    private func createCollectionViewLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .absolute(Constants.cellHeight)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 10.0, leading: 0, bottom: 0.0, trailing: 0)

        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .absolute(Constants.cellHeight)
        )
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        return UICollectionViewCompositionalLayout(section: section)
    }

    private func registerCollectionViewCell() {
        collectionView.register(OptionCardCell.self, forCellWithReuseIdentifier: OptionCardCell.identifier)
    }

    private func setupCollectionViewDataSource(step: CarMakingStep) {
        dataSource = CollectionViewDiffableDataSource(
            collectionView: collectionView
        ) { [weak self] (collectionView, indexPath, item) in
            guard let self,
                  let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: OptionCardCell.identifier,
                    for: indexPath
                  ) as? OptionCardCell else {
                return OptionCardCell()
            }

            cell.configure(carMakingMode: carMakingMode, info: item, step: step)

            buttonTapCancellableByIndex[indexPath.row] = cell.buttonTapSubject
                .sink { [weak self] in
                    guard let self else { return }
                    delegate?.optionCardButtonListView(self, didSelectOptionAt: indexPath.row)
                }

            return cell
        }
    }

    private func setupSnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, OptionCardInfo>()
        snapshot.appendSections([Section.optionCard])
        dataSource.apply(snapshot)
    }

    private func updateSnapshot(item: [OptionCardInfo]) {
        var snapshot = dataSource.snapshot()

        let previousItem = snapshot.itemIdentifiers
        snapshot.deleteItems(previousItem)
        snapshot.appendItems(item)

        dataSource.apply(snapshot)
    }

    private func setupConstraints() {
        containerView.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        imageModeButton.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
                containerView.topAnchor.constraint(equalTo: self.topAnchor,
                                                   constant: Constants.containerViewTopConstant),
                containerView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
                containerView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
                containerView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])

        NSLayoutConstraint.activate([
            descriptionLabel.topAnchor.constraint(equalTo: containerView.topAnchor),
            descriptionLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: Constants.margin),
            descriptionLabel.heightAnchor.constraint(equalToConstant: Constants.labelHeight)
        ])

        NSLayoutConstraint.activate([
            imageModeButton.topAnchor.constraint(equalTo: containerView.topAnchor),
            imageModeButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor,
                                                      constant: -Constants.margin),
            imageModeButton.heightAnchor.constraint(equalToConstant: Constants.imageModeButtonHeight),
            imageModeButton.widthAnchor.constraint(equalToConstant: Constants.imageModeButtonWidth)
        ])

        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor,
                                                constant: Constants.spacing),
            collectionView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor,
                                                    constant: Constants.margin),
            collectionView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor,
                                                     constant: -Constants.margin),
            collectionView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
        ])
    }

    @objc func tapImageModeButton() {
        listModeViewDelegate?.optionListModeViewDidTapImageModeButton(with: self)
    }
}
