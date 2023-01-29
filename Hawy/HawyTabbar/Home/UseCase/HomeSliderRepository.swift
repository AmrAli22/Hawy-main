//
//  HomeSliderRepository.swift
//  Hawy
//
//  Created by ahmed abu elregal on 07/09/2022.
//

import Foundation
import Combine

protocol HomeSliderAPIProtocol {
    func homeSlider() -> AnyPublisher<SliderModel?, APIError>
}

class HomeSliderAPI: BaseAPIService<HomeNetwork>, HomeSliderAPIProtocol {
    
    func homeSlider() -> AnyPublisher<SliderModel?, APIError> {
        FetchData(target: .sliders, responseClass: SliderModel.self)
    }
    
}
