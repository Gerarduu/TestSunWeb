//
//  HomeVC.swift
//  TestSunWeb
//
//  Created by Gerard Riera  on 07/03/2021.
//

import Foundation
import UIKit

class HomeVC: BaseVC {
    
    @IBOutlet weak var mainTV: UITableView! {
        didSet {
            mainTV.delegate = self
            mainTV.dataSource = self
            mainTV.register(UINib(nibName: kFlightTVC, bundle: .main), forCellReuseIdentifier: kFlightTVC)
            mainTV.separatorStyle = .none
            mainTV.rowHeight = 60
        }
    }
    
    var homeVM: HomeVM! {
        didSet {
            homeVM.loadData()
        }
    }
    
    var flights: [FlightObject]!
    var sections = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setVM()
    }

    func setVM() {
        homeVM = HomeVM(delegate: self)
    }
    
    func fillSections() {
        if sections.count == 0 {
            if homeVM.outboundFlights != nil {
                sections.append(kSectionOutboundFlights)
            }
            if homeVM.filteredInboundFlights != nil {
                sections.append(kSectionInboundFlights)
            }
        }
        mainTV.reloadData()
    }
    
    func cellForFlight(indexPath: IndexPath) -> UITableViewCell {
        if let cell = mainTV.dequeueReusableCell(withIdentifier: kFlightTVC) as? FlightTVC {
            switch sections[indexPath.section] {
                case kSectionOutboundFlights:
                    guard let flight = self.homeVM?.outboundFlights?[indexPath.row] else { return UITableViewCell() }
                    cell.configureCell(with: flight)
                    return cell
                case kSectionInboundFlights:
                    guard let flight = self.homeVM?.filteredInboundFlights?[indexPath.row] else { return UITableViewCell() }
                    cell.configureCell(with: flight)
                    return cell
                default:
                    return UITableViewCell()
            }
        } else {
            return UITableViewCell()
        }
    }
}

extension HomeVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch sections[section] {
            case kSectionOutboundFlights:
                return homeVM.outboundFlights?.count ?? 0
            case kSectionInboundFlights:
                return homeVM.filteredInboundFlights?.count ?? 0
            default:
                return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return cellForFlight(indexPath: indexPath)
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch sections[section] {
            case kSectionOutboundFlights:
                return "Outbound Flights"
            case kSectionInboundFlights:
                return "Inbound Flights"
            default:
                return ""
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch sections[indexPath.section] {
            case kSectionOutboundFlights:
                let flight = homeVM.outboundFlights[indexPath.row]
                homeVM.selectOutboundFlight(_flight: flight)
            case kSectionInboundFlights:
                let flight = homeVM.filteredInboundFlights[indexPath.row]
                homeVM.selectInboundFlight(_flight: flight)
            default:
                break
        }
    }
}

extension HomeVC: HomeVMDelegate {
    func didSelectFlight() {
        fillSections()
    }
}
