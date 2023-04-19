//
//  ViewController.swift
//  WeatherAppAssessment
//
//  Created by SHARMILA KOTTKOTA on 4/18/23.
//

import UIKit
import CoreLocation

class ViewController: UIViewController {

    @IBOutlet weak var loadingIndicatorView: UIView!
    @IBOutlet weak var citySearchBar: UISearchBar!
    
    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var weatherImageView: ImageHandler!
    @IBOutlet weak var currentTemparatureLabel: UILabel!
    @IBOutlet weak var downTemparatureLabel: UILabel!
    @IBOutlet weak var upTemparatureLabel: UILabel!
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var weatherStatusLabel: UILabel!
    @IBOutlet weak var windSpeedLabel: UILabel!
    
    private var weatherViewModel: WeatherViewModel = WeatherViewModel()
       
// MARK: - View Life Cycle Method
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        citySearchBar.searchTextField.textColor = .black
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.view.bounds
        gradientLayer.colors = [UIColor.systemYellow.cgColor, UIColor.white.cgColor, UIColor.blue.cgColor]
        self.view.layer.insertSublayer(gradientLayer, at: 0)
        weatherViewModel.delegate = self
        initializeTheViewAndNetworkCalls()
    }
    
    @IBAction func selectCurrentLocation(_ sender: Any) {
        currentLocationSelected()
    }
}

extension ViewController {
    //If User has given Autherization to use Location use location to find the weather else Load the Last Searched city
    private func initializeTheViewAndNetworkCalls() {
        if weatherViewModel.isLocationAuthorisedByUser(){
            currentLocationSelected()
        }
        else if let city = getLastSearchedCity(){
            weatherViewModel.getWeatherInfoUsingCity(city)
        }
    }
    
    //Get the weather by slecting Current location.
    private func currentLocationSelected() {
        let status = weatherViewModel.locationAuthorizationStatus()
        switch status{
        case .authorizedWhenInUse:
            if let (lat, long) = weatherViewModel.getCurrentLocationLatituteAndLongitude(){
                //Making service call with Latitude and longitude
                weatherViewModel.getWeatherInfoUsingLatLong(lat: lat, long: long)
            }
            else{
                showAlert(message: "Unable to get your Location")
            }
            break
        default:
            showLocationPermissionAlert()
            break
        }
    }
    
    //Storing the last serach in Userdefaults
    private func setLastSearchedCity(cityName: String){
        UserDefaults.standard.set(cityName, forKey: "lastSearchedCity")
    }
    
    // Getting the last serach from Userdefaults
    private func getLastSearchedCity() -> String?{
        UserDefaults.standard.value(forKey: "lastSearchedCity") as? String
    }
}

// MARK: - UISearchController Delegate
extension ViewController: UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let string = searchBar.text?.trimmingCharacters(in: .whitespaces)
        guard let cityName = string, cityName.count > 0 else{return}
        weatherViewModel.getWeatherInfoUsingCity(cityName)
    }
}

// MARK: - ViewModelDelegate Methods
extension ViewController: WeatherViewModelDelegate{
    
    func handleSuccessResponse(weatherInfo: WeatherInfo) {
        let cityNameString: String = weatherInfo.name + ", " + (weatherInfo.sys?.country ?? "")
        let timeValueString: String = "Today, \(Date().dateDescription())"
        let tempDescription: String = weatherInfo.weather.first?.main ?? "-"
        let mainTempString: String = Int(weatherInfo.main.temp).description + "°"
        let minTempString: String = "\(weatherInfo.main.tempMin.description)°"
        let maxTempString: String = "\(weatherInfo.main.tempMax.description)°"
        let windString: String = "\(weatherInfo.main.pressure.description) m/s"
        cityNameLabel.text = cityNameString
        dayLabel.text = timeValueString
        currentTemparatureLabel.text = mainTempString
        downTemparatureLabel.text = minTempString
        upTemparatureLabel.text = maxTempString
        weatherStatusLabel.text = tempDescription
        windSpeedLabel.text = windString
        if let url = URL(string: "https://openweathermap.org/img/wn/\(weatherInfo.weather.first?.icon ?? "")@2x.png") {
            weatherImageView.loadImageWithUrl(url: url)
        }
        ActivityIndicator()
        if weatherInfo.sys?.country == "US"{
            setLastSearchedCity(cityName: weatherInfo.name)
        }
    }
    
    func handleErrorResponse(message: String) {
        ActivityIndicator()
        showAlert(title: "Alert!", message: message)
    }
    
    //Display Loading Indicator while network call is in-progress
    func showActivityIndicator() {
        loadingIndicatorView.isHidden = false
    }
    
    //Hide Loading Indicator for error or successfull response
    private func ActivityIndicator(){
        loadingIndicatorView.isHidden = true
    }
}
