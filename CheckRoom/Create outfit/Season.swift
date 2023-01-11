//
//  Season.swift
//  CheckRoom
//
//  Created by mac on 11.01.2023.
//

import UIKit

enum Season: CaseIterable {
    case summer, autumn, winter, spring
    
    var title: String {
        switch self {
        case .summer:
            return "Summer"
        case .autumn:
            return "Autumn"
        case .winter:
            return "Winter"
        case .spring:
            return "Spring"
        }
    }
    
    var image: UIImage? {
        switch self {
        case .summer:
            return UIImage(named: "summer-season")
        case .autumn:
            return UIImage(named: "autumn-season")
        case .winter:
            return UIImage(named: "winter-season")
        case .spring:
            return UIImage(named: "spring-season")
        }
    }
    
    var imageActive: UIImage? {
        switch self {
        case .summer:
            return UIImage(named: "summer-season-active")
        case .autumn:
            return UIImage(named: "autumn-season-active")
        case .winter:
            return UIImage(named: "winter-season-active")
        case .spring:
            return UIImage(named: "spring-season-active")
        }
    }
}
