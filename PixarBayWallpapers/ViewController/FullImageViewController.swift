//
//  FullImageViewController.swift
//  PixarBayWallpapers
//
//  Created by Anshu Vij on 8/13/20.
//  Copyright © 2020 anshu vij. All rights reserved.
//

import UIKit

class FullImageViewController: UIViewController {

    
    var vSpinner : UIView?
    @IBOutlet weak var imageView: CustomImageView!
    var urlString : String?
    var index = Int()
    var photoData = [HitCodable]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
        // Do any additional setup after loading the view.
        let leftRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(swipeMade(_:)))
           leftRecognizer.direction = .left
        let rightRecognizer = UISwipeGestureRecognizer(target: self, action :#selector(swipeMade(_:)))
           rightRecognizer.direction = .right
           self.view.addGestureRecognizer(leftRecognizer)
           self.view.addGestureRecognizer(rightRecognizer)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        imageView.loadImagesUsingUrl(urlString: urlString!)
    
    }
    
    @IBAction func swipeMade(_ sender: UISwipeGestureRecognizer) {
        
       
       if sender.direction == .left {
         if index == photoData.count - 1 {
             index = 0

         }else{
             index += 1
         }
        
       }
        if sender.direction == .right {
            if index == 0 {
                index = photoData.count - 1
            }else{
                index -= 1
            }
            
        }
        
        imageView.loadImagesUsingUrl(urlString: photoData[index].largeImageURL)
       
    }


}


