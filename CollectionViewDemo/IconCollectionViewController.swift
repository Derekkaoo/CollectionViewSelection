//
//  IconCollectionViewController.swift
//  CollectionViewDemo
//
//  Created by Simon Ng on 10/11/2016.
//  Copyright © 2016 AppCoda. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

class IconCollectionViewController: UICollectionViewController {
    
    @IBOutlet var shareButton: UIBarButtonItem!
    
    private var iconSet: [Icon] = [ Icon(name: "Candle icon", imageName: "candle", description: "Halloween icons designed by Tania Raskalova.", price: 3.99, isFeatured: false),
                                    Icon(name: "Cat icon", imageName: "cat", description: "Halloween icon designed by Tania Raskalova.", price: 2.99, isFeatured: true),
                                    Icon(name: "dribbble", imageName: "dribbble", description: "Halloween icon designed by Tania Raskalova.", price: 1.99, isFeatured: false),
                                    Icon(name: "Ghost icon", imageName: "ghost", description: "Halloween icon designed by Tania Raskalova.", price: 4.99, isFeatured: false),
                                    Icon(name: "Hat icon", imageName: "hat", description: "Halloween icon designed by Tania Raskalova.", price: 2.99, isFeatured: false),
                                    Icon(name: "Owl icon", imageName: "owl", description: "Halloween icon designed by Tania Raskalova.", price: 5.99, isFeatured: true),
                                    Icon(name: "Pot icon", imageName: "pot", description: "Halloween icon designed by Tania Raskalova.", price: 1.99, isFeatured: false),
                                    Icon(name: "Pumkin icon", imageName: "pumkin", description: "Halloween icon designed by Tania Raskalova.", price: 0.99, isFeatured: false),
                                    Icon(name: "RIP icon", imageName: "rip", description: "Halloween icon designed by Tania Raskalova.", price: 7.99, isFeatured: false),
                                    Icon(name: "Skull icon", imageName: "skull", description: "Halloween icon designed by Tania Raskalova.", price: 8.99, isFeatured: false),
                                    Icon(name: "Sky icon", imageName: "sky", description: "Halloween icon designed by Tania Raskalova.", price: 0.99, isFeatured: false),
                                    Icon(name: "Toxic icon", imageName: "toxic", description: "Halloween icon designed by Tania Raskalova.", price: 2.99, isFeatured: false),
                                    Icon(name: "Book icon", imageName: "ic_book", description: "Colorful icon designed by Marin Begović.", price: 2.99, isFeatured: false),
                                    Icon(name: "Backpack icon", imageName: "ic_backpack", description: "Colorful icon designed by Marin Begović.", price: 3.99, isFeatured: false),
                                    Icon(name: "Camera icon", imageName: "ic_camera", description: "Colorful camera icon designed by Marin Begović.", price: 4.99, isFeatured: false),
                                    Icon(name: "Coffee icon", imageName: "ic_coffee", description: "Colorful icon designed by Marin Begović.", price: 3.99, isFeatured: true),
                                    Icon(name: "Glasses icon", imageName: "ic_glasses", description: "Colorful icon designed by Marin Begović.", price: 3.99, isFeatured: false),
                                    Icon(name: "Icecream icon", imageName: "ic_ice_cream", description: "Colorful icon designed by Marin Begović.", price: 4.99, isFeatured: false),
                                    Icon(name: "Smoking pipe icon", imageName: "ic_smoking_pipe", description: "Colorful icon designed by Marin Begović.", price: 6.99, isFeatured: false),
                                    Icon(name: "Vespa icon", imageName: "ic_vespa", description: "Colorful icon designed by Marin Begović.", price: 9.99, isFeatured: false)]
    
    //選取的模式， true 代表 share 被按下並啟動複選模式
    private var shareEnabled = false
    
    //儲存被選取圖示的陣列，每一個 tuple ，他儲存了所選的圖示與對應的截圖
    private var selectedIcons: [(icon: Icon, snapshot: UIImage)] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func unwindToHome(segue: UIStoryboardSegue) {
        
    }
    
    // shareEnabled 的狀態是 true ，就不讓他轉場
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if identifier == "showIconDetail" {
            if shareEnabled {
                // share 按鈕被按下 ➡ true
                //不讓他轉場
                return false
            }
        }
        // share 按鈕沒被按 ➡ false
        //讓他轉場
        return true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showIconDetail" {
            if let indexPaths = collectionView?.indexPathsForSelectedItems {
                let destinationVC = segue.destination as! IconDetailViewController
                
                // indexPaths[0].row 意思是 indexPaths 可能有多個路徑，可以是複選。依此範例是單選，所以挑第一個索引路徑
                destinationVC.icon = iconSet[indexPaths[0].row]
                
                //取消被選取的項目
                collectionView?.deselectItem(at: indexPaths[0], animated: false)
            }
        }
    }
    
    @IBAction func shareButtonTapped(sender: AnyObject) {
        guard shareEnabled else {
            //變更 shareEnabled 為 YES 並變更按鈕文字為 Done
            shareEnabled = true
            collectionView?.allowsMultipleSelection = true
            shareButton.title = "Done"
            shareButton.style = .done
            
            return
        }
        
        //確認使用者至少有選取一個圖示
        guard selectedIcons.count > 0 else { return }
        
        //取得所選圖示的快照
        let snapshots = selectedIcons.map { $0.snapshot }
        
        //建立分享用的 activityController
        let activityController = UIActivityViewController(activityItems: snapshots, applicationActivities: nil)
        
        // activityController 解除後帶入一個閉包，用來清除與回復分享按鈕至原來的狀態
        activityController.completionWithItemsHandler = {
            (activityType, completed, returnedItem, error) in
            
            //取消所有選取項目
            if let indexPaths = self.collectionView?.indexPathsForSelectedItems {
                for indexPath in indexPaths {
                    self.collectionView?.deselectItem(at: indexPath, animated: false)
                }
            }
            
            // selectedIcons 陣列中移除所有的項目
            self.selectedIcons.removeAll(keepingCapacity: true)
            
            //變更分享模式為 NO
            self.shareEnabled = false
            self.collectionView?.allowsMultipleSelection = false
            self.shareButton.title = "Share"
            self.shareButton.style = .plain
        }
        
        present(activityController, animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // Return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // Return the number of items
        return iconSet.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! IconCollectionViewCell
    
        // Configure the cell
        let icon = iconSet[indexPath.row]
        cell.iconImageView.image = UIImage(named: icon.imageName)
        cell.iconPriceLabel.text = "$\(icon.price)"
        cell.selectedBackgroundView = UIImageView(image: #imageLiteral(resourceName: "icon-selected"))
        cell.backgroundView = (icon.isFeatured) ? UIImageView(image: UIImage(named: "feature-bg")) : nil
    
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        //檢查分享模式是否已經啟動，沒有的話就離開
        guard shareEnabled else { return }
        
        let deSelectedIcon = iconSet[indexPath.row]
        
        //反選圖示的名稱與所選圖示陣列項目比對，一樣的把它刪掉
        if let index = selectedIcons.firstIndex(where: { $0.icon.name == deSelectedIcon.name }) {
            selectedIcons.remove(at: index)
        }
        
        //使用 indexPath 來判斷所選的項目並帶入一個快照
        let seletedIcon = iconSet[indexPath.row]
        if let snapshot = collectionView.cellForItem(at: indexPath)?.snapshot {
            selectedIcons.append((icon: seletedIcon, snapshot: snapshot))
        }
    }
}
