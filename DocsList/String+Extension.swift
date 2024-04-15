//
//  String+Extension.swift
//  DocsList
//
//  Created by Александр Медведев on 15.04.2024.
//

import Foundation

extension String {
    var capitalizedSentence: String {
        let firstLetter = self.prefix(1).capitalized
        let remainingLetters = self.dropFirst().lowercased()
        return firstLetter + remainingLetters
    }
}
