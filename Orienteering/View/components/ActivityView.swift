//
//  ActivityView.swift
//  Orienteering
//
//  Created by Kit Fan Cheung on 25/6/2023.
//

import SwiftUI
import GameKit

struct ActivityView: View {
    @Binding var item: CheckpointInfo
    
    var body: some View {
        switch item.format {
        case "quiz":
            return AnyView(QuizView(item: $item))
        case "image_recognition":
            return AnyView(ImageView(item: $item))
        case "integer_input_field":
            return AnyView(NumberInputView(item: $item))
        default:
            return AnyView(ErrorView())
        }
    }
}

//struct ActivityView_Previews: PreviewProvider {
//    static var previews: some View {
//        ActivityView()
//    }
//}
