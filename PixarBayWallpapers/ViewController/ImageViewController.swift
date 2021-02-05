//
//  ImageViewController.swift
//  PixarBayWallpapers
//
//  Created by Anshu Vij on 8/9/20.
//  Copyright © 2020 anshu vij. All rights reserved.
//

import UIKit
import CoreData

class ImageViewController: UIViewController {
    
    
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var searchBar: CustomSearchTextField!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var vSpinner : UIView?
    var photoManager = PhotoManager()
    var photoData = [HitCodable]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var imageURL = "https://picsum.photos/300/300?image"
    var pageNumber = 0
    var searchedText : String?
    var isComingFromLoadMore = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        setupCollectionView()
        
        photoManager.delegate = self
        searchBar.delegate = self
        
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.showSpinner(onView: self.view)
        searchBar.tableView?.isHidden = true
        photoManager.fetchPhotoList()
    }
    
    func setupView()
    {
        self.navigationItem.title = Constants.title
        navigationController?.navigationBar.tintColor = UIColor.black
        navigationController?.navigationBar.barTintColor = UIColor(red: 230/255, green: 103/255, blue: 76/255, alpha: 1.0)
    }
    
    func setupCollectionView()
    {
        collectionView.register(UINib(nibName: Constants.cellIdentifer, bundle: nil), forCellWithReuseIdentifier: Constants.cellIdentifer)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.collectionViewLayout = UICollectionViewFlowLayout()
    }
    
    
    @IBAction func searchButtonPressed(_ sender: UIButton) {
        searchText()
    }
    
    func searchText()
    {
        isComingFromLoadMore = false
        pageNumber = 0
        searchBar.tableView?.isHidden = true
        if let searchText = searchBar.text, searchBar.text!.count > 0 {
            searchedText = searchBar.text
            photoManager.fetchPhotoList(searchText)
            self.showSpinner(onView: self.view)
            
        }
        
    }
    
    func showAlert()
    {
        self.removeSpinner()
        let alert = UIAlertController(title: "Sorry!", message: "No Image found", preferredStyle: UIAlertController.Style.alert)
        
        // add an action (button)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        
        // show the alert
        self.present(alert, animated: true, completion: nil)
    }
    
    func saveItems() {
        print("Saving items")
        do {
            try context.save()
        } catch {
            print("Error while saving items: \(error)")
        }
    }
    
    
}
//MARK: - CollectionViewDataSource Methods
extension ImageViewController : UICollectionViewDataSource {

    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photoData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier:Constants.cellIdentifer, for: indexPath) as! PhotoCollectionViewCell
        
        let photoValues = photoData[indexPath.row]
        let urlS = "\(photoValues.webformatURL)"
        
        
        cell.imageView.loadImagesUsingUrl(urlString: urlS)
        
        return cell
        
        
    }
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        
        if indexPath.row == photoData.count - 1 {
            isComingFromLoadMore = true
            self.showSpinner(onView: self.view)
            self.pageNumber += 1
            photoManager.fetchPhotoList(searchedText ?? Constants.defaultSearch,pageNumber)
            
        }
        
    }
    
    
}

//MARK: - CollectionViewDelegate Methods
extension ImageViewController : UICollectionViewDelegate
{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        
        print(self.photoData[indexPath.row].largeImageURL)
        
        DispatchQueue.main.async {
            let fullImageVC = FullImageViewController()
            let photoData = self.photoData[indexPath.row]
            fullImageVC.urlString = "\(photoData.largeImageURL)"
            fullImageVC.index = indexPath.row
            fullImageVC.photoData = self.photoData
            self.navigationController?.pushViewController(fullImageVC, animated: true)
        }
        
        
    }
    
}

extension ImageViewController : UICollectionViewDelegateFlowLayout
{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width-4
        return CGSize(width: width, height: width/2)
    }
    
    internal func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
}
//MARK: - PhotoManager Delegate Methods
extension ImageViewController : PhotoManagerDelegate {
    func getPhotoList(_ photoManager: PhotoManager, photoData: PhotoData) {
        
        
        self.removeSpinner()
        
        if photoData.hits.count > 0
        {
            if !isComingFromLoadMore
            {
                self.photoData.removeAll()
            }
            for hits in photoData.hits {
                self.photoData.append(hits)
            }
            
            
            DispatchQueue.main.async {
                if let text = self.searchBar.text, self.searchBar.text!.count>0{
                    let search = Search(context: self.context)
                    search.searchText = text
                    search.date = Date()
                    self.saveItems()
                    self.searchBar.text = ""
                }
                
                self.collectionView.reloadData()
                
            }
        }
        else
        {
            DispatchQueue.main.async {
                self.showAlert()
            }
        }
    }
    
    func didFailWithError(error: Error) {
        DispatchQueue.main.async {
            self.showAlert()
        }
        
    }
}

//MARK: - UITextField Delegate Methods
extension ImageViewController: UITextFieldDelegate {
    
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        searchBar.resignFirstResponder()
        
        searchText()
    }
    
}

//MARK: - ImageViewController Extension
extension ImageViewController {
    
    func showSpinner(onView : UIView) {
        let spinnerView = UIView.init(frame: onView.bounds)
        spinnerView.backgroundColor = UIColor.init(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5)
        let ai = UIActivityIndicatorView.init(style: .large)
        ai.startAnimating()
        ai.center = spinnerView.center
        
        DispatchQueue.main.async {
            spinnerView.addSubview(ai)
            onView.addSubview(spinnerView)
        }
        
        self.vSpinner = spinnerView
    }
    
    func removeSpinner() {
        DispatchQueue.main.async {
            self.vSpinner?.removeFromSuperview()
            self.vSpinner = nil
        }
    }
}


