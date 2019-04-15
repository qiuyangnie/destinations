//
//  CityTableViewController.swift
//  QiuyangNieAssign2
//
//  Created by Qiuyang Nie on 11/04/2019.
//  Copyright © 2019 Qiuyang Nie. All rights reserved.
//

import UIKit
import CoreData

class CitiesTableViewController: UITableViewController, NSFetchedResultsControllerDelegate, UISearchBarDelegate {
    
    @IBOutlet weak var searchBar: UISearchBar!
    var searchText: String! = nil
    
    // XML parser
    private var parser = CitiesXMLParser(xmlFileName: "cities.xml")
    
    // CoreData objects: context, entities, managedObject, frc(fetch result controller)
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    private var entity: NSEntityDescription! = nil
    private var citiesManagedObject: Cities! = nil
    private var frc: NSFetchedResultsController<NSFetchRequestResult>! = nil
    
  
    func makeRequest() -> NSFetchRequest<NSFetchRequestResult> {
        // make a request for entity City
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Cities")
        
        // describe how to sort and how to filter it
        let sorter = NSSortDescriptor(key: "name", ascending: true)
        request.sortDescriptors = [sorter]
        
        return request
    }
    
    func makeRequestWithSearch() -> NSFetchRequest<NSFetchRequestResult> {
        // make a request for entity City
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Cities")
    
        request.predicate = NSPredicate(format: "name CONTAINS %@", self.searchText)
        
        // describe how to sort and how to filter it
        let sorter = NSSortDescriptor(key: "name", ascending: true)
        request.sortDescriptors = [sorter]
        
        return request
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.reloadData()
    }
    
    func deleteAllData(entity: String) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        fetchRequest.returnsObjectsAsFaults = false
        
        do
        {
            let results = try managedContext.fetch(fetchRequest)
            for managedObject in results
            {
                let managedObjectData:NSManagedObject = managedObject as! NSManagedObject
                managedContext.delete(managedObjectData)
            }
        } catch let error as NSError {
            print("Delete all data in \(entity) error : \(error) \(error.userInfo)")
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // search bar text color
        let textFieldInsideSearchBar = searchBar.value(forKey: "searchField") as? UITextField
        textFieldInsideSearchBar?.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
    
        searchBar.delegate = self
        
        title = "Travel Plan 2019: Top Cities"
        
        // reset CoreData
        deleteAllData(entity: "Cities")
        // parse XML file
        parser.parsing()
        
        // make frc and fetch
        frc = NSFetchedResultsController(fetchRequest: makeRequest(), managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        frc.delegate = self
    
        
        do { try frc.performFetch() }
        catch { print("Fetching does not work")}
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return frc.sections![section].numberOfObjects
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        citiesManagedObject = (frc.object(at: indexPath) as! Cities)
        cell.textLabel?.text = citiesManagedObject.name
        cell.detailTextLabel?.text = citiesManagedObject.state
        cell.imageView?.image = UIImage(named: citiesManagedObject.image!)
        //cell.imageView?.image = UIImage(contentsOfFile: citiesManagedObject.image!)
        return cell
    }
    

    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }


    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {

            citiesManagedObject = frc.object(at: indexPath) as! Cities
            context.delete(citiesManagedObject)

            do {try context.save()} catch {}
            do {try frc.performFetch()} catch {}

            tableView.reloadData()

        }
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print("Search text: \(searchText)")
        self.searchText = searchText
        
        if searchText.count == 0 {
            
            frc = NSFetchedResultsController(fetchRequest: makeRequest(), managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
            frc.delegate = self
            do { try frc.performFetch() }
            catch { print("Fetching does not work")}
            tableView.reloadData()
            
        } else {
            
            frc = NSFetchedResultsController(fetchRequest: makeRequestWithSearch(), managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
            frc.delegate = self
            do { try frc.performFetch() }
            catch { print("Fetching does not work")}
            tableView.reloadData()
            
        }
  
    }

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "cellSegue") {
            let destination = segue.destination as! AddViewController
            let indexPath = tableView.indexPath(for: sender as! UITableViewCell)
            citiesManagedObject = (frc.object(at: indexPath!) as! Cities)
            destination.citiesManagedObject = citiesManagedObject
        }
    }
    

    
}
