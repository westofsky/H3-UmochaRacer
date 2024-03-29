//
//  CarMakingContentViewController.swift
//  iOS_H3_UI
//
//  Created by KoJeongMin  on 2023/08/10.
//

import UIKit

final class CarMakingContentViewController: UIViewController {

    enum Constants {
        static let inset: CGFloat = 0.0
    }

    // MARK: - UI Properties
    lazy var selfModeBar: OhMyCarSetTitleBar = {
        let titleBar = OhMyCarSetTitleBar(type: .selfMode)
        titleBar.delegate = self
        titleBar.translatesAutoresizingMaskIntoConstraints = false
        return titleBar
    }()

    private lazy var carMakingContentView: CarMakingContentView = {
        let view = CarMakingContentView<PageSection>(frame: .zero, mode: .selfMode)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    // MARK: - Properties

    // MARK: - Lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        carMakingContentView.delegate = self
        carMakingContentView(stepDidChanged: 0)
    }

    // MARK: - Helpers
    private func setupViews() {
        view.backgroundColor = .white
        addSubviews()
        setupConstraints()
    }

    private func addSubviews() {
        self.view.addSubview(selfModeBar)
        self.view.addSubview(carMakingContentView)
    }

    private func setupConstraints() {

        NSLayoutConstraint.activate([
            selfModeBar.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 0),
            selfModeBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            selfModeBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            selfModeBar.heightAnchor.constraint(equalToConstant: 50),

            carMakingContentView.topAnchor.constraint(equalTo: selfModeBar.bottomAnchor, constant: 0),
            carMakingContentView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.inset),
            carMakingContentView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.inset),
            carMakingContentView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

    }
}
extension CarMakingContentViewController: OhMyCarSetTitleBarDelegate {
    func titleBarTitleButtonTapped(_ titleBar: OhMyCarSetTitleBar) {
        print("titleButton Pressed")
    }

    func titleBarBackButtonPressed(_ titleBar: OhMyCarSetTitleBar) {
        print("backButton Pressed")
        self.dismiss(animated: true)
    }

    func titleBarSkipButtonPressed(_ titleBar: OhMyCarSetTitleBar) {
        print("skipButton Pressed")
    }

    func titleBarDictionaryButtonPressed(_ titleBar: OhMyCarSetTitleBar) {
        print("dictionaryButton Pressed")
    }

    func titleBarChangeModelButtonPressed(_ titleBar: OhMyCarSetTitleBar) {
        print("changeModelButton Pressed")
    }
}

extension CarMakingContentViewController: CarMakingContentViewDelegate {

    func carMakingContentView(stepDidChanged stepIndex: Int) {
        guard let step = CarMakingStep(rawValue: stepIndex) else { return }

        let stepInfo = CarMakingStepInfo(
            step: step,
            optionCardInfoArray: CarMakingContentMockData.mockOption[stepIndex]
        )
        carMakingContentView.configureCurrentStep(with: stepInfo)
    }

    func carMakingContentView(optionDidSelectedAt optionIndex: Int, in stepIndex: Int) {
        CarMakingContentMockData.mockOption[stepIndex][optionIndex].isSelected.toggle()
        carMakingContentView.updateOptionCard(with: CarMakingContentMockData.mockOption[stepIndex])
    }

    func carMakingContentView(categoryDidSelected category: OptionCategoryType) {
        carMakingContentView.updateOptionCard(with: CarMakingContentMockData.mockOption[category.rawValue - 1])
    }

    func carMakingContentViewEstimateCellDidShow() {
    }
}

// Mock Data
struct CarMakingContentMockData {
    static let mockURL = [
        "https://cdn.autotribune.co.kr/news/photo/202101/4849_30727_3533.jpg",
         // swiftlint:disable:next line_length
         "https://i.namu.wiki/i/cBMX6XiTLltPPIawbb2zfP5Oy5RW9JybY0E5ZQ62oUYdppA2t54xDjiST7xfLe_2dL4pGN9VsBVknq4H-SYA2A.webp",
         "https://cdn.epnc.co.kr/news/photo/201804/79474_70575_4841.jpg",
         "https://pimg.daara.co.kr/kidd/photo/2021/01/08/thumbs/thumb_520390_1610089982_79.jpg",
        "https://pimg.daara.co.kr/kidd/photo/2021/01/08/thumbs/thumb_520390_1610089971_11.jpg",
         "https://itimg.chosun.com/sitedata/image/202112/03/2021120301496_0.jpg"
    ].map { URL(string: $0)! }

    static var mockOption = [
            [OptionCardInfo.init(id: 0,
                                 title: URString(fullText: "디젤 2.2"),
                                 subTitle: URString(fullText: "구매자의 63%가 선택한"),
                                 priceString: "+ 3,456,789원",
                                 bannerImageURL: mockURL[0],
                                 isSelected: true),
             OptionCardInfo.init(id: 1,
                                 title: URString(fullText: "가솔린 3.8"),
                                 subTitle: URString(fullText: "구매자의 37%가 선택한"),
                                 priceString: "+ 3,456,789원",
                                 bannerImageURL: mockURL[1])],
            [OptionCardInfo.init(id: 2,
                                 title: URString(fullText: "2WD"),
                                 subTitle: URString(fullText: "구매자의 72%가 선택한"),
                                 priceString: "+ 3,456,789원",
                                 bannerImageURL: mockURL[2],
                                 isSelected: true),
             OptionCardInfo.init(id: 3,
                                 title: URString(fullText: "4WD"),
                                 subTitle: URString(fullText: "구매자의 82%가 선택한"),
                                 priceString: "+ 3,456,789원",
                                 bannerImageURL: mockURL[0])],
            [OptionCardInfo.init(id: 4,
                                 title: URString(fullText: "7인승"),
                                 subTitle: URString(fullText: "구매자의 63%가 선택한"),
                                 priceString: "+ 3,456,789원",
                                 bannerImageURL: mockURL[1],
                                 isSelected: true),
             OptionCardInfo.init(id: 5,
                                 title: URString(fullText: "8인승"),
                                 subTitle: URString(fullText: "구매자의 63%가 선택한"),
                                 priceString: "+ 3,456,789원",
                                 bannerImageURL: mockURL[3])],
            [OptionCardInfo.init(id: 6,
                                 title: URString(fullText: "크리미 화이트 펄"),
                                 subTitle: URString(fullText: "구매자의 88%가 선택한"),
                                 priceString: "+ 3,456,789원",
                                 bannerImageURL: mockURL[4],
                                 color: nil,
                                 isSelected: true),
             OptionCardInfo.init(id: 7,
                                 title: URString(fullText: "LK-99 3.8"),
                                 subTitle: URString(fullText: "구매자의 12%가 선택한"),
                                 priceString: "+ 3,456,789원",
                                 bannerImageURL: mockURL[0])],
            [OptionCardInfo.init(id: 8,
                                 title: URString(fullText: "가솔린 3.8"),
                                 subTitle: URString(fullText: "구매자의 63%가 선택한"),
                                 priceString: "+ 3,456,789원",
                                 bannerImageURL: mockURL[5],
                                 // swiftlint:disable:next line_length
                                 iconImageURL: URL(string: "https://github.com/sangyeon3/kakao_pathfinder_assignment/assets/68235938/fe0d0580-f5b2-47fe-80ff-bab37e6f4815"),
                                 isSelected: true),
             OptionCardInfo.init(id: 9,
                                 title: URString(fullText: "가솔린 3.8"),
                                 subTitle: URString(fullText: "구매자의 63%가 선택한"),
                                 priceString: "+ 3,456,789원",
                                 bannerImageURL: mockURL[1])],
            [OptionCardInfo.init(id: 10,
                                 title: URString(fullText: "가솔린 3.8"),
                                 subTitle: URString(fullText: "구매자의 63%가 선택한"),
                                 priceString: "+ 3,456,789원",
                                 bannerImageURL: mockURL[0],
                                 isSelected: true),
             OptionCardInfo.init(id: 11,
                                 title: URString(fullText: "가솔린 3.8"),
                                 subTitle: URString(fullText: "구매자의 63%가 선택한"),
                                 priceString: "+ 3,456,789원",
                                 bannerImageURL: mockURL[4])],
            [OptionCardInfo.init(id: 12,
                                 title: URString(fullText: "가솔린 3.8"),
                                 subTitle: URString(fullText: "구매자의 63%가 선택한"),
                                 priceString: "+ 3,456,789원",
                                 bannerImageURL: mockURL[3],
                                 isSelected: true),
             OptionCardInfo.init(id: 13,
                                 title: URString(fullText: "가솔린 3.8"),
                                 subTitle: URString(fullText: "구매자의 63%가 선택한"),
                                 priceString: "+ 3,456,789원",
                                 bannerImageURL: mockURL[0])],
            [OptionCardInfo.init(id: 14,
                                 title: URString(fullText: "가솔린 3.8"),
                                 subTitle: URString(fullText: "구매자의 63%가 선택한"),
                                 priceString: "+ 0 원",
                                 bannerImageURL: mockURL[1]),
             OptionCardInfo.init(id: 15,
                                 title: URString(fullText: "가솔린 3.8"),
                                 subTitle: URString(fullText: "구매자의 63%가 선택한"),
                                 priceString: "+ 0 원",
                                 bannerImageURL: mockURL[2])]
    ]

}
