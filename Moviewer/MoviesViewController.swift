//
//  MoviesViewController.swift
//  Moviewer
//
//  Created by Maliha Fairooz on 2/12/16.
//  Copyright © 2016 Maliha Fairooz. All rights reserved.
//

import UIKit
import AFNetworking
import MBProgressHUD

class MoviesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    var movies: [NSDictionary]?
    var endpoint: String!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: "refreshControlAction:", forControlEvents: UIControlEvents.ValueChanged)
        tableView.insertSubview(refreshControl, atIndex: 0)
        
        let apiKey = "a07e22bc18f5cb106bfe4cc1f83ad8ed"
        let url = NSURL(string: "https://api.themoviedb.org/3/movie/\(endpoint)?api_key=\(apiKey)")
        let request = NSURLRequest(
            URL: url!,
            cachePolicy: NSURLRequestCachePolicy.ReloadIgnoringLocalCacheData,
            timeoutInterval: 10)
        
        let session = NSURLSession(
            configuration: NSURLSessionConfiguration.defaultSessionConfiguration(),
            delegate: nil,
            delegateQueue: NSOperationQueue.mainQueue()
        )
        
        MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        
        let task: NSURLSessionDataTask = session.dataTaskWithRequest(request,
            completionHandler: { (dataOrNil, response, error) in
                if let data = dataOrNil {
                    if let responseDictionary = try! NSJSONSerialization.JSONObjectWithData(
                        data, options:[]) as? NSDictionary {
                            print("response: \(responseDictionary)")
                            
                            MBProgressHUD.hideHUDForView(self.view, animated: true)
                            
                            self.movies = responseDictionary["results"] as? [NSDictionary]
                            self.tableView.reloadData()
                            
                    }
                }
        })
        task.resume()

    }
    
     func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    
     {
        if let movies = movies {
            return movies.count
        }
        else
        {
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    
    {
        
        
        
        let cell = tableView.dequeueReusableCellWithIdentifier("MovieCell", forIndexPath: indexPath) as! MovieCell
        
        //cell.selectionStyle = .None
        
        let backgroundView = UIView()
        backgroundView.backgroundColor = UIColor.blueColor()
        cell.selectedBackgroundView = backgroundView
        
        
        let movie = movies![indexPath.row]
        let title = movie ["title"] as! String
        let overview = movie["overview"] as! String
        
        cell.titleLabel.text = title
        cell.overviewLabel.text = overview
        
        let baseUrl = "http://image.tmdb.org/t/p/w500"
        
        
        if let posterPath = movie["poster_path"] as? String
        {
            let imageUrl = NSURL(string: baseUrl + posterPath)
            cell.posterView.setImageWithURL(imageUrl!)
        }
    
        // cell.textLabel!.text = title
        print("row \(indexPath.row)")
        return cell
        
    }
    
    func refreshControlAction(refreshControl: UIRefreshControl) {
        
        self.tableView.reloadData()
        refreshControl.endRefreshing()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    let cell = sender as! UITableViewCell
    let indexPath = tableView.indexPathForCell(cell)
    let movie = movies![indexPath!.row]
    let detailViewController = segue.destinationViewController as! DetailViewController
        detailViewController.movie = movie
        
        
        
    
    print("Prepare for segue")
    }

}
