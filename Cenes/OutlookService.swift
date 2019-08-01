//
//  OutlookService.swift
//  swift-tutorial
//
//  Created by Jason Johnston on 4/3/17.
//  Copyright © 2017 Microsoft. All rights reserved.
//  Licensed under the MIT license. See LICENSE.txt in the project root for license information.
//

import Foundation
import p2_OAuth2
import SwiftyJSON

class OutlookService {
    // Configure the OAuth2 framework for Azure
    private static let oauth2Settings = [
        "client_id" : "063c17ad-741e-4c0c-aa11-e7ce6949d6c7",
        "authorize_uri": "https://login.microsoftonline.com/common/oauth2/v2.0/authorize",
        "token_uri": "https://login.microsoftonline.com/common/oauth2/v2.0/token",
        "scope": "openid profile offline_access User.Read Mail.Read Calendars.Read Contacts.Read",
        //"scope": "openid profile offline_access https://outlook.office.com/user.read https://outlook.office.com/mail.read https://outlook.office.com/calendars.read https://outlook.office.com/calendars.readwrite",
        "redirect_uris": ["cenesbeta://oauth2/callback"],
        "verbose": true,
        ] as OAuth2JSON
    
    private var userEmail: String!;

    private static var sharedService: OutlookService = {
        let service = OutlookService()
        return service
    }()
    
    private let oauth2: OAuth2CodeGrant
    
    private init() {
        oauth2 = OAuth2CodeGrant(settings: OutlookService.oauth2Settings)
        oauth2.authConfig.authorizeEmbedded = true
        //oauth2.authConfig.ui.useSafariView = false
        userEmail = ""
    }
    
    class func shared() -> OutlookService {
        return sharedService
    }
    
    var isLoggedIn: Bool {
        get {
            return oauth2.hasUnexpiredAccessToken() || oauth2.refreshToken != nil
        }
    }
    
    
    var getToken : String{
        get {
            return oauth2.accessToken!
        }
    }
    
    
    func handleOAuthCallback(url: URL) -> Void {
        oauth2.handleRedirectURL(url)
    }
    
    func login(from: AnyObject, callback: @escaping (String?,_ token:String?, _ refreshToken:String?) -> Void) -> Void {
        oauth2.authorizeEmbedded(from: from) {
            result, error in
            if let unwrappedError = error {
                callback(unwrappedError.description,nil, nil)
            } else {
                if let unwrappedResult = result, let token = unwrappedResult["access_token"] as? String {
                    let refreshToken = unwrappedResult["refresh_token"] as? String
                    // Print the access token to debug log
                    //NSLog("Access token: \(token)")
                    callback(nil,token, refreshToken)
                }
            }
        }
    }
    
    func makeApiCall(api: String, params: [String: String]? = nil, callback: @escaping (JSON?) -> Void) -> Void {
        // Build the request URL
        var urlBuilder = URLComponents(string: "https://graph.microsoft.com")!
        urlBuilder.path = api
        
        if let unwrappedParams = params {
            // Add query parameters to URL
            urlBuilder.queryItems = [URLQueryItem]()
            for (paramName, paramValue) in unwrappedParams {
                urlBuilder.queryItems?.append(
                    URLQueryItem(name: paramName, value: paramValue))
            }
        }
        
        let apiUrl = urlBuilder.url!
        NSLog("Making request to \(apiUrl)")
        
        var req = oauth2.request(forURL: apiUrl)
        req.addValue("application/json", forHTTPHeaderField: "Accept")
        
        let loader = OAuth2DataLoader(oauth2: oauth2)
        
        // Uncomment this line to get verbose request/response info in
        // Xcode output window
        //loader.logger = OAuth2DebugLogger(.trace)
        
        loader.perform(request: req) {
            response in
            do {
                let dict = try response.responseJSON()
                DispatchQueue.main.async {
                    let result = JSON(dict)
                    callback(result)
                }
            }
            catch let error {
                DispatchQueue.main.async {
                    let result = JSON(error)
                    callback(result)
                }
            }
        }
    }
    
    
    func getUserEmail(callback: @escaping (String?) -> Void) -> Void {
        // If we don't have the user's email, get it from
        // the API
        if (userEmail.isEmpty) {
            makeApiCall(api: "/v1.0/me") {
                result in
                if let unwrappedResult = result {
                    var email = unwrappedResult["mail"].stringValue
                    if (email.isEmpty) {
                        // Fallback to userPrincipalName ONLY if mail is empty
                        email = unwrappedResult["userPrincipalName"].stringValue
                    }
                    self.userEmail = email
                    callback(email)
                } else {
                    callback(nil)
                }
            }
        } else {
            callback(userEmail)
        }
    }
    
    func logout() -> Void {
        oauth2.forgetTokens()
    }
    
}
