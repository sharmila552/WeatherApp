//
//  WeatherRequest.swift
//  WeatherAppAssessment
//
//  Created by SHARMILA KOTTKOTA on 4/19/23.
//

import Foundation

protocol RequestProtocol {
    var httpMethod: String { get }
    var baseURL: String { get }
    var endPointPath: String { get }
    var headers: [String: String]? { get }
    var url: String { get }
}


enum WeatherRequest: RequestProtocol{
    case getWeatherDataByUsingCityName(cityName: String)
    case getWeatherDataByUsingCurrentLocation(lat: String, long: String)
    
    var baseURL: String{
        return "https://api.openweathermap.org"
    }
    
    var endPointPath: String{
        let apiKey: String = WAConstants.apiKey
        switch self {
        case .getWeatherDataByUsingCityName(let cityName):
            return "/data/2.5/weather?q=\(cityName.addingPercentEncoding(withAllowedCharacters: .alphanumerics)!),US&appid=\(apiKey)"
        case .getWeatherDataByUsingCurrentLocation(let lat, let long):
            return "/data/2.5/weather?lat=\(lat)&lon=\(long)&appid=\(apiKey)"
        }
    }
    
    var url: String {
        return self.baseURL + self.endPointPath
    }
    
    var headers: [String: String]? {
        switch self {
        default:
            return ["Content-Type": "application/json",
                    "Accept": "application/json",
            ]
        }
    }
    
    var body: [String : Any]? {
        switch self {
        default:
            return [:]
        }
    }
    
    var httpMethod: String {
        switch self{
        default:
            return "GET"
        }
    }
}
