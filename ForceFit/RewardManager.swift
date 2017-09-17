//
//  RewardManager.swift
//  ForceFit
//
//  Created by Vasyl Khmil on 9/17/17.
//  Copyright © 2017 HealthGuardian. All rights reserved.
//

import Foundation
import ObjectMapper
import SwiftDate

class RewardManager {
    static let shared = RewardManager()
    
    func calculateReward() {
        FirebaseManager.shared.currentUser {
            
            
            guard   let lastVerified = $0?["last_verified"] as? Double,
                    let penalty = $0?["penalty_value"] as? Int,
                    let paymentActive = $0?["payment_active"] as? Bool,
                    let exercisesCount = $0?["number_of_exercises"] as? Int,
                    let token = $0?["stripe_token"] as? String else {
                return
            }

            let reward = $0?["reward"] as? Double ?? 0.0
            
            guard paymentActive else { return }
            
            guard let verifiedDate = DateTransform().transformFromJSON(lastVerified) else { return }
            
            let currentCheckingDate = verifiedDate + 1.hour
            
            if currentCheckingDate.endWeek >= Date().endWeek {
                return
            }
            
            WorkoutsManager.shared.fetchWorkouts(from: currentCheckingDate.startWeek, to: currentCheckingDate.endWeek) {
                
                if $0.count >= exercisesCount {
                    let newReward = reward + ForceFitCalculator.calculateWeeklyReward(penalty: penalty)
                    FirebaseManager.shared.currentUserReference()?.child("reward").setValue(newReward)
                }
                else {
                    let urlString = "https://force-fit.nerdzlab.com/payment.php"
                    if let url = URL(string: urlString) {
                        var request = URLRequest(url: url)
                        request.httpMethod = "POST"
                        let params: [String : Any] = ["stripeToken": token,
                                                      "amount": (exercisesCount - $0.count) * penalty,
                                                      "currency": "usd",
                                                      "description": ""] as [String : Any]
                        
                        request.httpBody = try? JSONSerialization.data(withJSONObject: params)
                        
                        URLSession.shared.dataTask(with: request) {
                            (data, response, error) in
                            
                            if let httpResponse = response as? HTTPURLResponse {
                                if httpResponse.statusCode == 200 {
                                    FirebaseManager.shared.currentUserReference()?.child("last_verified").setValue(DateTransform().transformToJSON(currentCheckingDate.endWeek))
                                    
                                    self.calculateReward()
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
