//
//  FacebookUtility.swift
//  QualitySwift
//
//  Created by Eden on 2/1/17.
//  Copyright © 2017 Eden. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import FBSDKCoreKit
import FBSDKShareKit

enum FbResponse {
    case success
    case fail
    case permissionNotGranted
    case cancled
}

enum Permissions {
    
    case write
    case read
    
    var requiredPermissions: Set<String> {
        switch self {
        case .write:
            return Set(["publish_actions"])
        case .read:
            return Set(["public_profile", "email"])
        }
    }
    
    func isRequiredPermissionsGranted() -> Bool {
        
        var granted = true
        requiredPermissions.forEach {
            if (!FacebookUtility.currentToken().hasGranted($0)) {
                granted = false
            }
        }
        return granted
    }
}

struct FacebookUtility {
    
    // MARK: - Private
    
    /// single manager for facebook auth
    private static var loginManager: FBSDKLoginManager = {
        let manager = FBSDKLoginManager()
        return manager
    }()
    
    /// check on facebook token
    private static func isLoggedFacebook() -> Bool {
        return (nil != FBSDKAccessToken.current())
    }
    
    /// check on all required facebook read permissions
    /// list of permission should be provided on Permissions enum
    private static func isReadPermissionsGranted()  -> Bool {
        return Permissions.read.isRequiredPermissionsGranted()
    }
    
    /// check on all required facebook write permissions
    /// list of permission should be provided on Permissions enum
    private static func isWritePermissionsGranted()  -> Bool {
        return Permissions.write.isRequiredPermissionsGranted()
    }
    
    // check on permissions error
    private static func isPermissionsGrantedError(_ error: Error) -> Bool {
        
        guard let userInfo = error._userInfo as? [String: Any],
            let code = userInfo[FBSDKGraphRequestErrorGraphErrorCode] as? Int else { return false }
        
        return code == 200
    }
    
    /// configure the login method
    private static func configureLogin(with fbHandler: (result: FBSDKLoginManagerLoginResult?, error: Error?),
                                       _ completion: @escaping (_ response: FbResponse, _ error: Error?) -> Void) {
        
        let error = fbHandler.error
        let result = fbHandler.result
        
        if nil != error {
            if (isPermissionsGrantedError(error!)) {
                completion(.permissionNotGranted, error!)
            }
            completion(.fail, error!)
        }
        
        if (result?.isCancelled)! {
            completion(.cancled, nil)
        } else {
            completion(.success, nil)
        }
    }
    
    // MARK: - Public
    
    /// facebook fetched token
    static func currentToken() -> FBSDKAccessToken {
        return FBSDKAccessToken.current()
    }
    
    /// login to Facebook, specify the publish or read permissions
    static func login(with permissions: Permissions,
                      from controller: UIViewController,
                      _ completion: @escaping (_ response: FbResponse, _ error: Error?) -> Void) {
        
        let providedPermissions = Array(permissions.requiredPermissions)
        
        switch permissions {
            
        case .read:
            
            if (isLoggedFacebook() && permissions.isRequiredPermissionsGranted()) {
                completion(.success, nil)
            } else {
                
                loginManager.logIn(withReadPermissions: providedPermissions,
                                   from: controller, handler: { (result, error) in
                                    
                                    FacebookUtility.configureLogin(with: (result, error), completion)
                })
            }
            
        case .write:
            loginManager.logIn(withPublishPermissions: providedPermissions,
                               from: controller, handler: { (result, error) in
                                
                                FacebookUtility.configureLogin(with: (result, error), completion)
            })
        }
    }
    
    /// logout from Facebook
    static func logout() {
        if (isLoggedFacebook()) {
            loginManager.logOut()
        }
    }
    
    // MARK: - share
    
    /// specify FacebookSharerUtilityDelegate for sharing progress in controller
    static func share(from controller: UIViewController,
                      shareInfo: [String: Any],
                      _ completion:@escaping((_ error: Error?) -> Void)) {
        
        if FacebookUtility.isLoggedFacebook() {
            FacebookUtility.startSharing(from: controller, shareInfo: shareInfo)
        } else {
            FacebookUtility.login(with: .read, from: controller, { (fbResponse, error) in
                
                switch fbResponse {
                case .success:
                    FacebookUtility.startSharing(from: controller, shareInfo: shareInfo)
                    
                case .fail: completion(error)
                case .permissionNotGranted:
                    
                    // make logout to fetch new permissions
                    FacebookUtility.logout()
                    completion(error)
                    
                case .cancled: completion(nil)
                }
            })
        }
    }
    
    /// start sharing link with info
  private static func startSharing(from controller: UIViewController, shareInfo: [String: Any]) {
        
        guard let shareURLString = shareInfo["url"] as? String else { return }
        
        let shareLinkContent: FBSDKShareLinkContent = FBSDKShareLinkContent()
        let shareURL = URL(string: shareURLString)
        
        shareLinkContent.contentURL = shareURL
        
        FacebookSharer.sharedInstance.delegate = controller as? FacebookSharerUtilityDelegate
        
        FBSDKShareDialog.show(from: controller, with: shareLinkContent, delegate: FacebookSharer.sharedInstance)
    }
}

protocol FacebookSharerUtilityDelegate {
    func facebookShareUtilityDidCompleteShare(_ results:[AnyHashable : Any])
    func facebookShareUtilityDidFail(_ error:Error)
    func facebookShareDidCancel()
}

fileprivate class FacebookSharer: NSObject, FBSDKSharingDelegate {
    
    var delegate: FacebookSharerUtilityDelegate?
    
    static let sharedInstance = FacebookSharer()
    
    func sharer(_ sharer: FBSDKSharing!, didCompleteWithResults results: [AnyHashable : Any]!) {
        
        guard let delegate = delegate else { return }
        delegate.facebookShareUtilityDidCompleteShare(results)
    }
    
    func sharer(_ sharer: FBSDKSharing!, didFailWithError error: Error!) {
        
        guard let delegate = delegate else { return }
        delegate.facebookShareUtilityDidFail(error)
    }
    
    func sharerDidCancel(_ sharer: FBSDKSharing!) {
        
        guard let delegate = delegate else { return }
        delegate.facebookShareDidCancel()
    }
}
