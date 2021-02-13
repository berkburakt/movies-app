//
//  MovieDetailsViewController.swift
//  flixster
//
//  Created by Berk Burak Tasdemir on 2/13/21.
//

import UIKit
import AlamofireImage

class MovieDetailsViewController: UIViewController {

    @IBOutlet weak var backdropView: UIImageView!
    @IBOutlet weak var posterView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var synopsisLabel: UILabel!
    
    var movie: [String:Any]!
    private var youtubePath: String? {
        didSet {
            addTapGestureToPosterView()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureVideoUrl()
        configureLabels()
        configureImages()
    }
    
    private func configureLabels() {
        titleLabel.text = movie["title"] as? String
        titleLabel.sizeToFit()
        
        synopsisLabel.text = movie["overview"] as? String
        synopsisLabel.sizeToFit()
    }
    
    private func configureImages() {
        let basePosterUrl = "https://image.tmdb.org/t/p/w185"
        let posterPath = movie["poster_path"] as? String ?? ""
        let posterUrl = URL(string: basePosterUrl + posterPath)
        
        posterView.af.setImage(withURL: posterUrl!)
        
        let baseBackdropUrl = "https://image.tmdb.org/t/p/w780"
        let backdropPath = movie["backdrop_path"] as? String ?? ""
        let backdropUrl = URL(string: baseBackdropUrl + backdropPath)
        
        backdropView.af.setImage(withURL: backdropUrl!)
    }
    
    private func addTapGestureToPosterView() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(MovieDetailsViewController.posterViewTap))
        posterView.addGestureRecognizer(tap)
        posterView.isUserInteractionEnabled = true
    }
    
    private func configureVideoUrl() {
        if let id = movie["id"] as? Int {
            let path =  "https://api.themoviedb.org/3/movie/\(id)/videos?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed"
            if let url = URL(string: path) {
                getApi(url: url)
            }
           
        }
    }
    
    private func getApi(url: URL) {
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        let task = session.dataTask(with: request) { (data, response, error) in
            // This will run when the network request returns
            if let error = error {
                print(error.localizedDescription)
            } else if let data = data {
                let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
                if let result = dataDictionary["results"] as? [[String:Any]] {
                    if let key = result[0]["key"] as? String {
                        self.youtubePath = "https://www.youtube.com/watch?v=\(key)"
                        
                    }
                }
            }
        }
        task.resume()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "videoSegue" {
            let vc = segue.destination as! VideoViewController
            vc.urlPath = self.youtubePath
        }
    }
    
    @objc private func posterViewTap() {
        performSegue(withIdentifier: "videoSegue", sender: self)
    }
}
