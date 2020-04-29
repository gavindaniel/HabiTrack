//
//  ManageColorView.swift
//  HabiTrack
//
//  Created by Gavin Daniel on 10/19/19.
//  Copyright © 2019 Gavin Daniel. All rights reserved.
//

import Foundation


// name: JournalDateCV
// desc: journal date collection view class
// last updated: 4/28/2020
// last update: cleaned up
class ManageColorCV: NSObject, UICollectionViewDelegate, UICollectionViewDataSource {
    // variables
    var colorUICollectionView: UICollectionView
    var colorList = ["teal",
                     "blue",
                     "indigo",
                     "purple",
                     "pink",
                     "red",
                     "orange"]
    
    
    // name: init
    // desc:
    // last updated: 4/28/2020
    // last update: cleaned up
    init(colorUICollectionView: UICollectionView) {
        debugPrint("ManageColorCV", "init", "start", false)
        self.colorUICollectionView = colorUICollectionView
        super.init()
        debugPrint("ManageColorCV", "init", "end", false)
    }
        
    
    // name: numberOfItemsInSection
    // desc:
    // last updated: 4/28/2020
    // last update: cleaned up
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        debugPrint("ManageColorCV", "numberOfItemsInSection", "start", false)
        debugPrint("ManageColorCV", "numberOfItemsInSection", "end", false)
        return (colorList.count)
    }
        
    
    // name: cellForItemAt
    // desc:
    // last updated: 4/28/2020
    // last update: cleaned up
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        debugPrint("ManageColorCV", "cellForItemAt", "start", false, indexPath.row)
        // create collectionView item
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "colorCell", for: indexPath)
            as! ColorCVCell
        let defaultColor = getColor("System")
        let listColor = getColor(colorList[indexPath.row])
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
        debugPrint("ManageColorCV", "cellForItemAt", "end", false, indexPath.row)
        return (cell)
    }
    
    
    // name: didDeselectItemAt
    // desc:
    // last updated: 4/28/2020
    // last update: cleaned up
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        debugPrint("ManageColorCV", "didDeselectItemAt", "start", false, indexPath.row)
        if let cell: ColorCVCell = (collectionView.cellForItem(at: indexPath) as? ColorCVCell) {
            let defaultColor = getColor("System")
            // selected a different color than what is currently selected
            if (cell.colorUIImageView?.tintColor != defaultColor) {
                if #available(iOS 13.0, *) {
                    cell.colorUIImageView?.image = UIImage(systemName: "circle.fill")
                } else {
                    // Fallback on earlier versions
                }
            }
        }
        debugPrint("ManageColorCV", "didDeselectItemAt", "end", false, indexPath.row)
    }
    
    
    // name: didSelectItemAt
    // desc:
    // last updated: 4/28/2020
    // last update: cleaned up
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        debugPrint("ManageColorCV", "didSelectItemAt", "start", false, indexPath.row)
        print("ManageColorCV : didSelectItemAt..\(indexPath.row)")
        // get the cell from the tableView
        if let cell: ColorCVCell = (collectionView.cellForItem(at: indexPath) as? ColorCVCell) {
            let defaultColor = getColor("System")
            // selected a different color than what is currently selected
            if (cell.colorUIImageView?.tintColor != defaultColor) {
                if #available(iOS 13.0, *) {
                    cell.colorUIImageView?.image = UIImage(systemName: "largecircle.fill.circle")
                } else {
                    // Fallback on earlier versions
                }
                let colorString = getColorString(color: cell.colorUIImageView!.tintColor)
                UserDefaults.standard.set(colorString, forKey: "defaultColor")
                self.colorUICollectionView.reloadData()
            }
        }
        debugPrint("ManageColorCV", "didSelectItemAt", "end", false, indexPath.row)
    }
    
    
    // name: updatedUICollectionView
    // desc:
    // last updated: 4/28/2020
    // last update: cleaned up
    func updateUICollectionView(_ colorUICollectionView: UICollectionView) {
        debugPrint("ManageColorCV", "updatedUICollectionView", "start", false)
        self.colorUICollectionView = colorUICollectionView
        debugPrint("ManageColorCV", "updatedUICollectionView", "end", false)
    }
}
