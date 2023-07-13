//
//  PrintHelper.swift
//  pdfFiller
//
//  Created by Anton Hryshchuk on 23.07.2021.
//  Copyright © 2021 PdfFiller. All rights reserved.
//

import Foundation

func Log(_ items: Any..., separator: String = " ", terminator: String = "\n") {
    #if DEBUG
        let output = "[DigiModule]: " + items.map { "\($0)" }.joined(separator: separator)
        Swift.print(output, terminator: terminator)
    #else
        return
    #endif
}
