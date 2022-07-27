//
//  ViewController.swift
//  Demo Design App
//
//  Created by Aadeez Shaikh on 27/07/22.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var countriesTableView: UITableView!
    
    var carouselImages: [String] = ["image-1", "image-2", "image-3"]
    var filteredCountries: [Country] = []
    var countries: [Country] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Register TableView Cells
        countriesTableView.register(UINib(nibName: "CarouselTableViewCell", bundle: nil), forCellReuseIdentifier: CarouselTableViewCell.indentifier)
        countriesTableView.register(UINib(nibName: "ItemTableViewCell", bundle: nil), forCellReuseIdentifier: ItemTableViewCell.indentifier)
        
        // set data source and deletgate
        countriesTableView.dataSource = self
        countriesTableView.delegate = self
        
        loadCountries()
        
    }
    
    
    func loadCountries(){
        guard
            let url = Bundle.main.url(forResource: "countries", withExtension: "json"),
            let data = try? Data(contentsOf: url)
        else { return }
        
        do {
            let countries = try JSONDecoder().decode([Country].self, from: data)
            self.countries = countries.sorted(by: {$0.name.localizedCaseInsensitiveCompare($1.name) == ComparisonResult.orderedAscending})
            self.filteredCountries = self.countries
            self.countriesTableView.reloadData()
        } catch {
            // I find it handy to keep track of why the decoding has failed. E.g.:
            print(error)
            // Insert error handling here
        }
    }
    
    
    @objc func pageControlSelectionAction(sender: UIPageControl) {
         if let cell = countriesTableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? CarouselTableViewCell {
             let page: Int? = sender.currentPage
             var frame: CGRect = cell.carouselCollectionView.frame
             frame.origin.x = frame.size.width * CGFloat(page ?? 0)
             frame.origin.y = 0
             cell.carouselCollectionView.scrollRectToVisible(frame, animated: true)
         }
        
    }
}

//MARK: - UITableView Delegates
extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 0.0
        }
        return 65
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2 // section 1 for carouselView and section 2 for items
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            return UIView()
        }
        let view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 65))
        let searchView = UISearchBar(frame: view.frame)
        searchView.placeholder = "Search country..."
        searchView.delegate = self
        view.addSubview(searchView)
        
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        if indexPath.section == 0 {
            return tableView.frame.width * 0.8
        }
        return 50.0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1 // return 1 for carouselView
        }
        return filteredCountries.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: CarouselTableViewCell.indentifier, for: indexPath)
            as! CarouselTableViewCell
            cell.pageController.numberOfPages = carouselImages.count
            cell.carouselCollectionView.delegate = self
            cell.carouselCollectionView.dataSource = self
            cell.pageController.addTarget(self, action: #selector(pageControlSelectionAction(sender:)), for: .touchUpInside)
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: ItemTableViewCell.indentifier, for: indexPath)
            as! ItemTableViewCell
            cell.flagLabel.text = filteredCountries[indexPath.row].emoji
            cell.countryNameLabel.text = filteredCountries[indexPath.row].name
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.0
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
}

//MARK: - UICollectionView Delegate
extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIScrollViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return carouselImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CarouselItemCollectionViewCell.indentifier, for: indexPath) as! CarouselItemCollectionViewCell
        cell.carouselImage.image = UIImage(named: carouselImages[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
    
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if scrollView is UICollectionView {
            if let cell = countriesTableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? CarouselTableViewCell {
                let pageWidth = cell.carouselCollectionView.frame.size.width
                cell.pageController.currentPage = Int(cell.carouselCollectionView.contentOffset.x / pageWidth)
            }
        }
    }

    
}

extension ViewController: UISearchBarDelegate {
 
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.count > 1 {
            let searchedItem = countries.filter{ $0.name.contains(searchText) }
            filteredCountries = searchedItem
        } else {
            filteredCountries = self.countries
        }
        countriesTableView.reloadData()
    }
    
    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
        return true
    }
}
