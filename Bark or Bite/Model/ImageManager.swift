//
//  ImageManager.swift
//  Bark or Bite
//
//  Created by Michael Rivera on 12/14/20.
//

import Foundation
import UIKit

protocol ImageManagerDelegate {
    func didUpdateImage(_ imageManager: ImageManager, image: ImageModel)
    func didFailWithError(error: Error)
}

struct ImageManager{
    
    let imageURL = "https://dog.ceo/api/breeds/image/random"
    
    var delegate: ImageManagerDelegate?
    
    func fetchImage(){
        performRequest(with: imageURL)
    }
    
    func performRequest(with urlString: String){
        
        // 1. Create a URL
        if let url = URL(string: urlString){
            
            // 2. Create a URLSession (This is like a web browser searches the url)
            let session = URLSession(configuration: .default)
            
            // 3. Give the session a task to search
            let task = session.dataTask(with: url) { (data, response, error) in
                
                if error != nil {
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                
                if let safeData = data {
                    // Must create a function to parseJSON
                    if let imageString = self.parseJSON(safeData){
                        self.delegate?.didUpdateImage(self, image: imageString)
                    }
                }
            }
            
            // 4. Start the task
            task.resume()
        }
    }
    
    func parseJSON(_ imageData: Data) -> ImageModel?{
        
        // First step is to decode JSON
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(ImageData.self, from: imageData)
            let dogImage = decodedData.message
            let imageJPG = ImageModel(dogImage: dogImage)
            
            return imageJPG
        } catch {
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
    
}
