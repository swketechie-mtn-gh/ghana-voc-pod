//
//  GenericError.swift
//  IZI
//
//  Created by Vladislav Patrashkov on 4/23/19.
//  Copyright © 2019 evo.company. All rights reserved.
//

enum GenericError: Error {
    case message(String)
    case dataLoading(String)
}
