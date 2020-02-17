//
//  HomeTableViewController.swift
//  Twitter
//
//  Created by EatMoreOranges on 2/7/20.
//  Copyright © 2020 Dan. All rights reserved.
//

import UIKit

class HomeTableViewController: UITableViewController {


    var tweetArray = [NSDictionary]()
    var numberOfTweet: Int! //notice that there is a ":" instead of an "="
    let myRefreshControl = UIRefreshControl()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        loadTweets()
        myRefreshControl.addTarget(self, action: #selector(loadTweets), for: .valueChanged)
        self.tableView.refreshControl = myRefreshControl
        //
       // self.tweetTable.rowHeight = UITableView.automaticDimensions
    // self.tweetTable.estimatedRowHeight = 150
        
    }
    
    // __vvvv__ not automatically showing new tweet for some reason
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        loadTweets()
        print("didnt i tell you it will be alright")
    }
    
    
    @objc func loadTweets(){
        
        numberOfTweet = 20
        let myURL = "https://api.twitter.com/1.1/statuses/home_timeline.json" //where you get the tweets from
        let myParams = ["count": numberOfTweet] // could also put ["count": 10, "id": "blah", "whatever-else-can-be-found-in-parameters": "oh ok!"]
        
        TwitterAPICaller.client?.getDictionariesRequest(url: myURL, parameters: myParams, success: { (tweets: [NSDictionary]) in //name of array givrn = tweets
            self.tweetArray.removeAll()//clean up the array
            for tweet in tweets{
                self.tweetArray.append(tweet)
            }
            self.tableView.reloadData()
            self.myRefreshControl.endRefreshing()// stops the spinning wheel
            
        }, failure: { (Error) in
            print("could not retrieve tweets")
        })
    }
    
    
    
    func loadMoreTweets(){
        //this function is almost the same as load tweets but this adds to that loadTweets has
        let myUrl = "https://api.twitter.com/1.1/statuses/home_timeline.json"
        numberOfTweet = numberOfTweet + 20
        let myParams = ["count": numberOfTweet]
        
        TwitterAPICaller.client?.getDictionariesRequest(url: myUrl, parameters: myParams, success: { (tweets: [NSDictionary]) in //name of array givrn = tweets
            self.tweetArray.removeAll()//clean up the array
            for tweet in tweets{
                self.tweetArray.append(tweet)
            }
            self.tableView.reloadData()
            self.myRefreshControl.endRefreshing()// stops the spinning wheel
            
        }, failure: { (Error) in
            print("could not retrieve more tweets")
        })
    }
    
    
    // this is used for infinate scrolling
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row + 1 == tweetArray.count{ //when you get to the end of the page load more tweets
            loadMoreTweets()
        }
    
    }
    
    
    
    @IBAction func onLogout(_ sender: Any) {
        TwitterAPICaller.client?.logout()
        self.dismiss(animated: true, completion: nil)
        //the line bellow is how to log out
        UserDefaults.standard.set(false, forKey: "userLoggedIn")
    }
    
    
    
    //bellow is the code for the cell you created
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tweetCell", for: indexPath) as! TweetCellTableViewCell
        // the above line makes the tableViews we create a type of tweetCellTableViewCell so we can utilize the features of tweetCellTableViewCell in our new tableView
        
        let user = tweetArray[indexPath.row]["user"] as! NSDictionary
        
        cell.userNameLabel.text = user["name"] as! String//"Jesus the Christ"
        cell.tweetContent.text = tweetArray[indexPath.row]["text"] as! String
//        cell.timeLabel.text = getRelativeTime(timeString: (tweetArray[indexPath.row]["created at"] as? String)!)
//        //setting up the image
        let imageUrl = URL(string: (user["profile_image_url_https"] as? String)!)
        let data = try? Data(contentsOf: imageUrl!)
        if let imageData = data {
            cell.profileImageView.image = UIImage(data: imageData)
        }
        
    
        cell.setFavorite(tweetArray[indexPath.row]["favorited"] as! Bool)
        cell.tweetId = tweetArray[indexPath.row]["id"] as! Int
        
        return cell
    }
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return tweetArray.count
    }

    
}
