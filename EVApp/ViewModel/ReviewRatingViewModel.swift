//
//  ReviewRatingViewModel.swift
//  EVApp
//
//  Created by VM on 18/07/24.
//

import Foundation

class ReviewRatingViewModel{
    let stationId: String
    let reviewsRatingsRepo: ReviewRatingRepo
    
    init(stationId: String, reviewsRatingsRepo: ReviewRatingRepo = .init()) {
        self.stationId = stationId
        self.reviewsRatingsRepo = reviewsRatingsRepo
    }
    
    class ReviewsRatingsData: ObservableObject{
        @Published var data: [Comment] = .init()
        
        subscript(index: Int)->Comment{
            data[index]
        }
        
        init(data: [Comment] = []) {
            self.data = data
        }
    }
    
    let reviewsRatingsData: ReviewsRatingsData = .init()
    
    func getAllReviewsRatings(completion: @escaping ()->()){
        
        let requestBody: HttpRequestBody = [
            "stationId": stationId
        ]
        
        reviewsRatingsRepo.getAllRatingReviews(requestBody: requestBody){ [weak self] res in
            switch res{
            case .success(let reviews):
                if let comments = reviews.comment{
                    MainAsyncThread {
                        self?.reviewsRatingsData.data = comments
                    }
                }
            case .failure(let error):
                print(error)
            }
            completion()
        }
    }
    
    
    func writeRatingReview(newRatingComment: CommentWriting, completion: @escaping (String)->()){
        
        let requestBody: HttpRequestBody = [
            "userPk": UserAppStorage.userPk,
            "stationId": stationId,
            "rating": newRatingComment.rating,
            "comment": newRatingComment.comment
        ]
        
        reviewsRatingsRepo.writeRatingReview(requestBody: requestBody){[weak self] res in
            switch res{
            case .success(let statusMessageResponse):
                if let message = statusMessageResponse.message{
                    self?.getAllReviewsRatings {
                        completion(message)
                    }
                }
            case .failure(let error):
                print(error)
                completion("Review Writing Failed")
            }
        }
    }
}
