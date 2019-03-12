//
//  ViewController.swift
//  Thunder Music Player
//
//  Created by OSX on 3/12/19.
//  Copyright © 2019 AppDoctor. All rights reserved.
//

import UIKit
import SwiftSoup
import Foundation
import CoreData

class ViewController: UIViewController {

    
    var dataTester = DataTester()
    
    
    
    let helpingArray = ["one" , "two", "threee"]
    var coreDataLogic = CoreDataLogic()
    
    
    
  
    @IBOutlet weak var urlTextLabel: UITextField!
    
    
    @IBOutlet weak var saveOutlet: UIButton!
    
    @IBOutlet weak var youtubeOutlet: UIButton!
    

    
    
    @IBOutlet weak var tableVController: UITableView!
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        tableVController.delegate=self
        tableVController.dataSource=self
        
    }
    
    func createData(){
        print("TO WRITE DATA TO CORE DATA")
        
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        
        let managedContext = appDelegate.persistentContainer.viewContext
       
        
        let SongsEntity = NSEntityDescription.entity(forEntityName: "Songs", in: managedContext)!
        
        guard let nameFromLabel = urlTextLabel.text else {return}
        
        for i in 1...5 {
            let user = NSManagedObject(entity: SongsEntity, insertInto: managedContext)
            
            user.setValue("name: \(nameFromLabel) \(i)", forKey: "name")
            user.setValue("url: \(nameFromLabel) \(i)", forKey: "url")
        }
        
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
        
        
        }
    
    @IBAction func buSave(_ sender: Any) {
        guard let url = urlTextLabel.text else {return }
        coreDataLogic.createData(nameFromLabel: url)
//        createData()
        
        
    }
    

    
    func retreiveData() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Songs")
        
        do {
            let result = try managedContext.fetch(fetchRequest)
            for data in result as! [NSManagedObject] {
                
                print(data.value(forKey: "name") as! String)
                print(data.value(forKey: "url") as! String)
                
                
            }
            
        } catch {
            print("Failed")
        }
        
        
    }
    
    func updateData() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest.init(entityName: "Songs")
        
        fetchRequest.predicate = NSPredicate(format: "name = %@", "Ankur1")
        
        do
        {
          let test = try managedContext.fetch(fetchRequest)
            
            let objectUpdate = test[0] as! NSManagedObject
            objectUpdate.setValue("newName", forKey: "name")
            objectUpdate.setValue("newURL", forKey: "url")
            
            do {
                try managedContext.save()
            }catch {
                print(error)
            }
            
        }catch {
            print(error)
            
        }
        
    }
    
    
    func deleteData() {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Songs")
        fetchRequest.predicate = NSPredicate(format: "name = %@", "Ankur3")
        
        do {
            let test = try managedContext.fetch(fetchRequest)
            
            let objectToDelete = test[0] as! NSManagedObject
            managedContext.delete(objectToDelete)
            
            do {
                try managedContext.save()
                
            } catch {
                
                print(error)
            }
            
        }catch {
            print(error)
            
            
        }
        
        
    }
    
    
    
    
    
    @IBAction func buYoutube(_ sender: Any) {
        
        
        coreDataLogic.retreiveData()
//        dataTester.coreDataResultsPrinter()
        coreDataLogic.goodFetch()
        
    }
    
}


extension ViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return helpingArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        let name = helpingArray[indexPath.row]
        cell?.textLabel?.text = name
        
        
        return cell!
    }
    
    
    
    
    
}



