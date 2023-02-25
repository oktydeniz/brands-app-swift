//
//  ViewController.swift
//  markalar
//
//  Created by oktay on 23.02.2023.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var backItem: UIBarButtonItem!
    var data: [String] = []
    var dataDescriptions: [String] = []
    var dataDescription: String = ""
    var fileUrl: URL!
    var selectedRow:Int = -1
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        self.loadNavigationView()
        self.loadData()
        
        let baseUrl = try! FileManager.default.url(for: FileManager.SearchPathDirectory.documentDirectory, in: FileManager.SearchPathDomainMask.userDomainMask, appropriateFor: nil, create: false)
        print(baseUrl)
        
        fileUrl = baseUrl.appendingPathComponent("Brands.txt")
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if (selectedRow == -1) {
            return
        }
        if (dataDescription ==  "") {
            dataDescriptions.remove(at: selectedRow)
            data.remove(at: selectedRow)
        } else if dataDescription == dataDescriptions[selectedRow] {
            return
        }
        else {
            dataDescriptions[selectedRow] = dataDescription
        }
       
        savaData()
        tableView.reloadData()
    }
    
    
    
    func loadNavigationView(){
        self.navigationItem.largeTitleDisplayMode = .always
        self.title = "All Brands"
        self.navigationController?.navigationBar.prefersLargeTitles = true
        
        let addButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.add, target: self, action: #selector(addButtonClicked))
        addButton.tintColor = UIColor.tintColor
        self.navigationItem.leftBarButtonItem = addButton
        
        let editButton = editButtonItem
        self.navigationItem.leftBarButtonItems?.append(editButton)
    }
    
    @objc func addButtonClicked() {
        self.createAlertForAdding()
    }
    
    func addingNewBrand(brandName: String) {
        data.append(brandName)
        let indexPath :IndexPath = IndexPath(row: data.count-1, section: 0)
        //data.insert(brandName, at: 0)
        //let indexPath : IndexPath = IndexPath(row: 0, section: 0)
        dataDescriptions.insert(" ", at: indexPath.row)
        tableView.insertRows(at: [indexPath], with: UITableView.RowAnimation.left)
        self.savaData()
        tableView.selectRow(at: indexPath, animated: true, scrollPosition: .none)
        performSegue(withIdentifier: "goDetails", sender: self)
        
    }
    
    func createAlertForAdding() {
        if tableView.isEditing == true {
            return
        }
        let controller = UIAlertController(title:"Add New Brand", message:"Start  typing to enter new brand", preferredStyle:UIAlertController.Style.alert)
        
        controller.addTextField(configurationHandler: {
            textBrandName in
            textBrandName.placeholder = "Brand Name"
        })
        
        let action = UIAlertAction(title: "Add", style: UIAlertAction.Style.default, handler: {
            action in
            let firstTexfield = controller.textFields![0] as UITextField
            self.addingNewBrand(brandName: firstTexfield.text!)
        })
        let cancelAction = UIAlertAction(title: "Cancel", style:UIAlertAction.Style.cancel, handler: nil)
        
        controller.addAction(action)
        controller.addAction(cancelAction)
        self.present(controller, animated: true, completion: nil)
    }
    
    
    @IBAction func actionBarItem(_ sender: Any) {
        self.createAlertForAdding()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell")!
        cell.textLabel?.text = self.data[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.data.count
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        tableView.setEditing(editing, animated: animated)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            data.remove(at: indexPath.row)
            dataDescriptions.remove(at: indexPath.row)
            tableView.deleteRows(at:  [indexPath], with: UITableView.RowAnimation.left)
            self.savaData()
        }
    }
    
    func savaData () {
        UserDefaults.standard.set(data, forKey: "brands")
        UserDefaults.standard.set(dataDescriptions, forKey: "descriptions")
       

    }
    
    func loadData() {
        if let brands: [String] = UserDefaults.standard.value(forKey: "brands") as? [String] {
            data = brands
            
        }
        if let desc: [String] = UserDefaults.standard.value(forKey: "descriptions") as? [String] {
            self.dataDescriptions = desc
        }
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "goDetails", sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let description : DetailsViewController = segue.destination as! DetailsViewController
        selectedRow = tableView.indexPathForSelectedRow!.row
        description.viewController = self
        description.setDesc(d: dataDescriptions[selectedRow])
        
        
    }
    
}

