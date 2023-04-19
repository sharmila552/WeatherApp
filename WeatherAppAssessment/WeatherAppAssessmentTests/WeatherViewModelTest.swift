//
//  WeatherViewModelTest.swift
//  WeatherAppAssessmentTests
//
//  Created by SHARMILA KOTTKOTA on 4/19/23.
//

import XCTest
import CoreLocation
@testable import WeatherAppAssessment

final class WeatherViewModelTest: XCTestCase {
    var weatherSut: WeatherViewModel!
    var mockDelegate: MockWeatherManagerDelegate!
    
    override func setUp() {
        super.setUp()
        weatherSut = WeatherViewModel()
        mockDelegate = MockWeatherManagerDelegate()
        weatherSut.delegate = mockDelegate
    }

    override func tearDown() {
        weatherSut = nil
        mockDelegate = nil
        super.tearDown()
    }
    
    func testGetWeatherInfoUsingCity() {
        // given
        let cityName = "Dallas"
        
        // when
        weatherSut.getWeatherInfoUsingCity(cityName)
        
        // then
           let expectation = XCTestExpectation(description: "Wait till get the updated Data")
           DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
               expectation.fulfill()
           }
           wait(for: [expectation], timeout: 10)
           
           // Assert that the weather model is not nil
           XCTAssertNotNil(mockDelegate.weatherInfo)
    }
    
    func testGetWeatherInfoUsingLatLong() {
        // given
        let latitude = CLLocationDegrees(32.7767)
        let longitude = CLLocationDegrees(96.7970)
        
        // when
        weatherSut.getWeatherInfoUsingLatLong(lat: latitude.description, long: longitude.description)
        
        // then
        let expectation = XCTestExpectation(description: "Wait till get the updated Data")
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 10)
        
        // Assert that the weather model is not nil
        XCTAssertNotNil(mockDelegate.weatherInfo)
    }
    
    func testParseJSON() {
        // given
        let json = """
        {
          "base" : "stations",
          "id" : 4671654,
          "dt" : 1681908682,
          "main" : {
            "temp_max" : 22.289999999999999,
            "humidity" : 89,
            "feels_like" : 22,
            "temp_min" : 20.57,
            "temp" : 21.469999999999999,
            "pressure" : 1016
          },
          "coord" : {
            "lon" : -97.743099999999998,
            "lat" : 30.267199999999999
          },
          "wind" : {
            "speed" : 3.6000000000000001,
            "deg" : 170
          },
          "sys" : {
            "id" : 2003218,
            "country" : "US",
            "sunset" : 1681952419,
            "type" : 2,
            "sunrise" : 1681905571
          },
          "weather" : [
            {
              "id" : 804,
              "main" : "Clouds",
              "icon" : "04d",
              "description" : "overcast clouds"
            }
          ],
          "visibility" : 10000,
          "clouds" : {
            "all" : 100
          },
          "timezone" : -18000,
          "cod" : 200,
          "name" : "Austin"
        }
        """
        let jsonData = json.data(using: .utf8)!
        
        // when
        guard let weatherInfo = try? JSONDecoder().decode(WeatherInfo.self, from: jsonData) else {
            return
        }
        // then
        XCTAssertNotNil(weatherInfo)
        XCTAssertEqual(weatherInfo.base, "stations")
        XCTAssertEqual(weatherInfo.wind.speed, 3.6000000000000001)
        XCTAssertEqual(weatherInfo.id, 4671654)
    }
}

class MockWeatherManagerDelegate: WeatherViewModelDelegate {
    var weatherInfo: WeatherInfo?
    var errorMessage: String?
    func handleSuccessResponse(weatherInfo: WeatherAppAssessment.WeatherInfo) {
        self.weatherInfo = weatherInfo
    }
    
    func handleErrorResponse(message: String) {
        self.errorMessage = message
    }
    
    func showActivityIndicator() {
        
    }
}
