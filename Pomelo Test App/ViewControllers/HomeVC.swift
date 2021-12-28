//
//  HomeVC.swift
//  Pomelo Test App
//
//  Created by Achyuth Bujjigadu  on 27/12/21.
//

import UIKit
import Kingfisher

class HomeVC: UIViewController {

    @IBOutlet var popularListsTabelView: UITableView!
    @IBOutlet weak var popularSearchbar: UISearchBar!
    
    var popularList = [MostPopularResult]()
    var searchedList: [MostPopularResult] = []
    var searching = false
    var imageUrl = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        popularSearchbar.delegate = self
        setupIntialView()
    }
    
    func setupIntialView() {
        if APIClient.isNetworkReachable() {
            startPreloader()
            callMostPopularApi()
        } else {
            Utility.showAlert(sender: self, title: ApiConstants.AppMessages.appTitle, message: ApiConstants.AppMessages.noInternet)
        }
    }
    
    func sortingTheList() {
        popularList.sort(by: { $0.updated.compare($1.updated) == .orderedDescending })
        DispatchQueue.main.async {
            self.popularListsTabelView.reloadData()
        }
    }
    
    // MARK: - Api calls
    
    func callMostPopularApi() {
        APIClient.getMostPopularList() { [self] result in
            stopPreloder()
            switch result {
            case .success(let response):
                if !response.results.isEmpty {
                    popularList = response.results
                    sortingTheList()
                } else {
                    Utility.showAlert(sender: self, title: ApiConstants.AppMessages.appTitle, message: ApiConstants.AppMessages.noData)
                }
            case let .failure(error):
                if error == APIError.parsingError {
                    Utility.showAlert(sender: self, title: ApiConstants.AppMessages.appTitle, message: ApiConstants.AppMessages.parsingError)
                }  else if error == APIError.noData {
                    Utility.showAlert(sender: self, title: ApiConstants.AppMessages.appTitle, message: ApiConstants.AppMessages.noData)
                } else {
                    Utility.showAlert(sender: self, title: ApiConstants.AppMessages.appTitle, message: ApiConstants.AppMessages.unknowError)
                }
            }
        }
    }
}

extension HomeVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        if searching {
            return searchedList.count
        } else {
            return popularList.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PopularListCell.reuseID(), for: indexPath) as? PopularListCell
        if searching {
            let list = searchedList[indexPath.row]
            cell?.dateLabel.text = Utility.convertDate(dateString: list.updated)
            cell?.titleLabel.text = list.title
            cell?.subTitleLabel.text = list.abstract
            cell?.authorLabel.text = list.byline
            imageUrl = list.media[0].mediaMetadata[0].url
        } else {
            let list = popularList[indexPath.row]
            cell?.dateLabel.text = Utility.convertDate(dateString: list.updated)
            cell?.titleLabel.text = list.title
            cell?.subTitleLabel.text = list.abstract
            cell?.authorLabel.text = list.byline
            imageUrl = list.media[0].mediaMetadata[0].url
        }
        if let url = URL(string: imageUrl) {
            let processor = DownsamplingImageProcessor(size: (cell?.articleImage.bounds.size)!)
                |> RoundCornerImageProcessor(cornerRadius: 2)
            cell?.articleImage.kf.indicatorType = .activity
            cell?.articleImage.kf.setImage(
                with: url,
                placeholder: UIImage(named: ""),
                options: [
                    .processor(processor),
                    .scaleFactor(UIScreen.main.scale),
                    .transition(.fade(1)),
                    .cacheOriginalImage,
                ]
            )
        }
        cell!.accessoryType = .disclosureIndicator
        return cell!
    }
    
    func tableView(_: UITableView, heightForRowAt _: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboardMain = UIStoryboard(name: "Main", bundle: nil)
        let destinationVC = storyboardMain.instantiateViewController(withIdentifier: "WebViewVC") as? WebViewVC
        if searching {
            let details = searchedList[indexPath.row]
            destinationVC?.urlAddress = details.url
        } else {
            let details = popularList[indexPath.row]
            destinationVC?.urlAddress = details.url
        }
        self.navigationController?.pushViewController(destinationVC!, animated: false)
    }
}

extension HomeVC: UISearchBarDelegate {
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        searchBar.showsCancelButton = true
        searchBar.enablesReturnKeyAutomatically = true
        return true
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if !searchText.isEmpty {
            searchBar.enablesReturnKeyAutomatically = false
            searchedList.removeAll()
            searchedList = popularList.filter {
                return $0.title.range(of: searchText, options: .caseInsensitive) != nil
            }
            searching = true
        } else {
            searching = false
            searchBar.enablesReturnKeyAutomatically = true
            searchBar.text = ""
        }
        popularListsTabelView.reloadData()
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searching = false
        searchBar.text = ""
        searchBar.showsCancelButton = false
        searchBar.searchTextField.endEditing(true)
        popularListsTabelView.reloadData()
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
        searchBar.searchTextField.endEditing(true)
    }
}
