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

class OutlookService {
    // Configure the OAuth2 framework for Azure
    private static let oauth2Settings = [
        "client_id" : "0b228193-26f2-4837-b791-ffd7eab7441e",
        "authorize_uri": "https://login.microsoftonline.com/common/oauth2/v2.0/authorize",
        "token_uri": "https://login.microsoftonline.com/common/oauth2/v2.0/token",
        "scope": "openid profile offline_access User.Read Mail.Read Calendars.Read Contacts.Read",
        "redirect_uris": ["cenes://oauth2/callback"],
        "verbose": true,
        ] as OAuth2JSON
    
    private static var sharedService: OutlookService = {
        let service = OutlookService()
        return service
    }()
    
    private let oauth2: OAuth2CodeGrant
    
    private init() {
        oauth2 = OAuth2CodeGrant(settings: OutlookService.oauth2Settings)
        oauth2.authConfig.authorizeEmbedded = true
        //oauth2.authConfig.ui.useSafariView = false
        
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
    
    func login(from: AnyObject, callback: @escaping (String?,_ token:String?) -> Void) -> Void {
        oauth2.authorizeEmbedded(from: from) {
            result, error in
            if let unwrappedError = error {
                callback(unwrappedError.description,nil)
            } else {
                if let unwrappedResult = result, let token = unwrappedResult["access_token"] as? String {
                    // Print the access token to debug log
                    //NSLog("Access token: \(token)")
                    callback(nil,token)
                }
            }
        }
    }
    
    func logout() -> Void {
        oauth2.forgetTokens()
    }
    
}
