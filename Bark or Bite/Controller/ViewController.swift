//
//  ViewController.swift
//  Bark or Bite
//
//  Created by Michael Rivera on 12/13/20.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    
    var imageManager = ImageManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Set up delegate to allow view controller to edit
        imageManager.delegate = self
    }

    @IBAction func buttonTapped(_ sender: UIButton) {
        imageManager.fetchImage()
    }
    
}

//MARK: - Image API Delegate Methods

extension ViewController: ImageManagerDelegate{
    
    func didUpdateImage(_ imageManager: ImageManager, image: ImageModel) {
        DispatchQueue.main.async {
            
            self.imageView.image = self.fetchUIImage(imageString: image.dogImage)
        
        }
    }
    
    func didFailWithError(error: Error) {
        print(error)
    }
    
}

//MARK: - ViewController Functionaility

extension ViewController{
    
    func fetchUIImage(imageString: String) -> UIImage?{
        
        let imageURL = URL(string: imageString)
        
        let imageData = try! Data(contentsOf: imageURL!)
        
        if let image = UIImage(data: imageData){
        
            return image
        }
        
        return nil
    }
}

