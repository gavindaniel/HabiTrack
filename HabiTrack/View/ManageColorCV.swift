//
//  ManageColorView.swift
//  HabiTrack
//
//  Created by Gavin Daniel on 10/19/19.
//  Copyright © 2019 Gavin Daniel. All rights reserved.
//

import Foundation

class ManageColorCV: NSObject, UICollectionViewDelegate, UICollectionViewDataSource {

    // view objects
    var colorCollectionView: UICollectionView
    
    var colorList = ["teal",
                     "blue",
                     "indigo",
                     "purple",
                     "pink",
                     "red",
                     "orange"]
    
    // initializer
    init(colorUICollectionView: UICollectionView) {
        self.colorCollectionView = colorUICollectionView
        super.init()
    }
        
    // collectionView : numberOfItemsInSection
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (colorList.count)
    }
        
    // collectionView : cellForItemAt
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // create collectionView item
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "colorCell", for: indexPath)
            as! ColorCollectionViewCell
        
        let defaultColor = getSystemColor()
        let listColor = getColor(colorString: colorList[indexPath.row])
        
        if (defaultColor == listColor) {
            if #available(iOS 13.0, *) {
                cell.colorUIImageView?.image = UIImage(systemName: "largecircle.fill.circle")
            } else {
                // Fallback on earlier versions
            }
        } else {
            if #available(iOS 13.0, *) {
                cell.colorUIImageView?.image = UIImage(systemName: "circle.fill")
            } else {
                // Fallback on earlier versions
            }
        }
        cell.colorUIImageView?.tintColor = listColor
        
        
        // return initialized item
        return (cell)
    }
    
    // collectionView : didDeselectItemAt
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        print("ManageColorCV : didDeselectColorItemAt..\(indexPath.row)")
        if let cell: ColorCollectionViewCell = (collectionView.cellForItem(at: indexPath) as? ColorCollectionViewCell) {
            let defaultColor = getSystemColor()
            // selected a different color than what is currently selected
            if (cell.colorUIImageView?.tintColor != defaultColor) {
                if #available(iOS 13.0, *) {
                    cell.colorUIImageView?.image = UIImage(systemName: "circle.fill")
                } else {
                    // Fallback on earlier versions
                }
            }
        }
    }
    
    // collectionView : didSelectItemAt
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("ManageColorCV : didSelectItemAt..\(indexPath.row)")
        // get the cell from the tableView
        if let cell: ColorCollectionViewCell = (collectionView.cellForItem(at: indexPath) as? ColorCollectionViewCell) {
            let defaultColor = getSystemColor()
            // selected a different color than what is currently selected
            if (cell.colorUIImageView?.tintColor != defaultColor) {
                if #available(iOS 13.0, *) {
                    cell.colorUIImageView?.image = UIImage(systemName: "largecircle.fill.circle")
                } else {
                    // Fallback on earlier versions
                }
                let colorString = getColorString(color: cell.colorUIImageView!.tintColor)
                UserDefaults.standard.set(colorString, forKey: "defaultColor")
                self.colorCollectionView.reloadData()
            }
        }
    }
    
    // custom : updateTableView
    func updateColorView(colorUICollectionView: UICollectionView) {
        colorCollectionView = colorUICollectionView
    }
}
