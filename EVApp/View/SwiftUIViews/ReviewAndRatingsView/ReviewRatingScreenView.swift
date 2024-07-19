//
//  ReviewRatingScreenView.swift
//  EVApp
//
//  Created by VM on 18/07/24.
//

import SwiftUI

struct ReviewRatingScreenView: View {
    
    @StateObject var reviewsList: ReviewRatingViewModel.ReviewsRatingsData

    @State private var shouldWritingReviewSheetAppear: Bool = false
    
    var onSubmit: (CommentWriting)->()

    
    
    var body: some View {
        print("count:: \(reviewsList.data.count)")
        return ZStack(alignment: .bottomTrailing){
            ScrollView{
                LazyVStack{
                    ForEach(0..<reviewsList.data.count, id: \.self){ index in
                        CommentRatingView(
                            ratingComment: reviewsList[index])
                        .frame(maxWidth: .infinity)
                        .cornerRadius(10)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 4)
                    }
                }
            }
            
            Image("add_review_icon").resizable().frame(width: 60,height: 60).padding(.horizontal).onTapGesture {
                shouldWritingReviewSheetAppear = true
            }
            
        }.sheet(isPresented: $shouldWritingReviewSheetAppear){
            let view = CommentWritingSheetView{comment in
                shouldWritingReviewSheetAppear = false
                onSubmit(comment)
            }
            
            if #available(iOS 16.0, *){
                let view = view.presentationDetents([.fraction(0.4)])
                
                if #available(iOS 16.4, *) {
                    view.presentationBackground(.ultraThinMaterial).presentationCornerRadius(20)
                } else{
                    view
                }
            } else {
                view
            }
        }
    }
}

#Preview {
    ReviewRatingScreenView(
        reviewsList: ReviewRatingViewModel.ReviewsRatingsData(
            data: .init(
                repeating: .init(
                    firstName: "Vivek Mittal",
                    rating: 3,
                    comment: "Very Nice Charger"
                ),
                count: 20
            )
        )) { comment in
            print("comment Submitted")

        }
}

