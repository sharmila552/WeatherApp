//
//  WeatherViewModel.swift
//  WeatherAppAssessment
//
//  Created by SHARMILA KOTTKOTA on 4/19/23.
//

import Foundation
import CoreLocation

//Delegate Methods
protocol WeatherViewModelDelegate: AnyObject{
    func handleSuccessResponse(weatherInfo: WeatherInfo)
    func handleErrorResponse(message: String)
    func showActivityIndicator()
}

class WeatherViewModel: NSObject {
    var locationManager = CLLocationManager()
    private var currentLocation = CLLocation()
    
    let weatherNetWork: WeatherNetworkProtocol
    weak var delegate: WeatherViewModelDelegate?
    
    init(weatherNetWork: WeatherNetworkProtocol = NetworkConfiguration.shared) {
        self.weatherNetWork = weatherNetWork
    }
}

extension WeatherViewModel {
    func getWeatherInfoUsingCity(_ cityName: String){
        self.delegate?.showActivityIndicator()
        weatherNetWork.getWeatherDetailsWith(cityName: cityName) {[weak self] result in
            self?.handleWeatherAPIresponse(result: result)
        }
    }
    
    func getWeatherInfoUsingLatLong(lat: String, long: String){
        self.delegate?.showActivityIndicator()
        weatherNetWork.getWeatherDetailsWith(lat: lat, long: long){ [weak self] result in
            self?.handleWeatherAPIresponse(result: result)
        }
    }
    
    func handleWeatherAPIresponse( result: Result<WeatherInfo, NetworkError>){
        
        DispatchQueue.main.async { [weak self] in
            switch result {
            case .success(let model):
                self?.delegate?.handleSuccessResponse(weatherInfo: model)
            case .failure(let error):
                var errorMessage = "Something went wrong, Please try again!"
                switch error {
                case .responseError(let data):
                    guard let data else{break}
                    guard let decodedData = try? JSONDecoder().decode(WeatherErrorModel.self, from: data) else{break}
                    errorMessage = decodedData.message
                    if errorMessage == "city not found"{
                        errorMessage = "Please enter a valid US city"
                    }
                    
                case .invalidURL:
                    errorMessage = "Invalid URL"
                default:
                    break
                }
                self?.delegate?.handleErrorResponse(message: errorMessage)
            }
        }
    }
}

extension WeatherViewModel {
    func locationAuthorizationStatus() -> CLAuthorizationStatus {
        if #available(iOS 14, *) {
            return locationManager.authorizationStatus
        } else {
            return  CLLocationManager.authorizationStatus()
        }
    }
    
    func isLocationAuthorisedByUser() -> Bool {
        let status = locationAuthorizationStatus()
        switch status {
        case .authorizedAlways, .authorizedWhenInUse:
            return true
        default:
            return false
        }
    }
    
    func getCurrentLocationLatituteAndLongitude() -> (String, String)?{
        let locationManager = CLLocationManager()
        guard let location = locationManager.location?.coordinate else{return nil}
        return (location.latitude.description, location.longitude.description)
    }
}
