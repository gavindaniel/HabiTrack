//
//  ManageColorView.swift
//  HabiTrack
//
//  Created by Gavin Daniel on 10/19/19.
//  Copyright © 2019 Gavin Daniel. All rights reserved.
//

import Foundation


public var colorSelected = "blue"

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
//    var colorSelected = "blue"
    
    
    // name: init
    // desc:
    // last updated: 4/28/2020
    // last update: cleaned up
    init(colorUICollectionView: UICollectionView) {
        debugPrint("ManageColorCV", "init", "start", true)
        self.colorUICollectionView = colorUICollectionView
        let defaultColor = getColor("System")
        colorSelected = getColorString(color: defaultColor)
        super.init()
        debugPrint("ManageColorCV", "init", "end", true)
    }
        
    
    // name: numberOfItemsInSection
    // desc:
    // last updated: 4/28/2020
    // last update: cleaned up
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        debugPrint("ManageColorCV", "numberOfItemsInSection", "start", true)
        debugPrint("ManageColorCV", "numberOfItemsInSection", "end", true)
        return (colorList.count)
    }
        
    
    // name: cellForItemAt
    // desc:
    // last updated: 4/28/2020
    // last update: cleaned up
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        debugPrint("ManageColorCV", "cellForItemAt", "start", true, indexPath.row)
        // create collectionView item
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "colorCell", for: indexPath)
            as! ColorCVCell
        let defaultColor = getColor("System")
        let selectedColor = getColor(colorSelected)
        let listColor = getColor(colorList[indexPath.row])
        if(defaultColor == selectedColor) {
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
        } else {
            if (selectedColor == listColor) {
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
        }
        cell.colorUIImageView?.tintColor = listColor
        // return initialized item
        debugPrint("ManageColorCV", "cellForItemAt", "end", true, indexPath.row)
        return (cell)
    }
    
    
    // name: didSelectItemAt
        // desc:
        // last updated: 4/28/2020
        // last update: cleaned up
        func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            debugPrint("ManageColorCV", "didSelectItemAt", "start", true, indexPath.row)
            
            // get the cell from the tableView
            if let cell: ColorCVCell = (collectionView.cellForItem(at: indexPath) as? ColorCVCell) {
                let defaultColor = getColor(colorSelected)
                // selected a different color than what is currently selected
                if (cell.colorUIImageView?.tintColor != defaultColor) {
                    if #available(iOS 13.0, *) {
                        cell.colorUIImageView?.image = UIImage(systemName: "largecircle.fill.circle")
                    } else {
                        // Fallback on earlier versions
                    }
                    print("\tManageColorCV : colorSelected..\(colorSelected)")
                    colorSelected = getColorString(color: cell.colorUIImageView!.tintColor)
                    print("\tManageColorCV : colorSelected..\(colorSelected)")
                    collectionView.reloadData()
//                    DataManager.shared.customizeVC.updateButtons()
//                    DataManager.shared.customizeVC.saveDispUIButton.setTitleColor(getColor(colorSelected), for: .normal)
//                    DataManager.shared.customizeVC.closeUIButton.setTitleColor(getColor(colorSelected), for: .normal)
//                    DataManager.shared.customizeVC.journalUITableView.reloadData()
                }
            }
            debugPrint("ManageColorCV", "didSelectItemAt", "end", true, indexPath.row)
        }
    
    
    // name: didDeselectItemAt
    // desc:
    // last updated: 4/28/2020
    // last update: cleaned up
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        debugPrint("ManageColorCV", "didDeselectItemAt", "start", true, indexPath.row)
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
        debugPrint("ManageColorCV", "didDeselectItemAt", "end", true, indexPath.row)
    }
    
    
    // name: updatedUICollectionView
    // desc:
    // last updated: 4/28/2020
    // last update: cleaned up
    func updateUICollectionView(_ colorUICollectionView: UICollectionView) {
        debugPrint("ManageColorCV", "updatedUICollectionView", "start", true)
        self.colorUICollectionView = colorUICollectionView
        debugPrint("ManageColorCV", "updatedUICollectionView", "end", true)
    }
}
