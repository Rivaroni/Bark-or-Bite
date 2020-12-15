//
//  ViewController.swift
//  Bark or Bite
//
//  Created by Michael Rivera on 12/13/20.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var dogTextLabel: UILabel!
    @IBOutlet weak var chatButton: UIButton!
    @IBOutlet weak var thumbView: UIImageView!
    
    var imageManager = ImageManager()
    
    var previousImages = [UIImage]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Set up delegate to allow view controller to edit
        imageManager.delegate = self
        
        cardView.layer.cornerRadius = 10
        imageView.layer.cornerRadius = 10
    }
    
    @IBAction func buttonTapped(_ sender: UIButton) {
        
        if sender.currentTitle == "Back"{
            fetchPrevious()
            
        } else {
            imageManager.fetchImage()
        }
        
    }
    
    @IBAction func panCard(_ sender: UIPanGestureRecognizer) {
        
        let card = sender.view!
        // point tracks how far u dragged and what direction
        let point = sender.translation(in: view)
        let xFromCenter = card.center.x - view.center.x
        card.center = CGPoint(x: view.center.x + point.x, y: view.center.y + point.y)
        
        if xFromCenter > 0 {
            thumbView.image = UIImage(named: "thumbup")
            thumbView.tintColor = UIColor.green
        } else {
            thumbView.image = UIImage(named: "thumbdown")
            thumbView.tintColor = UIColor.red
        }
        
        thumbView.alpha = abs(xFromCenter / view.center.x)
        
        if sender.state == UIGestureRecognizer.State.ended {
            UIView.animate(withDuration: 0.5) {
                card.center = self.view.center
                self.thumbView.alpha = 0
            }
        }
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
            
            previousImages.append(image)
            
            return image
        }
        
        return nil
    }
    
    func fetchPrevious() {
        if previousImages.count > 1{
            previousImages.removeLast()
            imageView.image = previousImages.last
        }
    }
}

