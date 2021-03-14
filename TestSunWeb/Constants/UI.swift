//
//  UI.swift
//  TestSunWeb
//
//  Created by Gerard Riera  on 06/03/2021.
//

import Foundation
import UIKit

//MARK: - Storyboards

let kStoryboardMain = UIStoryboard(name: "Main", bundle: nil)
let kStoryboardHome = UIStoryboard(name: "Home", bundle: nil)

//MARK: - Images

let kImageOutbound = UIImage(named: "outbound")
let kImageInbound = UIImage(named: "inbound")

// MARK: - ViewControllers

let kFakeSplashVC = "FakeSplashVC"
let kHomeVC = "HomeVC"
let kAirlineVC = "AirlineVC"
let kLoadingVC = "LoadingVC"

//MARK: - Sections Home

let kSectionInboundFlights = "InboundFlights"
let kSectionOutboundFlights = "OutboundFlights"

let kSectionHeader = "SectionHeader"

//MARK: Height for sections Home

let kHeightHeaderHome = CGFloat(60)

//MARK: - TVCs

let kFlightTVC = "FlightTVC"
let kTopTVC = "TopTVC"
let kHeaderTVC = "HeaderTVC"
let kDescriptionTVC = "DescriptionTVC"

//MARK: - Toast

let kToast = "Toast"

//MARK: Sections Airline

let kSectionTop = "Top"
let kSectionHeadline = "Headline"
let kSectionDesc = "Description"

//MARK: Height for sections Airline

let kHeightForTop = CGFloat(200)
let kHeightForHeadline = CGFloat(70)
let kHeightForDesc = CGFloat(300)

//MARK: - Colors

let kColorWhite = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1.0)
let kColorBlack = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 1.0)
let kColorGray = UIColor(red: 249/255, green: 250/255, blue: 252/255, alpha: 1.0)
