//
//  StarRatingsView.swift
//  EVApp
//
//  Created by VM on 18/07/24.
//

import SwiftUI


struct StarRatingsView: View{
    var onRatingChange: ((Int)->())? = nil
    @State var rating: Int
    var outOf: Int
    
    init(rating: Int, outOf: Int, onRatingChange: ((Int) -> Void)? = nil) {
        self.onRatingChange = onRatingChange
        self.rating = rating
        self.outOf = outOf
    }
    
    private func getStarState(index: Int)->StarState {
        index < rating ? .filledStar : .unFilledStar
    }
    
    var body: some View{
        HStack{
            ForEach(0..<outOf, id: \.self){index in
                Image(getStarState(index: index).rawValue).resizable().onTapGesture {
                    if let onRatingChange{
                        rating = index + 1
                        onRatingChange(rating)
                    }
                }
            }
        }
    }
    
    private enum StarState: String{
        case filledStar
        case unFilledStar
    }
}

