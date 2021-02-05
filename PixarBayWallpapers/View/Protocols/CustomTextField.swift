//
//  CustomTextField.swift
//  PixarBayWallpapers
//
//  Created by Anshu Vij on 8/12/20.
//  Copyright © 2020 anshu vij. All rights reserved.
//

//MARK: - CustomSearch Class

import UIKit
import CoreData

class CustomSearchTextField: UITextField{
    
    var dataList : [Search] = [Search]()
    var resultsList : [Search] = [Search]()
    var tableView: UITableView?
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    // Connecting the new element to the parent view
    open override func willMove(toWindow newWindow: UIWindow?) {
        super.willMove(toWindow: newWindow)
        tableView?.removeFromSuperview()
        
    }
    
    override open func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        
        self.addTarget(self, action: #selector(CustomSearchTextField.textFieldDidChange), for: .editingChanged)
        self.addTarget(self, action: #selector(CustomSearchTextField.textFieldDidBeginEditing), for: .editingDidBegin)
        self.addTarget(self, action: #selector(CustomSearchTextField.textFieldDidEndEditing), for: .editingDidEnd)
        self.addTarget(self, action: #selector(CustomSearchTextField.textFieldDidEndEditingOnExit), for: .editingDidEndOnExit)
    }
    
    
    override open func layoutSubviews() {
        super.layoutSubviews()
        buildSearchTableView()
        
    }
    
    
    @objc open func textFieldDidChange(){
        print("Text changed ...")
       
       
    }
    
    @objc open func textFieldDidBeginEditing() {
         filter()
       updateSearchTableView()
        tableView?.isHidden = false
    }
    
    @objc open func textFieldDidEndEditing() {
        print("End editing")
        self.resignFirstResponder()
    

    }
    
    @objc open func textFieldDidEndEditingOnExit() {
        tableView?.isHidden = true
        print("End on Exit")
    }
    
  
    
    //////////////////////////////////////////////////////////////////////////////
    // Data Handling methods
    //////////////////////////////////////////////////////////////////////////////
    
    
    // MARK: CoreData manipulation methods
    
    func saveItems() {
        print("Saving items")
        do {
            try context.save()
        } catch {
            print("Error while saving items: \(error)")
        }
    }
    
    func loadItems(withRequest request : NSFetchRequest<Search>) {
        print("loading items")
        do {
            dataList = try context.fetch(request)
        } catch {
            print("Error while fetching data: \(error)")
        }
    }
    
    
    // MARK: Filtering methods
    
    fileprivate func filter() {
      //  let predicate = NSPredicate(format: "cityName CONTAINS[cd] %@", self.text!)
        let request : NSFetchRequest<Search> = Search.fetchRequest()
        request.returnsDistinctResults = true
        request.fetchLimit = 10
        let sort = NSSortDescriptor(key: #keyPath(Search.date), ascending: false)
        request.sortDescriptors = [sort]
        //request.predicate = predicate

        loadItems(withRequest : request)
        
        resultsList = []
        
        for data in  dataList {

             resultsList.append(data)
            }
        
        tableView?.reloadData()
    }
}

extension CustomSearchTextField: UITableViewDelegate, UITableViewDataSource {

    // MARK: TableView creation and updating
    
    // Create SearchTableview
    func buildSearchTableView() {

        if let tableView = tableView {
            tableView.register(UITableViewCell.self, forCellReuseIdentifier: "CustomSearchTextFieldCell")
            tableView.delegate = self
            tableView.dataSource = self
            self.window?.addSubview(tableView)

        } else {
           // addData()
            print("tableView created")
            tableView = UITableView(frame: CGRect.zero)
        }
        
        //updateSearchTableView()
    }
    
    // Updating SearchtableView
    func updateSearchTableView() {
        
        if let tableView = tableView {
            superview?.bringSubviewToFront(tableView)
            var tableHeight: CGFloat = 0
            tableHeight = tableView.contentSize.height
            
            // Set a bottom margin of 10p
            if tableHeight < tableView.contentSize.height {
                tableHeight -= 10
            }
            
            // Set tableView frame
            var tableViewFrame = CGRect(x: 0, y: 0, width: frame.size.width - 4, height: tableHeight)
            tableViewFrame.origin = self.convert(tableViewFrame.origin, to: nil)
            tableViewFrame.origin.x += 2
            tableViewFrame.origin.y += frame.size.height + 2
            UIView.animate(withDuration: 0.2, animations: { [weak self] in
                self?.tableView?.frame = tableViewFrame
            })
            
            //Setting tableView style
            tableView.layer.masksToBounds = true
            tableView.separatorInset = UIEdgeInsets.zero
            tableView.layer.cornerRadius = 5.0
            tableView.separatorColor = UIColor.white
            tableView.backgroundColor = UIColor(red: 151/255, green: 171/255, blue: 190/255, alpha: 1.0)
            
            if self.isFirstResponder {
                superview?.bringSubviewToFront(self)
            }
            
            tableView.reloadData()
        }
    }
    
    
    
    // MARK: TableViewDataSource methods
    public func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      
        return resultsList.count
    }
    
    // MARK: TableViewDelegate methods
    
    //Adding rows in the tableview with the data from dataList

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomSearchTextFieldCell", for: indexPath) as UITableViewCell
        cell.backgroundColor = UIColor.clear
        cell.textLabel?.text = resultsList[indexPath.row].searchText
        return cell
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("selected row")
        self.text = resultsList[indexPath.row].searchText
        tableView.isHidden = true
        self.endEditing(true)
    }
    

    // MARK: Early testing methods
//    func addData(){
//        let a = Search(context: context)
//        a.searchText = "Roses"
//        let b = Search(context: context)
//        b.searchText = "Tiger"
//        let c = Search(context: context)
//        c.searchText = "Horse"
//        let d = Search(context: context)
//        d.searchText = "Lion"
//
//
//        saveItems()
//
//        dataList.append(a)
//        dataList.append(b)
//        dataList.append(c)
//        dataList.append(d)
//
//    }
    
}

