//
//  ErrorView.swift
//  Orienteering
//
//  Created by Kit Fan Cheung on 25/6/2023.
//

import SwiftUI

struct ErrorView: View {
    var body: some View {
        VStack {
            Text("There is a technical issue with this checkpoint.")
                .font(.headline)
                .multilineTextAlignment(.center)
                .padding()
            Text("Please contact the staff for help.")
                .font(.subheadline)
                .multilineTextAlignment(.center)
                .padding(.bottom)
        }
    }
}

struct ErrorView_Previews: PreviewProvider {
    static var previews: some View {
        ErrorView()
    }
}
