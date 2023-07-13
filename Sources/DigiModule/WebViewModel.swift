//
//  WebViewModel.swift
//  DigiModule
//
//  Created by Ilya Kostyukevich on 22.08.2022.
//

import Foundation

struct WebViewModel {
    let surveyId: Int
    let language: String
    let params: [String: Any]?
    let margins: Margins
    
    init(surveyId: Int, language: String, params: [String: Any]? = nil, margins: Margins) {
        self.surveyId = surveyId
        self.language = language
        self.params = params
        self.margins = margins
    }
}
