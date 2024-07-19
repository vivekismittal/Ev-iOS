//
//  ReviewRatingRepo.swift
//  EVApp
//
//  Created by VM on 19/07/24.
//

import Foundation

class ReviewRatingRepo{
    
    func getAllRatingReviews(requestBody: HttpRequestBody, completion: @escaping ResultHandler<ReviewRatingsModel>){
        
        NewNetworkManager.shared.request(endPointType: .getChargingStationRatingsReviews(requestBody), modelType: ReviewRatingsModel.self, completion: completion)
    }
    
    func writeRatingReview(requestBody: HttpRequestBody, completion: @escaping ResultHandler<StatusMessageResponse>){
        print(requestBody)
        
        NewNetworkManager.shared.request(endPointType: .writeChargingStationRatingReview(requestBody), modelType: StatusMessageResponse.self, completion: completion)
    }
}
