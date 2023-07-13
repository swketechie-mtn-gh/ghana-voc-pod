//
//  DigiModule.swift
//  DigiModule
//
//  Created by Ilya Kostyukevich on 22.08.2022.
//

import Foundation
import UIKit

public class DigiModule {
    public static let shared = DigiModule()
    
    private init() { }
    
    public func initialization(urlString: String) {
        guard let url = URL(string: urlString) else {
            fatalError("[DigiModule]: Provide valid url")
        }
        
        UserDefaultsService.scriptName = url.lastPathComponent
        
        var components = URLComponents(url: url, resolvingAgainstBaseURL: false)
        components?.path = ""
        UserDefaultsService.baseUrl = components?.url?.absoluteString
        
        self.updateFile(url: url)
    }
    
    public func show(surveyId: Int,
                     language: String,
                     params: [String: Any]? = nil,
                     margins: Margins? = Margins(),
                     presentationController: UIViewController) {
        
        let model = WebViewModel(surveyId: surveyId, language: language, params: params, margins: margins!)
        let viewController = WebViewController.init(model: model)
        viewController.modalPresentationStyle = .overFullScreen
        presentationController.present(viewController, animated: false)
    }
}

private extension DigiModule {
    func updateFile(url: URL) {
        DataLoader.getFileUpdateDate(url: url) { result in
            switch result {
            case .success(let date):
                if date != UserDefaultsService.fileUpdateDate {
                    DataLoader.downloadFile(url: url) { result in
                        switch result {
                        case .success(_):
                            UserDefaultsService.fileUpdateDate = date
                        case .failure(let error):
                            Log(error.localizedDescription)
                        }
                    }
                }
            case .failure(let error):
                Log(error.localizedDescription)
            }
        }
    }
}
