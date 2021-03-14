//
//  File.swift
//  TestSunWeb
//
//  Created by Gerard Riera  on 14/03/2021.
//

import UIKit

class AirlineVC: BaseVC {
    
    var id: String!
    var sections = [String]()
    var airlineVM: AirlineVM! {
        didSet {
            loadData()
        }
    }
    
    @IBOutlet weak var mainTV: UITableView! {
        didSet {
            mainTV.delegate = self
            mainTV.dataSource = self
            mainTV.separatorStyle = .none
            mainTV.register(UINib(nibName: kTopTVC, bundle: .main), forCellReuseIdentifier: kTopTVC)
            mainTV.register(UINib(nibName: kHeaderTVC, bundle: .main), forCellReuseIdentifier: kHeaderTVC)
            mainTV.register(UINib(nibName: kDescriptionTVC, bundle: .main), forCellReuseIdentifier: kDescriptionTVC)
            mainTV.contentInset = UIEdgeInsets(top: 0,left: 0,bottom: 0,right: 0)
            mainTV.showsVerticalScrollIndicator = false
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setVM()
        fillSections()
    }
    
    func setVM() {
        airlineVM = AirlineVM(delegate: self, airlineId: self.id)
    }
    
    func configure() {
        if let title = airlineVM.id {
            self.title = title+"airline.airlines".localized
        } else {
            self.title = "airline.n_d".localized
        }
    }

    override func setupUI() {
        self.navigationController?.navigationBar.prefersLargeTitles = false
        self.navigationController?.navigationBar.isTranslucent = true
    }
    
    func fillSections() {
        sections.append(kSectionTop)
        sections.append(kSectionHeadline)
        sections.append(kSectionDesc)
    }
    
    func loadData() {
        airlineVM.loadData()
    }
    
    func cellForTop(at indexPath: IndexPath) -> UITableViewCell {
        if let cell = mainTV.dequeueReusableCell(withIdentifier: kTopTVC) as? TopTVC {
            guard let logo = self.airlineVM.logoImg, let snapshot = self.airlineVM.mainImg else { return UITableViewCell()}
            cell.selectionStyle = .none
            cell.configureCell(logo: logo, snapshot: snapshot)
            return cell
        }
        return UITableViewCell()
    }
    
    func cellForHeader(at indexPath: IndexPath) -> UITableViewCell {
        if let cell = mainTV.dequeueReusableCell(withIdentifier: kHeaderTVC) as? HeaderTVC {
            guard let headline = self.airlineVM.headline else { return UITableViewCell() }
            cell.selectionStyle = .none
            cell.configureCell(headline: headline)
            return cell
        }
        return UITableViewCell()
    }
    
    func cellForDescription(at indexPath: IndexPath) -> UITableViewCell {
        if let cell = mainTV.dequeueReusableCell(withIdentifier: kDescriptionTVC) as? DescriptionTVC {
            guard let description = self.airlineVM.description else { return UITableViewCell() }
            cell.selectionStyle = .none
            cell.configureCell(description: description)
            return cell
        }
        return UITableViewCell()
    }
}

extension AirlineVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch sections[indexPath.section] {
            case kSectionTop:
                return cellForTop(at: indexPath)
            case kSectionHeadline:
                return cellForHeader(at: indexPath)
            case kSectionDesc:
                return cellForDescription(at: indexPath)
            default:
                return UITableViewCell()
        }
    }
    
    //MARK: - Defines the height for each section.
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch sections[indexPath.section] {
        case kSectionTop:
            return kHeightForTop
        case kSectionHeadline:
            return kHeightForHeadline
        case kSectionDesc:
            return kHeightForDesc
        default:
            return 0
        }
    }
}

extension AirlineVC: AirlineVMDelegate {
    func didLoadData() {
        configure()
        mainTV.reloadData()
    }
    
    func error(error: Error) {
        self.showPopup(withTitle: "error.generic".localized, withText: error.localizedDescription, withButton: "error.retry".localized, completion: { (retry,_) in
            self.dismiss(animated: true, completion: nil)
        })
    }
}
