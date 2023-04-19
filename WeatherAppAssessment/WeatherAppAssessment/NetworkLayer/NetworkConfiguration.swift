//
//  NetworkConfiguration.swift
//  WeatherAppAssessment
//
//  Created by SHARMILA KOTTKOTA on 4/19/23.
//

import Foundation

enum NetworkError: Error {
    case invalidURL
    case decodingError
    case responseError(data: Data?)
    case unknown
}

protocol WeatherNetworkProtocol{
    func getWeatherDetailsWith(cityName: String, completionHandler: @escaping (Result<WeatherInfo, NetworkError>) -> Void)
    func getWeatherDetailsWith(lat: String, long: String, completionHandler: @escaping (Result<WeatherInfo, NetworkError>) -> Void)
}

class NetworkConfiguration: WeatherNetworkProtocol{
    
    private init(){}
    
    static let shared = NetworkConfiguration()
        
    func getWeatherDetailsWith(cityName: String, completionHandler: @escaping (Result<WeatherInfo, NetworkError>) -> Void){
        openWeatherMapRequest(request: .getWeatherDataByUsingCityName(cityName: cityName), expecting: WeatherInfo.self) { result in
            completionHandler(result)
        }
    }
    
    func getWeatherDetailsWith(lat: String, long: String, completionHandler: @escaping (Result<WeatherInfo, NetworkError>) -> Void){
        openWeatherMapRequest(request: .getWeatherDataByUsingCurrentLocation(lat: lat, long: long), expecting: WeatherInfo.self) { result in
            completionHandler(result)
        }
    }
    
    
    private func openWeatherMapRequest<T: Decodable>(request: WeatherRequest, expecting: T.Type, completionHandler: @escaping(Result<T, NetworkError>) -> Void){
        
        guard let url = URL(string: request.url) else{
            return completionHandler(.failure(.invalidURL))
        }
        
        var urlRequest: URLRequest = URLRequest(url: url)
        urlRequest.httpMethod = request.httpMethod
        urlRequest.allHTTPHeaderFields = request.headers
        
        request.headers?.forEach({ header in
            urlRequest.setValue(header.value, forHTTPHeaderField: header.key)
        })
        
        URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            
            guard let data = data else {
                return completionHandler(.failure(.responseError(data: data)))
            }
            
            do {
                let decodedResponse = try JSONDecoder().decode(expecting.self, from: data)
                print(data.printJson())
                completionHandler(.success(decodedResponse))
            }
            catch{
                print(error)
                print(error.localizedDescription)
                completionHandler(.failure(.decodingError))
            }
            
        }.resume()
        
    }
    
}

