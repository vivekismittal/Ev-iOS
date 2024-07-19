//
//  CommentWriting.swift
//  EVApp
//
//  Created by VM on 18/07/24.
//

import Foundation

class CommentWriting: ObservableObject{
  @Published var rating: Int
  @Published var comment: String
    
    init( rating: Int, comment: String) {
        self.rating = rating
        self.comment = comment
    }
    
    var isAllNotEmpty: Bool {
        rating > 0 && !comment.isEmpty
    }
}
