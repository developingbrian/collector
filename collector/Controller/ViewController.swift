//
//  ViewController.swift
//  collector
//
//  Created by Brian on 3/10/20.
//  Copyright © 2020 Brian. All rights reserved.
//

import UIKit
import SDWebImage

class ViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource,UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var platformPicker: UIPickerView!
    @IBOutlet weak var tableviewPlatformImage: UIImageView!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var platformLabel: UILabel!
    
    var games = [Game]()
//    var game : Game?
    var game: ByPlatformIDData?
//    var games = [ByPlatformIDData]()
//    var boxart = [Boxart]()
    var gameImageData = [Images.Inner]()
//        [ByPlatformIDData]()
//    var companies = [Companies]()
//    var platforms = [Platform]()
//    var platform : Platform?
//    var company : Companies?
    var pickerData : [String] = [String]()
    var picked : Int = 18
    var gdbPlatformID : Int = 7
    var imageName = ""
    var gameNamed : String?
    var searchString : String?
    var currentOffset : Int = 0
    //    var currentPlatform : Int?
    var currentGame : String?
    var initialOffset = 0
//    let networking = NetworkService()
    let network = Networking()
    var gradient : CAGradientLayer!
    
    let fields = "players,publishers,genres,overview,last_updated,rating,platform,coop,youtube,os,processor,ram,hdd,video,sound,alternates"
    let include = "boxart,platform"
    let test = Networking()
    var coverImage : UIImage?
    var rearCoverImage : UIImage?
    var pageURL: String?
    var countInt = 0
    var imageArray: [UIImageView] = []
    var imageToArray = UIImageView()
    var gameObject : [GDBGamesPlatform]?
    var cache : NSCache<AnyObject, AnyObject>!
    var rearImageCache : NSCache<AnyObject, AnyObject>!
    var gameCartImageCache : NSCache<AnyObject, AnyObject>!
    var tableData: [AnyObject]!
    var fetchingMore = false
//    let rearImageView: UIImageView
    
//    let test2: ByPlatformIDData
    var segueFrontImageName : String?
    var segueRearImageName : String?
    
    
    
//MARK: viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
         if self.traitCollection.userInterfaceStyle == .light {
        
                tableView.backgroundColor = UIColor(red: (246/255), green: (246/255), blue: (246/255), alpha: 1)
              
            } else {

                tableView.backgroundColor = UIColor(red: (15/255), green: (15/255), blue: (15/255), alpha: 1)

        }
        
        self.network.downloadDevelopersJSON {
        print("Developer JSON downloaded")
           }
        self.network.downloadGenreJSON {
            print("Genre JSON downloaded")
            
        
        }
        
        
        
        
        
//        gradient = CAGradientLayer()
//        gradient.frame = 
        
        searchTextField.borderStyle = .roundedRect
        var searchButton = UIButton(frame: CGRect(x: 0, y: 0, width: 24, height: 24))
        searchButton.setTitle( "🔍", for: .normal)
        searchTextField.rightViewMode = .always
        searchTextField.rightView = searchButton
        searchButton.layer.opacity = 0.5
        searchButton.addTarget(self, action: #selector(searchButtonPressed(_:)), for: .touchUpInside)
        searchTextField.layer.shadowOffset = CGSize(width: 5, height: 5)
        searchTextField.layer.shadowRadius = 5
        searchTextField.layer.shadowOpacity = 0.1
        searchTextField.layer.masksToBounds = false
        searchTextField.clipsToBounds = false
        setForDarkMode()
//        searchButton.backgroundColor = UIColor.black

//        cache.removeAllObjects()
        
        self.cache = NSCache()
        self.rearImageCache = NSCache()
        self.gameCartImageCache = NSCache()
        self.tableData = []
        
        gameObject = network.games
        
//        self.network.games.removeAll()

        
//        self.network.downloadPublishersJSON {
//            print("Publisher JSON downloaded")
//            self.tableView.reloadData()
//        }
        
        self.platformPicker.delegate = self
        self.platformPicker.dataSource = self
        tableView.delegate = self
        tableView.dataSource = self
        
        
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:)))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
//        self.network.gamesByPlatformID?.data.games.removeAll()
//        games.removeAll()
        
        pickerData = ["NES", "SNES", "Nintendo 64", "Gamecube", "Game Boy", "Gameboy Advance", "Sega Genesis", "Sega CD"]
        
        
       
        
        
        network.downloadGamesByPlatformIDJSON(platformID: 7, fields: fields, include: include, pageURL: nil) {
        
            print("donwloadGamesByPlatformIDJSON Success")
            let platformImage = self.setPlatformIcon(platformID: self.network.games[0].platform, mode: self.traitCollection.userInterfaceStyle)
            self.tableviewPlatformImage.image = UIImage(named: platformImage)
            
            self.tableView.reloadData()

                          }
       
//        network.downloadGamesByPlatformIDJSON(platformID: 3, fields: fields, include: include, page: nil) { (_, _) -> (Data?, Error?) in
//            
//            
//            print(self.game?.data.games.count)
//            
//            
//            return self.game
//        }
//
//        networking.downloadJSON(platformSelected: 18, gameName: nil, offset: nil) {
//
//            self.tableView.reloadData()
//            print("in")
//
//            print("platform image id is ** \(self.networking.games[0].platforms?[0].versions?[0].platformLogo?.imageID)")
//
//            self.setPlatformIcon()
//
//
//            self.tableView.reloadData()
//
//
//        }
        
       
        
        // Do any additional setup after loading the view.
        
    }
    
    
    
    
    
    
    
    //MARK: TableView Methods
    
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        game?.data.count
//        return self.network.games.count
        print("tableview count \(network.games.count)")//        return game!.data.count
        return (network.games.count)
//        (self.network.gamesByPlatformID?.data.games.count)!
//        return self.networking.games.count
        
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ViewControllerTableViewCell
        tableView.register(UINib(nibName: "TableViewCell", bundle: nil), forCellReuseIdentifier: "cell")
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ViewControllerTableViewCell
        
        cell.configureCells()
//
// 
        print("boxart data \(network.boxart?.data)")
        
//        cell.tag = indexPath.row
        
        //creating game object
        let game1 : GDBGamesPlatform?
        game1 = network.games[indexPath.row]
        cell.tag = game1?.id! as! Int
        print(network.games.count - 1)
        print(network.page?.next)
//        network.downloadScreenScraperJSON(gameName: game1!.gameTitle) {
//             let boxImages = self.network.gameDetailsSS?.response.jeu.medias.filter({ $0.type == "support-2D" && $0.region == "us"} )
//            if boxImages?.count != 0 {
//            let url = URL(string: (boxImages?[0].url)!)
//
//            cell.gameCartImage.sd_setImage(with: url) { (image, error, cacheType, url) in
//                if (error != nil) {
//                    print("Error, could not download.  Download reason \(error?.localizedDescription)")
//                    
//                } else {
//                    print("Successfully downloaded game cart image from \(url)")
//                    
//                }
//            }
//            
//            }
//            
//            
//        
//        }
        
        print(network.gamesByPlatformID?.data?.games.count)
//        print("genre = \(game1?.data.games[0].genres)")
        print("genre = \(game1?.genres)")
        let genreData = [GenreData]()
        
        print(network.gameGenreData)
        
        //update the Game Name fields text to be capitialized
        cell.tableViewGameName.text = game1?.gameTitle

//MARK: Release Date Label
        //Formatting date data to presentable format and setting the release date label
        // the date comes in as yyyy-MM-DD format, and we need to convert to MM-DD-yyyy, so we take the current date string, convert it to a date and then reconvert back to a string in the format we want
        
        if game1?.releaseDate != nil {
           
            let gdbDate = game1?.releaseDate
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-DD"
            dateFormatter.timeZone = TimeZone(abbreviation: "MST") //Set timezone that you want
            dateFormatter.locale = NSLocale.current
            
            let strDate = dateFormatter.date(from: gdbDate!)
            dateFormatter.dateFormat = "MM-dd-yyyy" //Specify your format that you want
            let finalDate = dateFormatter.string(from: strDate!)
            
            cell.tableViewReleaseDateLabel.text = finalDate
        }
        
        
        
        
        //Setting the Company label{
        if game1?.developers != nil {
        if network.gameDeveloperData["\(game1!.developers![0])"] != nil {
            let developerText = "\(network.gameDeveloperData["\(game1!.developers![0])"]!.name)"
            print("developerText = \(developerText)")
            cell.tableViewCompanyLabel.text = "\(developerText)"
        } else {
            cell.tableViewCompanyLabel.text = " "
        }
        }
        
        
        var genreText = " \(network.gameGenreData["\(game1?.genres)"])"

        var genreArray : [String] = []
        if game1?.genres != nil {
        for genre in game1!.genres! {
            
            genreArray.append("\(network.gameGenreData["\(genre)"]!.name)")
            
        }
        
        
        
        print(genreArray)
        cell.tableViewGenreLabel.text = genreArray.joined(separator: " | ")
        
        }
        
        
        
        //Setting the Age Rating label
        
        if game1?.rating != nil {
        cell.tableViewAgeRatingLabel.text = game1?.rating
        } else {
            cell.tableViewAgeRatingLabel.text = " "
            print("Invalid Age Rating")
            
        }

        print("TEST TEST \(network.boxart?.baseURL)")
        print(network.baseURL)
        
        //retrieving the filename information based on the game id
        
        var frontImageName : String = ""
        var backImageName : String = ""
        
        if network.boxarts["\(game1!.id!)"]?[0].side == .front {
            print(network.boxarts["\(game1!.id!)"]?[0].filename)
            frontImageName = network.boxarts["\(game1!.id!)"]?[0].filename as! String
            
        } else if network.boxarts["\(game1!.id!)"]?[0].side == .back {
            backImageName = network.boxarts["\(game1!.id!)"]?[0].filename as! String
            
        }
        
        if network.boxarts["\(game1!.id!)"]?.count == 2 {
        if network.boxarts["\(game1!.id!)"]?[1].side == .front {
            frontImageName = network.boxarts["\(game1!.id!)"]?[1].filename as! String
                       
        } else if network.boxarts["\(game1!.id!)"]?[1].side == .back {
            backImageName = network.boxarts["\(game1!.id!)"]?[1].filename as! String
                       
        }
        }
   
        
        
       
        
        //if data exists for the front cover image download it, otherwise show default image
        if frontImageName != "" {
            
            //creating image url string
                   var imageUrlString = network.baseURL!.small + frontImageName
                   print(imageUrlString)
                   let imageURL = URL(string: imageUrlString)
                   
                   
                   
            cell.loadCoverImageWith(urlString: imageUrlString, gameID: (game1?.id)!)
//            cell.tableViewCoverImage.setImageAnimated(imageUrl: imageURL!, placeholderImage: UIImage(named: "noArtNES")!)
//
//              if tableView.indexPath(for: cell) == indexPath {
//            cell.loadCoverImageWith(urlString: imageUrlString)
//            }
//            cell.loadCoverImageWith(urlString: imageUrlString, gameID: (game1?.id)!)
//       SDWebImageManager.shared.loadImage(with: imageURL, options: SDWebImageOptions.highPriority, progress: nil) { (image, data, error, cacheType, downloading, downloadURL) in
//
//                         if let error = error {
//                             print("Error downloading the image \(error.localizedDescription)")
//                         }
//                         else {
//                             print("Successfully downloaded image from \(downloadURL?.absoluteString)")
//                            print("game1.id = \(game1?.id)")
//                            print("cell.tag = \(cell.tag)")
//                         
////                            let edgeColor = image?.edgeColor(UIEdgeInsets(top: 1, left: 1, bottom: 1, right: 1), defaultColor: .black)
////                              cell.tableViewCoverImage.image = image
////
////                            cell.coverImageShadow.image = image
////                            cell.shadowView.image = image
////                            let edgeColor = cell.tableViewCoverImage.image?.edgeColor()
//                            //                            cell.tableViewCoverImage.layer.shadowColor = edgeColor?.cgColor
//                          
//                                
////                                cell.tableViewCoverImage.layer.shadowColor = edgeColor!.cgColor
//                            
//
//                         }
//
//
//
//            }
            
        } else {
            cell.tableViewCoverImage.image = UIImage(named: "noArtNES")

        }
        
        
        
        //if data exists for the rear cover image download it, otherwise show default image
        
        if backImageName != nil {

            var rearImageURLString = network.baseURL!.medium + backImageName
                    cell.loadRearCoverImageWith(urlString: rearImageURLString)
                    
                    
        } else {
            cell.tableViewCoverRearImage.image = UIImage(named: "noArtNES")

        }

        return cell
        
    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //Assigning the image at the selected cell to coverImage, so that it may be passed to the DetailViewController to avoid redownloading
        let cell = tableView.cellForRow(at: indexPath) as! ViewControllerTableViewCell
        print("test \(cell.frontImageName)")
//        segueFrontImageName = cell.frontImageName
//        segueRearImageName = cell.rearImageName
        coverImage = cell.tableViewCoverImage.image
        print("seguefrontimagename = \(segueFrontImageName)")
        rearCoverImage = cell.tableViewCoverRearImage?.image!
        print(rearCoverImage)
        //Segue to DetailViewController
        performSegue(withIdentifier: "showDetails", sender: self)
        
    }
    
//image
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let destination = segue.destination as? DetailViewController {
//            let cell = tableView.cellForRow(at: <#T##IndexPath#>)
//            destination.frontImageName = segueFrontImageName!
//            destination.backImageName = segueRearImageName!
            destination.network = network
            destination.cover = coverImage!
            destination.rearCover = rearCoverImage
//            destination.cover = tableView.cellForRow(at: IndexPath.row)
            destination.genre = network.genre
            destination.games =  network.games[tableView.indexPathForSelectedRow!.row]
            destination.boxart = network.boxart
            destination.developerData = network.gameDeveloperData
//            destination.boxart = network.boxarts[tableView.indexPathForSelectedRow!.row]
//            destination.frontImageName = frontImageName
//            destination.backImageName = backImageName
            
            
        }
    }
    
    
    
    
    
    
    
    
    
    //MARK:  - Pickerview Functions
    
    
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        // Number of columns of data
        return 1
    }
    
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        // The number of rows of data
        return pickerData.count
    }
    
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        // The data to return for the row and component (column) that's being passed in
        return pickerData[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        print("\(row), \(component)")
        //Will allow user to choose the preferred console platform and will present a specific image corresponding to the chosen platform.
        
        
        switch row {
        case 0:
            //NES
            picked = 18
            gdbPlatformID = 7
        //            image.
        case 1:
            //SNES
            picked = 19
            gdbPlatformID = 6
        case 2:
            //N64
            picked = 4
            gdbPlatformID = 3
        case 3:
            //GC
            picked = 21
            gdbPlatformID = 2
        case 4:
            //GB
            picked = 33
            gdbPlatformID = 4
        case 5:
            //GBA
            picked = 24
            gdbPlatformID = 5
            
        case 6:
            //SG
            picked = 29
            gdbPlatformID = 18
        case 7:
            //SCD
            picked = 78
            gdbPlatformID = 21
        default:
            print("invalid selection")
        }
//        network.gamesByPlatformID?.data.games.removeAll()
//        self.games.removeAll()
        self.network.games.removeAll()
        self.network.boxart?.data.removeAll()
//        self.networking.games.removeAll()
//        self.tableView.reloadData()
        network.currentOffset = 0
        
        print("picked = \(gdbPlatformID)")
        
//        self.networking.downloadJSON(platformSelected: gdbPlatformID, gameName: nil, offset: network.currentOffset) {
        self.network.downloadGamesByPlatformIDJSON(platformID: gdbPlatformID, fields: fields, include: include, pageURL: nil) {
                
            self.setForDarkMode()
                
            
            print("pickerview JSON downloaded")
            
            //setting the platform image name
//            self.setPlatformIcon()
            let platformLogos = self.setPlatformIcon(platformID: self.network.games[0].platform, mode: self.traitCollection.userInterfaceStyle)
            
            self.tableviewPlatformImage.image = UIImage(named: platformLogos)
            //loading the platform image
//            self.tableviewPlatformImage.image = UIImage(named: "\(self.imageName)")
            //            self.networking.games.removeAll()
            self.cache.removeAllObjects()
            self.rearImageCache.removeAllObjects()
            self.tableView.reloadData()
            if self.traitCollection.userInterfaceStyle == .light {
                   
                self.tableView.backgroundColor = UIColor(red: (246/255), green: (246/255), blue: (246/255), alpha: 1)
                         
                       } else {

                self.tableView.backgroundColor = UIColor(red: (15/255), green: (15/255), blue: (15/255), alpha: 1)

                   }
            
            print("test after")
        }
        
        print("gamesArray \(network.gamesByPlatformID?.data?.games)")
        
        
    }
    
   


    
    
    //MARK: Button Methods
    
    
    
    @objc func searchButtonPressed(_ sender: UIButton!) {
        //rudimentary search function.  Will take what is entered and run it through the downloadJSON function and return any results
        
        
        
        print("searchButtonPressed")
//        if searchTextField.text != nil {
//            gameNamed = searchTextField.text
//            print("game named \(gameNamed!)")
////            self.network.games.removeAll()
//            self.games.removeAll()
//            self.tableView.reloadData()
////            self.networking.downloadJSON(platformSelected: nil, gameName: gameNamed, offset: 0) {
//                print("search executed")
//                self.tableView.reloadData()
//            }
            
//        }
        
    }
    
    @IBAction func clearButtonPressed(_ sender: Any) {
        //clear out the search field
        
        searchTextField.text = nil
    }
    
    func setForDarkMode() {
        if self.traitCollection.userInterfaceStyle == .light {
                   view.backgroundColor = #colorLiteral(red: 0.9647058824, green: 0.9647058824, blue: 0.9647058824, alpha: 1)
               platformLabel.backgroundColor = #colorLiteral(red: 0.9647058824, green: 0.9647058824, blue: 0.9647058824, alpha: 1)
               platformPicker.backgroundColor = #colorLiteral(red: 0.9647058824, green: 0.9647058824, blue: 0.9647058824, alpha: 1)
            searchTextField.layer.shadowColor = UIColor.black.cgColor


                   } else {
                    view.backgroundColor = #colorLiteral(red: 0.05882352941, green: 0.05882352941, blue: 0.05882352941, alpha: 1)
               platformLabel.backgroundColor = #colorLiteral(red: 0.05882352941, green: 0.05882352941, blue: 0.05882352941, alpha: 1)
               platformPicker.backgroundColor = #colorLiteral(red: 0.05882352941, green: 0.05882352941, blue: 0.05882352941, alpha: 1)
               searchTextField.layer.shadowColor = UIColor.white.cgColor

               
                   }
        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        
        if offsetY > contentHeight - scrollView.frame.size.height {
            
            if fetchingMore == false {
                print("end of table")
                beginBatchFetch()
            }
        }
    }
    func beginBatchFetch() {
        fetchingMore = true
        print("fetching data")
        network.downloadGamesByPlatformIDJSON(platformID: nil, fields: nil, include: nil, pageURL: network.page?.next) {
            print("pagination successful")
            self.fetchingMore = false
            self.tableView.reloadData()

                  }
        
    }


    //Pagination
//    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
//
//        print("scrollViewDidEndDragging")
//        if ((tableView.contentOffset.y + tableView.frame.size.height) >= tableView.contentSize.height)
//        {
//            if !isDataLoading{
//                isDataLoading = true
//                self.pageNo=self.pageNo+1
//                self.limit=self.limit+10
//                self.offset=self.limit * self.pageNo
////                loadCallLogData(offset: self.offset, limit: self.limit)
//  network.downloadGamesByPlatformIDJSON(platformID: nil, fields: nil, include: nil, pageURL: network.page?.next) {
//                  print("pagination successful")
//    self.tableView.reloadData()
//                  
//              }
//            }
//        }
//    }
    
    
//    func downloadImages() {
//        for games in network.boxart[0]! {
//
//            games.
//        if (countInt <= gameObject!.count) {
//
//            var imageToInsert = UIImageView()
//            imageToInsert.loadImage(from: "") {
//                self.countInt = self.countInt + 1
//                self.imageArray.insert(imageToInsert, at: 0)
//                print("Image downloaded. Current count: \(self.imageArray.count)")
//                self.downloadImages()
//            }
//
//        }  else {
//                       print("no more items")
//                           self.countInt = 0
//                                   }
//    }
//
//}

//func setImage() {
//
//
//}

//func setPlatformIcon() {
//    //helper function to set the appropriate platform icon when the platform is changed in pickerView
//    print("setPlatformIcon()")
//    print("\(self.networking.games[0].platforms![0].id)")
//
//    print("GameDB platform ID count \(network.gamesByPlatformID?.data.games.count)")
//    print("GameDB platform ID name  \(network.gamesByPlatformID?.data.games[0].gameTitle)")
//    print("GameDB platform ID   \(network.gamesByPlatformID?.data.games[0].platform)")
//    switch self.networking.games[0].platforms![0].id {
//
//    case 18:
//        if self.traitCollection.userInterfaceStyle == .light {
//            //Light Mode
//            self.imageName = "NESLogo"
//        } else {
//            //Dark Mode
//            self.imageName = "NESLogoInverse"
//
//        }
//
//    case 19:
//        if self.traitCollection.userInterfaceStyle == .light {
//            //Light Mode
//            self.imageName = "SNESLogo1"
//        } else {
//            //Dark Mode
//            self.imageName = "SNESLogo1Inverse"
//
//        }
//    case 4:
//        if self.traitCollection.userInterfaceStyle == .light {
//            //Light Mode
//            self.imageName = "N64Logo"
//        } else {
//            //Dark Mode
//            self.imageName = "N64LogoInverse"
//
//        }
//    case 21:
//        if self.traitCollection.userInterfaceStyle == .light {
//            //Light Mode
//            self.imageName = "GCLogo"
//        } else {
//            //Dark Mode
//            self.imageName = "GCLogoInverse"
//
//        }
//    case 33:
//        if self.traitCollection.userInterfaceStyle == .light {
//            //Light Mode
//            self.imageName = "GBLogo"
//        } else {
//            //Dark Mode
//            self.imageName = "GBLogoInverse"
//
//        }
//    case 24:
//        if self.traitCollection.userInterfaceStyle == .light {
//            //Light Mode
//            self.imageName = "GBALogo"
//        } else {
//            //Dark Mode
//            self.imageName = "gbaLogoInverse"
//
//        }
//    case 29:
//        if self.traitCollection.userInterfaceStyle == .light {
//            //Light Mode
//            self.imageName = "SegaGenesisLogo"
//        } else {
//            //Dark Mode
//            self.imageName = "SegaGenesisLogoInverse"
//
//        }
//    case 78:
//        if self.traitCollection.userInterfaceStyle == .light {
//            //Light Mode
//            self.imageName = "SegaCDLogo"
//        } else {
//            //Dark Mode
//            self.imageName = "SegaCDLogoInverse"
//
//        }
//
//    default:
//        print("Invalid Platform")
//
//    }
//
//}
}
