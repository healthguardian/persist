//
//  String+Localized.swift
//  ForceFit
//
//  Created by Vasyl Khmil on 9/12/17.
//  Copyright © 2017 HealthGuardian. All rights reserved.
//

import Foundation

extension String {
    var localized: String {
        return NSLocalizedString(self, tableName: nil, bundle: Bundle.main, value: "", comment: "")
    }
}
