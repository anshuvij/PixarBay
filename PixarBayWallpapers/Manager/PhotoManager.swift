
import Foundation

struct PhotoManager {
    let photoListUrl = "https://pixabay.com/api/?key=17827519-40212fac8db0ddde426065636&q="
    
  
    var delegate : PhotoManagerDelegate?
 
    
    func fetchPhotoList(_ text : String = "orange", _ pageNumber : Int = 1)
    {
        var  urlString = "\(photoListUrl)\(text)&image_type=photo&page=\(pageNumber)"
        urlString = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        print(urlString)
        performRequest(with: urlString)
    }
    
     func performRequest(with urlString : String)
     {
        if let url  = URL(string: urlString){
            let session = URLSession(configuration: .default)
            
            let task = session.dataTask(with: url) { (data, response, error) in
                
                
                if error != nil {
                      self.delegate?.didFailWithError(error: error!)
                    return
                }
                
                if let safeData = data
                {
                    let photoData = self.parseJSON(safeData)
                    self.delegate?.getPhotoList(self, photoData: photoData)
                    
                }
                
            }
            
            task.resume()
        }
        
    }
    
    
     func parseJSON( _ photoData : Data) -> PhotoData
    {
        var photoarray:PhotoData?
        let decoder = JSONDecoder()
            do {
                let decodeData : PhotoData = try decoder.decode(PhotoData.self, from: photoData)
               photoarray = decodeData
            }
        catch {
            self.delegate?.didFailWithError(error: error)
            return photoarray!
            
        }

        return photoarray!
    }
}
