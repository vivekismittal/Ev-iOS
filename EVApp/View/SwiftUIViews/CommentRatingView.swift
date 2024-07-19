//
//  ReviewsRatingsView.swift
//  EVApp
//
//  Created by VM on 17/07/24.
//

import SwiftUI

struct CommentRatingView: View {
    
    let ratingComment: Comment
    
    var body: some View {
        return ZStack(alignment: .leading){
            Color(.systemGray).opacity(0.5)
            VStack(alignment: .leading){
                StarRatingsView(rating: ratingComment.roundedRating, outOf: 5).frame(width: 160,height: 20)
                Text(
                    (ratingComment.comment ?? "NA")
                        .trimmingCharacters(
                            in: .whitespacesAndNewlines
                        )
                )
                .foregroundColor(.black).lineLimit(nil)
                HStack{
                    Image("profileImg").resizable().frame(width: 40,height: 40)
                    Text(ratingComment.firstName ?? "NA").foregroundColor(.black).fontWeight(.semibold)
                }
            }.padding()
        }
    }
}

#Preview {
    CommentRatingView(ratingComment: .init(firstName: "Vivek Mittal", rating: 1.9, comment: "Very niceVery niceVery niceVery niceVery niceVery niceVery nice"))
}
