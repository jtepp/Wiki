//
//  methods.swift
//  wiki
//
//  Created by Jacob Tepperman on 2020-12-11.
//

import Foundation
import NaturalLanguage
import SwiftUI

//#########################
//let start = CommandLine.arguments[1]
//let end = CommandLine.arguments[2]
//#########################

//print("Starting from \(start)")
//print("Path from \(start) -> \(end) in \(pastWords.count) steps:\n> "+pastWordsCased.joined(separator: "\n> "))

func getHTML(word:String) -> String{
	do	{
		let html = try String(contentsOf: URL(string: "https://wikipedia.org/wiki/\(friendly(s: unprep(w:word)))")!)
		
		let h = html.components(separatedBy: #"id="bodyContent""#)[1].components(separatedBy: #"mw-data-after-content"#)[0]
		
		return h
	} catch let error {
		return "\(error.localizedDescription)"
	}
	
}


func friendly(s:String) -> String {
	var q = s.replacingOccurrences(of: " ", with: "")
	q = q.replacingOccurrences(of: "?", with: "")
	q = q.replacingOccurrences(of: "&", with: "")
	q = q.replacingOccurrences(of: "/", with: "")
	return q
}

func matches(for regex: String, in text: String) -> [String] {
	
	do {
		let regex = try NSRegularExpression(pattern: regex)
		let results = regex.matches(in: text,
									range: NSRange(text.startIndex..., in: text))
		return results.map {
			String(text[Range($0.range, in: text)!])
		}
	} catch let error {
		print("invalid regex: \(error.localizedDescription)")
		return []
	}
}



func prep(w:String) -> String {
	return w.replacingOccurrences(of:"_", with: " ").replacingOccurrences(of:"\"", with: "").replacingOccurrences(of:"/wiki/", with: "")
}


func unprep(w:String) -> String {
	return w.replacingOccurrences(of:" ", with: "_")
}

struct wick {
	let e = NLEmbedding.sentenceEmbedding(for: .english)!
	let start: String
	let end: String
	@Binding var pastWordsCased: [String]
	@Binding var output: String
	@Binding var going: Bool
	func begin(){
		going = true
		DispatchQueue.global(qos: .background).async {

		var currentWord = start
		var pastWords = [start.lowercased()]
		pastWordsCased = [start]
		print("\(start) -> \(end)")
		while currentWord.lowercased() != end.lowercased()  {
			
//			print("iteration")
			let links = matches(for: "/wiki/((?!File:)(?![A-Za-z]+:[A-Za-z]).+?)\"", in: getHTML(word:currentWord))
			var similarity = 2.0
			var guess = false
			var best = ""
			
			(0..<(links.count > 100 ? 100: links.count)).forEach{ i in
				let keyWord = prep(w:links[i])
				
				let d = e.distance(between: end, and: keyWord, distanceType: .cosine)
				if d < similarity && !pastWords.contains(keyWord.lowercased()) {
					similarity = d
					best = keyWord
				}
			}
			if similarity > 1.1 {
				guess = true
				best = prep(w:links.randomElement()!)
				similarity = e.distance(between: end, and: best, distanceType: .cosine)
			}
//			print(best)
			print("\(pastWords.count). \(best):   \(similarity)" + (guess ? " [guessed]":""))
			output += "\(pastWords.count). \(best):   \(similarity)" + (guess ? " [guessed]":"")+"\n"
			currentWord = best
			pastWords.append(best.lowercased())
			pastWordsCased.append(best)
			
		}
		output += "Done!"
			going = false
		}
	}
}

