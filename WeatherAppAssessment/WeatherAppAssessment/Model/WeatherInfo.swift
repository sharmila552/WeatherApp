//
//  WeatherInfo.swift
//  WeatherAppAssessment
//
//  Created by SHARMILA KOTTKOTA on 4/19/23.
//

import Foundation

// MARK: - WeatherInfo
class WeatherInfo: Codable {
    let weather: [Weather]
    let base: String
    let main: Main
    let wind: Wind
    let dt: Int
    let sys: Sys?
    let timezone, id: Int
    let name: String
    let cod: Int

    init(weather: [Weather], base: String, main: Main, visibility: Int, wind: Wind,dt: Int, sys: Sys, timezone: Int, id: Int, name: String, cod: Int) {
        self.weather = weather
        self.base = base
        self.main = main
        self.wind = wind
        self.dt = dt
        self.sys = sys
        self.timezone = timezone
        self.id = id
        self.name = name
        self.cod = cod
    }
}

// MARK: - Main
class Main: Codable {
    let temp, tempMin, tempMax: Double
    let pressure, humidity: Int

    enum CodingKeys: String, CodingKey {
        case temp
        case tempMin = "temp_min"
        case tempMax = "temp_max"
        case pressure, humidity
    }

    init(temp: Double, feelsLike: Double, tempMin: Double, tempMax: Double, pressure: Int, humidity: Int) {
        self.temp = temp
        self.tempMin = tempMin
        self.tempMax = tempMax
        self.pressure = pressure
        self.humidity = humidity
    }
}

// MARK: - Sys
class Sys: Codable {
    let type, id: Int?
    let country: String
    let sunrise, sunset: Int

    init(type: Int, id: Int, country: String, sunrise: Int, sunset: Int) {
        self.type = type
        self.id = id
        self.country = country
        self.sunrise = sunrise
        self.sunset = sunset
    }
}

// MARK: - Weather
class Weather: Codable {
    let main, description, icon: String

    init(main: String, description: String, icon: String) {
        self.main = main
        self.description = description
        self.icon = icon
    }
}

// MARK: - Wind
class Wind: Codable {
    let speed: Double

    init(speed: Double, deg: Int) {
        self.speed = speed
    }
}


class WeatherErrorModel: Decodable{
    let cod, message: String
}

/*
 {
   "base" : "stations",
   "id" : 4671654,
   "dt" : 1681905684,
   "main" : {
     "temp_max" : 22.190000000000001,
     "humidity" : 89,
     "feels_like" : 21.91,
     "temp_min" : 20.539999999999999,
     "temp" : 21.390000000000001,
     "pressure" : 1015
   },
   "coord" : {
     "lon" : -97.743099999999998,
     "lat" : 30.267199999999999
   },
   "wind" : {
     "speed" : 1.79,
     "deg" : 155,
     "gust" : 3.1299999999999999
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
     "all" : 98
   },
   "timezone" : -18000,
   "cod" : 200,
   "name" : "Austin"
 }
 */
