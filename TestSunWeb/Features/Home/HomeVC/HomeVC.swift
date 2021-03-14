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
            mainTV.separatorStyle = .none
            mainTV.showsVerticalScrollIndicator = false
            mainTV.register(UINib(nibName: kFlightTVC, bundle: .main), forCellReuseIdentifier: kFlightTVC)
            mainTV.contentInset = UIEdgeInsets(top: 0,left: 0,bottom: 0,right: 0)
            mainTV.backgroundColor = kColorGray
            mainTV.rowHeight = 60
        }
    }
    
    var homeVM: HomeVM! {
        didSet {
            homeVM.loadData()
        }
    }
    
    var sections = [String]()
    var toast: ToastVC!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        fillSections()
        setVM()
    }
    
    func setup() {
        self.title = "home.title".localized
    }

    func fillSections() {
        sections.append(kSectionOutboundFlights)
        sections.append(kSectionInboundFlights)
    }
    
    func setVM() {
        homeVM = HomeVM(delegate: self)
    }
    
    func showToast() {
        if self.toast == nil {
            self.toast = ToastVC(containerView: self.view)
            self.toast.add()
        }
        guard let price = homeVM.routePrice else {
            self.hideToast()
            return
        }
        self.toast.show()
        self.toast.configure(price: price)
        self.mainTV.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: self.toast.view.frame.size.height, right: 0)
    }
    
    func hideToast() {
        if self.toast != nil {
            self.mainTV.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            self.toast.hide()
        }
    }
    
    func cellForFlight(indexPath: IndexPath) -> UITableViewCell {
        if let cell = mainTV.dequeueReusableCell(withIdentifier: kFlightTVC) as? FlightTVC {
            switch sections[indexPath.section] {
                case kSectionOutboundFlights:
                    guard let flight = self.homeVM?.outboundFlights?[indexPath.row] else { return UITableViewCell() }
                    cell.configureCell(with: flight)
                    cell.delegate = self
                    return cell
                case kSectionInboundFlights:
                    guard let flight = self.homeVM?.filteredInboundFlights?[indexPath.row] else { return UITableViewCell() }
                    cell.configureCell(with: flight)
                    cell.delegate = self
                    return cell
                default:
                    return UITableViewCell()
            }
        } else {
            return UITableViewCell()
        }
    }
    
    func pushAirline(id: String) {
        DispatchQueue.main.async { [weak self] in
            if let airlineVC = kStoryboardHome.instantiateViewController(withIdentifier: kAirlineVC) as? AirlineVC {
                airlineVC.id = id
                self?.present(UINavigationController(rootViewController: airlineVC), animated: true, completion: nil)
            }
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
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch sections[section] {
            case kSectionOutboundFlights:
                let sectionHeader = SectionHeader(title: "home.outbound_header".localized, image: kImageOutbound)
                return sectionHeader.view
            case kSectionInboundFlights:
                let sectionHeader = SectionHeader(title: "home.inbound_header".localized, image: kImageInbound)
                return sectionHeader.view
            default:
                return UIView()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return kHeightHeaderHome
    }
}

extension HomeVC: HomeVMDelegate {
    func didSelectOutboundFlight() {
        mainTV.reloadData()
    }
    
    func didSelectInboundFlight() {
        mainTV.reloadData()
        self.showToast()
        guard self.homeVM.outboundFlights.count > 0 else {
            return
        }
        let indexPath = IndexPath(row: self.homeVM.filteredInboundFlights.count-1, section: 1)
        self.mainTV.scrollToRow(at: indexPath, at: .top, animated: true)
    }
    
    func couldntSelectInboundFlight() {
        mainTV.reloadData()
        self.hideToast()
    }
}

extension HomeVC: FlightTVCDelegate {
    func didSelectFlight(flight: FlightObject) {
        switch flight.outBound {
            case true:
                let flight = flight
                homeVM.selectOutboundFlight(outboundFlight: flight)
            case false:
                let flight = flight
                homeVM.selectInboundFlight(inboundFlight: flight)
            default:
                break
        }
    }
    
    func didSelectAirlne(airline: String) {
        pushAirline(id: airline)
    }
}
