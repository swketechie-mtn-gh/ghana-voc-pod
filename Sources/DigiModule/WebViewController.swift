//
//  WebViewController.swift
//  DigiModule
//
//  Created by Ilya Kostyukevich on 22.08.2022.
//

import UIKit
import WebKit

public struct Margins {
    let top: CGFloat
    let right: CGFloat
    let left: CGFloat
    let bottom: CGFloat
    
    let cornerRadius: CGFloat
    
    public init(top: CGFloat = 10, right: CGFloat = 10, left: CGFloat = 10, bottom: CGFloat = 10, cornerRadius: CGFloat = 8) {
        self.top = top
        self.right = right
        self.left = left
        self.bottom = bottom
        
        self.cornerRadius = cornerRadius
    }
}

final class WebViewController: BaseViewController {
    private var model: WebViewModel
    private var webView = WKWebView(frame: .zero)
    private let closeCallbackName = "closeCallbackHandler"
    private let shownCallbackName = "shownCallbackHandler"
    private let initialResponseCallbackName = "initialResponseCallbackHandler"
    private lazy var activityIndicator: UIActivityIndicatorView = {
        var indicator = UIActivityIndicatorView(style: .gray)

        if #available(iOS 13.0, *) {
            indicator = UIActivityIndicatorView(style: .medium)
        }

        indicator.hidesWhenStopped = true
        indicator.color = .gray

        self.view.addSubview(indicator)

        indicator.centerX(to: webView.layoutMarginsGuide.centerXAnchor)
        indicator.centerY(to: webView.layoutMarginsGuide.centerYAnchor)

        return indicator
    }()
    
    required init(model: WebViewModel) {
        self.model = model
        super.init(loadType: .programmatically)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let contentController = WKUserContentController()
        contentController.add(self, name: self.closeCallbackName)
        contentController.add(self, name: self.shownCallbackName)
        contentController.add(self, name: self.initialResponseCallbackName)
        
        let configuration = WKWebViewConfiguration()
        configuration.userContentController = contentController

        self.webView = WKWebView(frame: self.view.frame, configuration: configuration)
        self.webView.uiDelegate = self
        self.webView.navigationDelegate = self
        
        self.view.addSubview(self.webView)

        self.webView.pinTop(to: view.layoutMarginsGuide.topAnchor, offset: model.margins.top)
        self.webView.pinBottom(to: view.layoutMarginsGuide.bottomAnchor, offset: -model.margins.bottom)
        self.webView.pinLeft(to: view.leadingAnchor, offset: model.margins.left)
        self.webView.pinRight(to: view.trailingAnchor, offset: -model.margins.right)
        if #available(iOS 16.4, *) {
            self.webView.isInspectable = true
        }
        
        #if SWIFT_PACKAGE
        self.webView.loadHTMLString(self.modifyHTMLFile(), baseURL: Bundle.module.bundleURL)
        #else
        self.webView.loadHTMLString(self.modifyHTMLFile(), baseURL: Bundle.main.bundleURL)
        #endif
        
        self.view.backgroundColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.2)
        
        self.webView.layer.opacity = 0
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self.webView.layer.masksToBounds = true
        self.webView.layer.cornerRadius = model.margins.cornerRadius
    }
}

private extension WebViewController {
    func modifyHTMLFile() -> String {
        #if SWIFT_PACKAGE
            let filePath = Bundle.module.path(forResource: "digi_page", ofType: "html")
        #else
            let frameworkBundle = Bundle(for: WebViewController.self)
            let bundleURL = frameworkBundle.resourceURL?.appendingPathComponent("DigiModule.bundle")
            let resourceBundle = Bundle(url: bundleURL!)
            let filePath = resourceBundle?.path(forResource: "digi_page", ofType: "html")
        #endif
        
        guard let filePath = filePath,
              let contentData = FileManager.default.contents(atPath: filePath),
              let baseUrl = UserDefaultsService.baseUrl,
              let scriptName = UserDefaultsService.scriptName,
              let documentsUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first,
              let emailTemplate = String(data: contentData, encoding: .utf8) else {
            Log("Could not find file")
            return ""
        }
        var params: [String : Any] = ["apiUrl": baseUrl,
                                      "surveyId": model.surveyId,
                                      "language": model.language,
                                      "full_screen": true]
        
        if let dict = model.params {
            params.merge(dict: dict)
        }
        
        var components = URLComponents()
        components.queryItems = params.map {
            URLQueryItem(name: $0, value: String(describing: $1))
        }
        
        guard let pathString = components.url?.absoluteString else {
            Log("Could not create path components")
            return ""
        }
        
        let destinationUrl = documentsUrl.appendingPathComponent(scriptName)
        let jsUrl = destinationUrl.absoluteString + pathString
        
        Log("Script path: \(jsUrl)")
        
        return emailTemplate.replacingOccurrences(of: "%@", with: jsUrl)
    }
}

extension WebViewController: WKUIDelegate, WKNavigationDelegate, WKScriptMessageHandler {
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        self.activityIndicator.isHidden = false
        self.activityIndicator.startAnimating()
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        Log("DidFinish WebView: \(webView.debugDescription)")
    }
    
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        if message.name == self.closeCallbackName {
            self.dismiss(animated: false)
        } else if message.name == self.shownCallbackName {
            self.activityIndicator.stopAnimating()
            
            UIView.animate(withDuration: 0.05, delay: 0.0, options: .curveEaseInOut, animations: {
                self.webView.layer.opacity = 1
            }, completion:nil)
        } else if message.name == self.initialResponseCallbackName {
            Log(message.body)
            
            if let initialResponseDict = message.body as? Dictionary<String, Any>,
               let status = initialResponseDict["status"] as? Int,
               status != 200,
               let response = initialResponseDict["response"] as? Dictionary<String, Any>,
               let error = response["error"] as? String {
                let initialResponse = InitialError(status: status,
                                                   error: error)

                self.dismiss(animated: true) {
                    self.model.completion?(.failure(initialResponse))
                }
                
            } else {
                model.completion?(.success(()))
            }
        }
    }
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        Log(error.localizedDescription)
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        Log(error.localizedDescription)
    }
}
