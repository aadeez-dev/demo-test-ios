//
//  CarouselTableViewCell.swift
//  Demo Design App
//
//  Created by Aadeez Shaikh on 27/07/22.
//

import UIKit

class CarouselTableViewCell: UITableViewCell {

    public static let indentifier = "CarouselTableViewCell"
    
    @IBOutlet weak var carouselCollectionView: UICollectionView!
    @IBOutlet weak var pageController: UIPageControl!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        carouselCollectionView.register(UINib(nibName: "CarouselItemCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "CarouselItemCollectionViewCell")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    
}
