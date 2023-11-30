//
//  File.swift
//  
//
//  Created by Ghullam  Abbas on 17/08/2023.
//

import Foundation
import SmilesLanguageManager

extension DateFormatter {
    static func configuredFormatter(with format: String, localeIdentifier: String) -> DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        formatter.locale = Locale(identifier: localeIdentifier)
        return formatter
    }
}

extension String {
    func convertDate(from format: String, to targetFormat: String) -> String {
        let dateFormatterGet = DateFormatter.configuredFormatter(with: format, localeIdentifier: "en_US")
        
        let dateFormatterPrint = DateFormatter.configuredFormatter(with: targetFormat, localeIdentifier: "en_US")
        if SmilesLanguageManager.shared.currentLanguage == .ar {
            dateFormatterPrint.locale = Locale(identifier: "ar")
        }
        
        if let date = dateFormatterGet.date(from: self) {
            return dateFormatterPrint.string(from: date)
        } else {
            return ""
        }
    }
}
