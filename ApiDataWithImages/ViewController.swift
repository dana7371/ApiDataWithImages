//
//  ViewController.swift
//  ApiDataWithImages
//
//  Created by Dana Palmer on 12/28/20.
//  Copyright © 2020 Dana Palmer. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!
    var heroes = [HeroStats]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        downloadJSON {
            self.tableView.reloadData()
        }
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "MyTableViewCell", bundle: nil), forCellReuseIdentifier: "cell")

        // Do any additional setup after loading the view.
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return heroes.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        
    
        
//        let cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)

        cell.textLabel?.text = heroes[indexPath.row].localized_name.capitalized
         cell.detailTextLabel?.text = heroes[indexPath.row].primary_attr
        //cell.detailTextLabel?.text = "sjdksdjksdjk"
        //cell.imageView?.image = UIImage(named: "dog")

        //for icon images
        let urlStringIcon = "https://api.opendota.com" + (heroes[indexPath.row].icon)
        let url = URL(string: urlStringIcon)
        //cell.imageView!.setImage(url: url!) //error needs to be fixed
        return cell
        }
    
   
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showDetails", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? HeroViewController {
            destination.hero = heroes[(tableView.indexPathForSelectedRow?.row)!]
        }
    }
    
  
         
  
    func downloadJSON(completed: @escaping() -> ()) {
       
        
        let url = URL(string: "https://api.opendota.com/api/heroStats")
        URLSession.shared.dataTask(with: url!) { (data, response, error) in
            if error == nil {
                do{
                    self.heroes = try JSONDecoder().decode([HeroStats].self, from: data!)

                    DispatchQueue.main.async{
                        completed()
                    }
                }catch{
                    print("JSON Error")
                }
            
            
            
          }
        }.resume()
    }
}
 




