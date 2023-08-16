//
//  CarMakingViewModel.swift
//  iOS_H3
//
//  Created by  sangyeon on 2023/08/15.
//

import Foundation
import Combine

final class CarMakingViewModel {

    // MARK: - Input

    struct Input {
        var viewDidLoad: PassthroughSubject<Void, Never>
        var carMakingStepDidChanged: CurrentValueSubject<CarMakingStep, Never>
    }

    // MARK: - Output

    struct Output {
        var estimateSummary = PassthroughSubject<EstimateSummary, Never>()
        var currentStepInfo = CurrentValueSubject<CarMakingStepInfo, Never>(CarMakingStepInfo(step: .powertrain))
        var showIndicator = PassthroughSubject<Bool, Never>()
    }

    // MARK: - Properties

    private var cancellables = Set<AnyCancellable>()

    // MARK: - Helpers

    func transform(_ input: Input) -> Output {
        let output = Output()

        input.viewDidLoad
            .sink(receiveValue: { _ in
                // usecase에 디폴트값 데이터 요청
                let tempSummary = EstimateSummary(elements: [])
                output.estimateSummary.send(tempSummary)
            })
            .store(in: &cancellables)

        input.carMakingStepDidChanged
            .sink(receiveValue: { step in
                // usecase에 데이터 요청. ex) usecase.getStepInfo(of: stepIndex)
                // 전달된 옵션들 중 디폴트로 선택된 옵션의 isSelected 값 수정해서 전달
                // 그러기 위해선 viewDidLoad 시점에 받은 견적요약 데이터 저장해놓고 수정하기? 근데 이건 usecase에서 해야할 거 같기도

                let stepIndex = step.rawValue
                let carMakingStepInfo = CarMakingStepInfo(
                    step: step,
                    bannerImageURL: CarMakingMockData.mockURL[stepIndex],
                    optionCardInfoArray: CarMakingMockData.mockOption[stepIndex]
                )
                output.currentStepInfo.send(carMakingStepInfo)
            })
            .store(in: &cancellables)

        return output
    }
}

struct CarMakingMockData {
    static let mockURL = [
        "https://cdn.autotribune.co.kr/news/photo/202101/4849_30727_3533.jpg",
         // swiftlint:disable:next line_length
         "https://i.namu.wiki/i/cBMX6XiTLltPPIawbb2zfP5Oy5RW9JybY0E5ZQ62oUYdppA2t54xDjiST7xfLe_2dL4pGN9VsBVknq4H-SYA2A.webp",
         "https://cdn.epnc.co.kr/news/photo/201804/79474_70575_4841.jpg",
         "https://pimg.daara.co.kr/kidd/photo/2021/01/08/thumbs/thumb_520390_1610089982_79.jpg",
        "https://pimg.daara.co.kr/kidd/photo/2021/01/08/thumbs/thumb_520390_1610089971_11.jpg",
         "https://itimg.chosun.com/sitedata/image/202112/03/2021120301496_0.jpg",
         "https://www.hyundai-wia.com/img/business/auto_engine_detail_img_5.jpg",
         "https://www.hyundai-wia.com/img/business/auto_engine_detail_img_5.jpg",
         "https://www.hyundai-wia.com/img/business/auto_engine_detail_img_5.jpg"
    ].map { URL(string: $0) }

    static let mockOption = [
            [OptionCardInfo.init(title: "디젤 2.2",
                                 subTitle: "구매자의 63%가 선택한",
                                 priceString: "+ 3,456,789원",
                                 isSelected: true),
             OptionCardInfo.init(title: "가솔린 3.8",
                                 subTitle: "구매자의 37%가 선택한",
                                 priceString: "+ 3,456,789원")],
            [OptionCardInfo.init(title: "2WD",
                                 subTitle: "구매자의 72%가 선택한",
                                 priceString: "+ 3,456,789원",
                                 isSelected: true),
             OptionCardInfo.init(title: "4WD",
                                 subTitle: "구매자의 82%가 선택한",
                                 priceString: "+ 3,456,789원")],
            [OptionCardInfo.init(title: "7인승",
                                 subTitle: "구매자의 63%가 선택한",
                                 priceString: "+ 3,456,789원",
                                 isSelected: true),
             OptionCardInfo.init(title: "8인승",
                                 subTitle: "구매자의 63%가 선택한",
                                 priceString: "+ 3,456,789원")],
            [OptionCardInfo.init(title: "크리미 화이트 펄",
                                 subTitle: "구매자의 88%가 선택한",
                                 priceString: "+ 3,456,789원",
                                 color: URColor(red: 0, green: 0, blue: 0),
                                 isSelected: true),
             OptionCardInfo.init(title: "LK-99 3.8",
                                 subTitle: "구매자의 12%가 선택한",
                                 priceString: "+ 3,456,789원")],
            [OptionCardInfo.init(title: "가솔린 3.8",
                                 subTitle: "구매자의 63%가 선택한",
                                 priceString: "+ 3,456,789원",
                                 // swiftlint:disable:next line_length
                                 image: URL(string: "https://github.com/sangyeon3/kakao_pathfinder_assignment/assets/68235938/fe0d0580-f5b2-47fe-80ff-bab37e6f4815"),
                                 isSelected: true),
             OptionCardInfo.init(title: "가솔린 3.8",
                                 subTitle: "구매자의 63%가 선택한",
                                 priceString: "+ 3,456,789원")],
            [OptionCardInfo.init(title: "가솔린 3.8",
                                 subTitle: "구매자의 63%가 선택한",
                                 priceString: "+ 3,456,789원",
                                 isSelected: true),
             OptionCardInfo.init(title: "가솔린 3.8",
                                 subTitle: "구매자의 63%가 선택한",
                                 priceString: "+ 3,456,789원")],
            [OptionCardInfo.init(title: "가솔린 3.8",
                                 subTitle: "구매자의 63%가 선택한",
                                 priceString: "+ 3,456,789원",
                                 isSelected: true),
             OptionCardInfo.init(title: "가솔린 3.8",
                                 subTitle: "구매자의 63%가 선택한",
                                 priceString: "+ 3,456,789원")],
            [OptionCardInfo.init(title: "가솔린 3.8",
                                 subTitle: "구매자의 63%가 선택한",
                                 priceString: "+ 0 원",
                                 isSelected: true),
             OptionCardInfo.init(title: "가솔린 3.8",
                                 subTitle: "구매자의 63%가 선택한",
                                 priceString: "+ 0 원")]
    ]
}
