//
//  Functions.swift
//  I am Happy
//
//  Created by Kostyukevich Ilya on 23.06.2022.
//  Copyright © 2022 HappyCorp. All rights reserved.
//

import Foundation
import UIKit

typealias EmptyCompletion = () -> Void
typealias ServerCompletion<T, U> = (T, U) -> Void
typealias Completion<T> = (T) -> Void

func globalAsync(completion: @escaping () -> Void) {
    DispatchQueue.global().async {
        completion()
    }
}

func delay(seconds: Double, completion: @escaping EmptyCompletion) {
    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + seconds) {
        completion()
    }
}

func animate(with duration: Double = 0.3, completion: @escaping EmptyCompletion) {
    UIView.animate(withDuration: duration, animations: completion)
}

func async(completion: @escaping EmptyCompletion) {
    DispatchQueue.main.async {
        completion()
    }
}

func useInMainThread(completion: @escaping EmptyCompletion) {
    Thread.isMainThread ? completion() : async { completion() }
}
