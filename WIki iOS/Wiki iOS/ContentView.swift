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
	@State var going = false
	@State var pastWordsCased = [String]()
    var body: some View {
		ScrollView{
			ScrollViewReader { value in
		HStack {
			Text("Wiki")
			.font(.largeTitle)
			.bold()
			.padding()
			Spacer()
			
		}
			Spacer()
		TextField("Start", text: $start).padding()
		TextField("End", text: $end).padding()
		Button{
				UIApplication.shared.endEditing()
				output = "\(start) -> \(end)\n"
			
			wick(start: start, end: end, pastWordsCased: $pastWordsCased, output: $output, going:$going).begin()
			
			
		} label:{
			Text("Begin")
		}.padding()
		.disabled(going)
			
		Text(output)
			
			ActivityIndicator(shouldAnimate: $going)
				.onAppear {
					value.scrollTo(pastWordsCased.count - 1, anchor: .center)
				}
			}
	}
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

struct ActivityIndicator: UIViewRepresentable {
	@Binding var shouldAnimate: Bool
	func makeUIView(context: Context) -> UIActivityIndicatorView {
		// Create UIActivityIndicatorView
		return UIActivityIndicatorView()
	}
	
	func updateUIView(_ uiView: UIActivityIndicatorView,
					  context: Context) {
		if self.shouldAnimate {
			uiView.startAnimating()
		} else {
			uiView.stopAnimating()
		}
	}
}
