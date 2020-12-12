//
//  ContentView.swift
//  Shared
//
//  Created by Jacob Tepperman on 2020-12-12.
//

import SwiftUI

struct ContentView: View {
	@State var output = ""
	@State var start = ""
	@State var end = ""
    var body: some View {
		Text("Wiki")
			.font(.largeTitle)
			.bold()
			.padding()
		TextField("Start", text: $start).padding()
		TextField("End", text: $end).padding()
		Button{
				UIApplication.shared.endEditing()
				output = "\(start) -> \(end)\n"
				wick(start: start, end: end, output: $output).begin()
			
		} label:{
			Text("Begin")
		}.padding()
		Text(output)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

extension UIApplication {
	func endEditing() {
		sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
	}
}
