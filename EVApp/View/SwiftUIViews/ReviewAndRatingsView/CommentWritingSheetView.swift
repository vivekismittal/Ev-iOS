//
//  CommentWritingSheetView.swift
//  EVApp
//
//  Created by VM on 18/07/24.
//

import SwiftUI

struct CommentWritingSheetView: View {
    @State private var commentDesc: String
    let comment: CommentWriting = .init(rating: .init(), comment: .init())
    
    var onSubmit: (CommentWriting)->()

    init(onSubmit: @escaping (CommentWriting) -> Void) {
        commentDesc = comment.comment
        self.onSubmit = onSubmit
    }
    
    var body: some View {
        return VStack{
            Text("Give ratings to charging stations").fontWeight(.semibold)
            VStack(alignment: .leading){
                Color(.systemBackground).frame(height: 0)
                StarRatingsView(rating: comment.rating, outOf: 5){rating in
                    print(rating)
                    comment.rating = rating
                }.frame(width: 240,height: 30)
                Text("Comment").italic().padding(.top,10)
                let textField = TextField(
                    "I am happy to share my feedback",
                    text: $commentDesc
                )
                    .padding(.top,4)
                if #available(iOS 17.0, *){
                    textField.onChange(of: commentDesc) { old, new in
                        comment.comment = commentDesc
                    }
                } else{
                    textField.onChange(
                        of: commentDesc,
                        perform: { value in
                            comment.comment = commentDesc
                        }
                    )
                }
                Rectangle()
                    .frame(height: 1)
                    .foregroundColor(.black)
            }.padding(10)
            SubmitButtonView(comment: comment,onSubmit: onSubmit)
        }
    }
}

struct SubmitButtonView: View{
    @StateObject var comment: CommentWriting
    var onSubmit: (CommentWriting)->()
    
    var body: some View{
        return Button(
            action: {
                guard comment.isAllNotEmpty else { return }
                onSubmit(comment)
            },
            label: {
                Text("Submit").font(.title)
                    .foregroundColor(.white)
                    .padding(.horizontal,100)
                    .padding(.vertical,10)
                    .background(
                        RoundedRectangle(
                            cornerSize: .init(width: 20, height: 20)
                        )
                        .fill(.green.opacity(comment.isAllNotEmpty ? 0.8 : 0.2))
                    )
            }
        )
        .disabled(!comment.isAllNotEmpty)
    }
}
