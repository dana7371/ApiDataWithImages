//
//  HeroViewController.swift
//  ApiDataWithImages
//
//  Created by Dana Palmer on 12/28/20.
//  Copyright © 2020 Dana Palmer. All rights reserved.
//

import UIKit



let imageCache = NSCache<AnyObject, AnyObject>() //added
class CustomImageView: UIImageView {
    
    var ImageUrlString: URL?
    
    func setImage(from url: URL, contentMode mode: UIView.ContentMode = .scaleAspectFit) {
        contentMode = mode
        ImageUrlString = url
        if let imageFromCache = imageCache.object(forKey: url as AnyObject) {
            self.image = imageFromCache as? UIImage
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let imageToCache = UIImage(data: data)
                else { return }
            DispatchQueue.main.async() {
                if self.ImageUrlString == url {
                    self.image = imageToCache
                }
                imageCache.setObject(imageToCache, forKey: url as AnyObject)
            }
        }.resume()
    }
    func setImage(from link: String, contentMode mode: UIView.ContentMode = .scaleAspectFit) {
        guard let url = URL(string: link) else { return }
        setImage(from: url, contentMode: mode)
    }
}

//without cache
/*extension UIImageView {
    func downloadedFrom(url: URL, contentMode mode: UIView.ContentMode = .scaleAspectFit) {
            contentMode = mode
           URLSession.shared.dataTask(with: url) { data, response, error in
               guard
                    let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                    let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                    let data = data, error == nil,
                    let image = UIImage(data: data)
                    else { return }
                DispatchQueue.main.async() {
                    self.image = image
                }
                }.resume()
        }
        func downloadedFrom(link: String, contentMode mode: UIView.ContentMode = .scaleAspectFit) {
            guard let url = URL(string: link) else { return }
           downloadedFrom(url: url, contentMode: mode)
        }
    }
*/



class HeroViewController: UIViewController {
    @IBOutlet weak var ImageView: CustomImageView! //changed from ImageView to CustomImageView
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var attributeLbl: UILabel!
    @IBOutlet weak var attackLbl: UILabel!
    @IBOutlet weak var legsLbl: UILabel!
    
    var hero: HeroStats?
   
 
    //adding to labels
    override func viewDidLoad() {
        super.viewDidLoad()
        nameLbl.text = "Name: \((hero?.localized_name)!)"
        attributeLbl.text = "Attribute:   \((hero?.primary_attr)!)"
        attackLbl.text = "Attack: \((hero?.attack_type)!)"
        legsLbl.text = "Legs: \((hero?.legs)!)"
        
        //image
        let urlString = "https://api.opendota.com" + (hero?.img)!
        let url = URL(string: urlString)
        ImageView.setImage(from: url!) //fixed :)
      
    }
    

}


