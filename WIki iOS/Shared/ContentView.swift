//
//  ContentView.swift
//  Shared
//
//  Created by Jacob Tepperman on 2020-12-12.
//

import SwiftUI

struct ContentView: View {
	@State var output = ""
	@State var going = false
	@State var start = ""
	@State var end = ""
    var body: some View {
		TextField("Start", text: $start).padding()
		TextField("End", text: $end).padding()
		Button{
			if going {
				going = false;
				output = "\(start) -> \(end)"
			} else {
				going = true
				wick(start: start, end: end, output: $output).begin()
			}
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
