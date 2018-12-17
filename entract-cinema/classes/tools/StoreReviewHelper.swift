//
//  StoreReviewHelper.swift
//  entract-cinema
//
//  Created by Damien Lheuillier on 12/11/2018.
//  Copyright © 2018 Damien Lheuillier. All rights reserved.
//

import Foundation
import StoreKit

struct StoreReviewHelper {

    static func checkAndAskForReview() {
        
        if UserDefaults.standard.object(forKey: Constants.compteurOuverture) == nil {
            UserDefaults.standard.set(1, forKey: Constants.compteurOuverture)
        } else {
            var compteur = UserDefaults.standard.integer(forKey: Constants.compteurOuverture)
            compteur = compteur + 1
            UserDefaults.standard.set(compteur, forKey: Constants.compteurOuverture)
            
            switch compteur {
            case 25, 50:
                StoreReviewHelper().requestReview()
            case _ where compteur%250 == 0 :
                StoreReviewHelper().requestReview()
            default:
                print("App run count is : \(compteur)")
                break;
            }
        }
    }
    fileprivate func requestReview() {
        if #available(iOS 10.3, *) {
            SKStoreReviewController.requestReview()
        }
    }
}
