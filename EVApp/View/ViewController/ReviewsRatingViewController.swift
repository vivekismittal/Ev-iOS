//
//  ReviewsRatingViewController.swift
//  EVApp
//
//  Created by VM on 18/07/24.
//

import UIKit

class ReviewsRatingViewController: UIViewController{
    
    @IBOutlet weak var reviewRatingView: UIView!
    
    private var reviewRatingViewModel: ReviewRatingViewModel!
    
    static func instantiateFromStoryboard(for stationId: String) -> Self {
        let vc = ViewControllerFactory<Self>.viewController(for: .ChargingStationReviewsScreen)
        vc.reviewRatingViewModel = .init(stationId: stationId)
        return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addReviewRatingScreenView()
        fetchAllReview()
    }
    
    func addReviewRatingScreenView(){
        ReviewRatingScreenView(
            reviewsList: self.reviewRatingViewModel.reviewsRatingsData,
            onSubmit: writeRatingComment
        ).addViewTo(
            superView: reviewRatingView
        )
    }
    
    func writeRatingComment(newRatingComment: CommentWriting){
        reviewRatingViewModel.writeRatingReview(newRatingComment: newRatingComment) { [weak self] message in
            MainAsyncThread {
                self?.showAlert(title: "", message: message)
            }
        }
    }
    
    @IBAction func onBack(_ sender: Any) {
        goBack()
    }
    
    private func fetchAllReview(){
        
        showSpinner(onView: view)
        
        reviewRatingViewModel.getAllReviewsRatings{[weak self] in
            self?.removeSpinner()
        }

    }
    
}
