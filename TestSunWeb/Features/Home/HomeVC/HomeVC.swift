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
            mainTV.register(UINib(nibName: kSectionHeader, bundle: .main), forHeaderFooterViewReuseIdentifier: kSectionHeader)
            mainTV.separatorStyle = .none
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
        self.title = "home.title".localized
        setVM()
        
    }

    func setVM() {
        homeVM = HomeVM(delegate: self)
    }
    
    func fillSections() {
        if sections.count == 0 {
            sections.append(kSectionOutboundFlights)
            sections.append(kSectionInboundFlights)
        }
        mainTV.reloadData()
    }
    
    func showToast() {
        if self.toast == nil {
            self.toast = ToastVC(containerView: self.view)
            self.toast.add()
        }
        self.toast.show()
        guard let price = homeVM.routePrice else {
            return
        }
        self.mainTV.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: self.toast.view.frame.size.height, right: 0)
        self.toast.configure(price: price)
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
                return "home.outbound_header".localized
            case kSectionInboundFlights:
                return "home.inbound_header".localized
            default:
                return ""
        }
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
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch sections[indexPath.section] {
            case
                kSectionOutboundFlights:
                let flight = homeVM.outboundFlights[indexPath.row]
                homeVM.selectOutboundFlight(outboundFlight: flight)
            case kSectionInboundFlights:
                let flight = homeVM.filteredInboundFlights[indexPath.row]
                homeVM.selectInboundFlight(inboundFlight: flight)
            default:
                break
        }
    }
}

extension HomeVC: HomeVMDelegate {
    func didSelectOutboundFlight() {
        self.fillSections()
    }
    
    func didSelectInboundFlight() {
        self.fillSections()
        self.showToast()
        guard self.homeVM.outboundFlights.count > 0 else {
            return
        }
        let indexPath = IndexPath(row: self.homeVM.filteredInboundFlights.count-1, section: 1)
        self.mainTV.scrollToRow(at: indexPath, at: .top, animated: true)
    }
    
    func couldntSelectInboundFlight() {
        self.fillSections()
        self.hideToast()
    }
}
