//
//  CommonExtension.swift
//  WeatherAppAssessment
//
//  Created by SHARMILA KOTTKOTA on 4/19/23.
//
import UIKit

extension Data {
    
    func printJson() {
        do {
            let json = try JSONSerialization.jsonObject(with: self, options: [])
            let data = try JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
            guard let jsonString = String(data: data, encoding: .utf8) else {
                print("Inavlid data Received")
                return
            }
            print(jsonString)
        } catch {
            print("Error: \(error.localizedDescription)")
        }
    }
}

extension Date{
    func dateDescription() -> String{
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en-US")
        formatter.dateFormat = "MMM d, h:mm a"
        let time = formatter.string(from: self)
        return time
    }
}


