//
//  ViewControllerTableViewCell.swift
//  collector
//
//  Created by Brian on 3/28/20.
//  Copyright © 2020 Brian. All rights reserved.
//

import UIKit
import SDWebImage

class ViewControllerTableViewCell: UITableViewCell {
    @IBOutlet weak var tableViewCoverImage: UIImageView!
    @IBOutlet weak var tableViewGameName: UILabel!
    @IBOutlet weak var tableViewGenreLabel: UILabel!
    @IBOutlet weak var tableViewAgeRatingLabel: UILabel!
    @IBOutlet weak var tableViewCompanyLabel: UILabel!
    @IBOutlet weak var tableViewReleaseDateLabel: UILabel!
    @IBOutlet weak var backgroundCell: UIView!
    @IBOutlet weak var tableViewCoverRearImage: UIImageView!
    @IBOutlet weak var coverImageShadow: UIImageView!
    var network = Networking()
    var frontImageName : String?
    var rearImageName : String?
    var gradient : CAGradientLayer!
    
    
    override func prepareForReuse() {
           super.prepareForReuse()
        
          
        tableViewCoverImage.sd_cancelCurrentImageLoad()
        tableViewCoverImage.image = nil
//        coverImageShadow.image = UIImage(named: "noArtNES")
//        tableViewCoverImage.image = UIImage(named: "noArtNES")
             }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        let effect = UIBlurEffect(style: .regular)
                let effectView = UIVisualEffectView(effect: effect)
        
                effectView.frame = coverImageShadow.bounds
                effectView.clipsToBounds = false
        
        //        effectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
                effectView.alpha = 1
      
                let maskLayer = CAGradientLayer()
                maskLayer.frame = coverImageShadow.bounds
                maskLayer.shadowRadius = 8
                maskLayer.shadowPath = CGPath(roundedRect: coverImageShadow.bounds.insetBy(dx: 9, dy: 9), cornerWidth: 11, cornerHeight: 11, transform: nil)
                maskLayer.shadowOpacity = 1
                maskLayer.shadowOffset = CGSize.zero
                if traitCollection.userInterfaceStyle == .light {
                maskLayer.shadowColor = UIColor.black.cgColor
                } else {
                    maskLayer.shadowColor = UIColor.white.cgColor
                }
                coverImageShadow.layer.mask = maskLayer
        
                coverImageShadow.addSubview(effectView)
        
         coverImageShadow.layer.opacity = 1

               coverImageShadow.layer.cornerRadius = 10
               
               backgroundCell.layer.shadowOffset = CGSize(width: 0, height: 5)
               backgroundCell.layer.shadowRadius = 5
               backgroundCell.layer.shadowOpacity = 0.1
               backgroundCell.layer.cornerRadius = 10
//               if self.traitCollection.userInterfaceStyle == .light {
//                   backgroundCell.layer.shadowColor = UIColor.black.cgColor
//                   backgroundCell.layer.backgroundColor = UIColor.white.cgColor
//
//
//                   print("test 1")
//               } else {
//                   backgroundCell.layer.shadowColor = UIColor.white.cgColor
//                   backgroundCell.layer.backgroundColor = UIColor.black.cgColor
//
//                   print("Test 2")    }

  
    }
    
    func loadCoverImageWith(urlString: String, gameID: Int) {
        let imageURL = URL(string: urlString)
        
    
            
//            self.tableViewCoverImage.sd_setImage(with: imageURL, placeholderImage: UIImage(named: "noArtNES"), options: SDWebImageOptions.highPriority) { (image, error, cacheType, url) in
//
//                if let error = error {
//                    print("Error downloading the image.  Error Description: \(error.localizedDescription)")
//                } else {
//                    print("Successfully downloaded image from \(imageURL?.absoluteString)")
//
//                    let edgeColor = self.tableViewCoverImage.image?.edgeColor()
//                    self.tableViewCoverImage.layer.shadowColor = edgeColor!.cgColor
//                }
//            }

            SDWebImageManager.shared.loadImage(with: imageURL, options: SDWebImageOptions.highPriority, progress: nil) { (image, data, error, cacheType, downloading, downloadURL) in

            if let error = error {
                print("Error downloading the image \(error.localizedDescription)")
            }
            else {
                print("Successfully downloaded image from \(downloadURL?.absoluteString)")
                
                self.tableViewCoverImage.image = image
                self.coverImageShadow.image = image
                
            }
                
            }
        
        
    }
    
        func loadRearCoverImageWith(urlString: String) {
            let imageURL = URL(string: urlString)
                
                                    
                    SDWebImageManager.shared.loadImage(with: imageURL, options: SDWebImageOptions.highPriority, progress: nil) { (image, data, error, cacheType, downloading, downloadURL) in

                    if let error = error {
                        print("Error downloading the image \(error.localizedDescription)")
                    }
                    else {
                        print("Successfully downloaded image from \(downloadURL?.absoluteString)")
                        
                        self.tableViewCoverRearImage.image = image
                        
                        
                    }

        }
    }
    
    func configureCells() {
       
//        tableViewCoverImage.layer.shadowOffset = CGSize(width: -5, height: 8)
//        tableViewCoverImage.layer.shadowRadius = 10
//        tableViewCoverImage.layer.shadowOpacity = 1
        tableViewCoverImage.layer.cornerRadius = 10
        tableViewCoverImage.clipsToBounds = false
        tableViewCoverImage.layer.masksToBounds = false
//        let effect = UIBlurEffect(style: .regular)
//        let effectView = UIVisualEffectView(effect: effect)
//
//        effectView.frame = coverImageShadow.bounds
//        effectView.clipsToBounds = false
////        effectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
//        effectView.alpha = 1
////        gradient = CAGradientLayer()
////        gradient.frame
//        let maskLayer = CAGradientLayer()
//        maskLayer.frame = effectView.bounds
//        maskLayer.shadowRadius = 8
//        maskLayer.shadowPath = CGPath(roundedRect: effectView.bounds.insetBy(dx: 9, dy: 9), cornerWidth: 11, cornerHeight: 11, transform: nil)
//        maskLayer.shadowOpacity = 1
//        maskLayer.shadowOffset = CGSize.zero
//        if traitCollection.userInterfaceStyle == .light {
//        maskLayer.shadowColor = UIColor.black.cgColor
//        } else {
//            maskLayer.shadowColor = UIColor.white.cgColor
//        }
//        effectView.layer.mask = maskLayer
//
//        coverImageShadow.addSubview(effectView)
//        coverImageShadow.layer.opacity = 0.9
//
//        coverImageShadow.layer.cornerRadius = 10
//
//        backgroundCell.layer.shadowOffset = CGSize(width: 0, height: 5)
//        backgroundCell.layer.shadowRadius = 5
//        backgroundCell.layer.shadowOpacity = 0.1
//        backgroundCell.layer.cornerRadius = 10
        if self.traitCollection.userInterfaceStyle == .light {
            backgroundCell.layer.shadowColor = UIColor.black.cgColor
            backgroundCell.layer.backgroundColor = UIColor.white.cgColor
//
//            if let image = tableViewCoverImage.image {
//                        let ratio = image.size.width / image.size.height
//                        if image.size.width > image.size.height {
//                            print("changing height")
//                            let newHeight = image.size.width / ratio
//                            tableViewCoverImage.frame.size = CGSize(width: tableViewCoverImage.frame.width, height: newHeight)
////                            coverImageShadow.frame.size = CGSize(width: coverImageShadow.frame.width, height: newHeight)
//
////                            coverImageShadow.bounds = tableViewCoverImage.bounds
////                              coverImageShadow.bounds = CGRect(x: tableViewCoverImage.bounds.origin.x, y: tableViewCoverImage.bounds.origin.y, width: tableViewCoverImage.bounds.width + 10, height: tableViewCoverImage.bounds.height + 10)
//                        } else {
//                            print("changing width")
//                            let newWidth = image.size.height * ratio
//                            tableViewCoverImage.frame.size = CGSize(width: newWidth, height: tableViewCoverImage.frame.height)
////                            coverImageShadow.frame.size = CGSize(width: newWidth, height: coverImageShadow.frame.height)
////                            coverImageShadow.bounds = CGRect(x: tableViewCoverImage.bounds.origin.x, y: tableViewCoverImage.bounds.origin.y, width: tableViewCoverImage.bounds.width + 10, height: tableViewCoverImage.bounds.height + 10)
//
//                        }
//
//
//                    }
            print("test 1")
        } else {
            backgroundCell.layer.shadowColor = UIColor.white.cgColor
            backgroundCell.layer.backgroundColor = UIColor.black.cgColor

            print("Test 2")
            
//            if let image = tableViewCoverImage.image {
//                let ratio = image.size.width / image.size.height
//                if image.size.width > image.size.height {
//                    print("changing height")
//                    let newHeight = image.size.width / ratio
//                    tableViewCoverImage.frame.size = CGSize(width: tableViewCoverImage.frame.width, height: newHeight)
//                    coverImageShadow.bounds = tableViewCoverImage.bounds
//                } else {
//                    print("changing width")
//                    let newWidth = image.size.height * ratio
//                    tableViewCoverImage.frame.size = CGSize(width: newWidth, height: tableViewCoverImage.frame.height)
//                coverImageShadow.bounds = tableViewCoverImage.bounds
//
//                }
//                
//                
//            }
//
//
//
//
//
    }
    
   

}
}
