//
//  HeroViewController.swift
//  ApiDataWithImages
//
//  Created by Dana Palmer on 12/28/20.
//  Copyright © 2020 Dana Palmer. All rights reserved.
//

import UIKit


extension UIImageView {
    
    
    
    
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




class HeroViewController: UIViewController {

    @IBOutlet weak var ImageView: UIImageView!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var attributeLbl: UILabel!
    @IBOutlet weak var attackLbl: UILabel!
    
    
    @IBOutlet weak var legsLbl: UILabel!
    
    var hero: HeroStats?
    var imageCache = ImageCache.getImageCache() //added for cache
    
    func loadImage(){ //added for cache
        viewDidLoad()
    }
    
 
    //adding to labels
    override func viewDidLoad() {
        super.viewDidLoad()
        nameLbl.text = "Name: \((hero?.localized_name)!)"
        attributeLbl.text = "Attribute:   \((hero?.primary_attr)!)"
        attackLbl.text = "Attack: \((hero?.attack_type)!)"
        
        legsLbl.text = "Legs: \((hero?.legs)!)"
        let urlString = "https://api.opendota.com" + (hero?.img)!
        let urlStringIcon = "https://api.opendota.com" + (hero?.icon)!
        let url = URL(string: urlString)
        ImageView.downloadedFrom(url: url!)
        
        
    }
    

}


//cache
class ImageCache{
    var cache = NSCache<NSString, UIImage>()
    func get(forKey: String) -> UIImage? {
        return cache.object(forKey: NSString(string: forKey))
    }
    func set(forKey: String, image: UIImage){
        cache.setObject(image,forKey: NSString(string: forKey))
    }
}
extension ImageCache{
    private static var imageCache = ImageCache()
    static func getImageCache() -> ImageCache{
        return imageCache
    }
}
