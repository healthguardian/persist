//
//  StripeManager.swift
//  ForceFit
//
//  Created by Eden on 19.08.17.
//  Copyright © 2017 HealthGuardian. All rights reserved.
//

import Foundation
import Stripe

class StripeManager {
    static let sharedInstance = StripeManager()
    
    func createToken(with card: Card, completion: @escaping (String?, Error?) -> ()) {
        let cardParams = STPCardParams()
        cardParams.number = card.number
        cardParams.expMonth = UInt(card.month)!
        cardParams.expYear = UInt(card.year)!
        cardParams.name = card.name
        
        STPAPIClient.shared().createToken(withCard: cardParams) { (token, error) in
            guard token != nil else {
                completion(nil, error)
                return
            }
            
            completion(token!.tokenId, nil)
        }
    }
}
