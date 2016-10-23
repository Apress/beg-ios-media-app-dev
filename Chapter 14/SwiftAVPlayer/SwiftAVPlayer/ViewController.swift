//
//  ViewController.swift
//  SwiftAVPlayer
//
//  Created by Ahmed Bakir on 10/19/14.
//  Copyright (c) 2014 Ahmed Bakir. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit

class ViewController: UIViewController, FileControllerDelegate {
    
    @IBOutlet var chooseFileButton : UIButton!
    @IBOutlet var playAllButton : UIButton!
    var moviePlayer : AVPlayerViewController!
    var count: Int = 5
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        var notificationCenter = NSNotificationCenter.defaultCenter()
        
        notificationCenter.addObserver(self, selector: "playbackFinished:", name: AVPlayerItemDidPlayToEndTimeNotification, object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
        var notificationCenter = NSNotificationCenter.defaultCenter()
        
        notificationCenter.removeObserver(self, name: AVPlayerItemDidPlayToEndTimeNotification, object: nil)
    }
    
    @IBAction func playAll(sender : AnyObject) {
        
        var error : NSError?
        
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true) // dot syntax for enums values
        let documentsDirectory = paths[0] as String
        
        let allFiles = NSFileManager.defaultManager().contentsOfDirectoryAtPath(documentsDirectory, error: &error) as [String]
        
        if error != nil {
            let errorString = error!.description
            println("error loading files: \(errorString)")
            
        } else {
            var playerItemArray  = NSMutableArray()
            for file in allFiles {
                let fileExtension = file.pathExtension.lowercaseString
                if fileExtension == "m4v" || fileExtension == "mov" {
                    let relativePath = documentsDirectory.stringByAppendingPathComponent(file)
                    let fileURL = NSURL(fileURLWithPath: relativePath)
                    let playerItem = AVPlayerItem(URL: fileURL)
                    
                    playerItem .addObserver(self, forKeyPath: "status", options:nil, context: nil)
                    //playerItemArray += [playerItem]
                    playerItemArray.addObject(playerItem)
                    
                }
            }
            
            moviePlayer.player = AVQueuePlayer(items: playerItemArray)
            moviePlayer.player .addObserver(self, forKeyPath: "status", options: nil, context: nil)
            
            moviePlayer.player.play()
        }

    }

    func playbackFinished(notification : NSNotification) {

        let userInfo = notification.userInfo
        
        if moviePlayer.player.isKindOfClass(AVPlayer) {
            dismissViewControllerAnimated(true, completion: nil)
        } else {
            //do nothing
        }
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {

        if segue.identifier == "setPlayerContent" {
            moviePlayer = segue.destinationViewController as AVPlayerViewController //casting
            //also, no need for self
        } else if segue.identifier == "showFilePicker" {

            var videoArray  = NSMutableArray()
            //var videoArray : [String]
            var error : NSError? /// =
            
            let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true) // dot syntax for enums values
            let documentsDirectory = paths[0] as String
            
            let allFiles = NSFileManager.defaultManager().contentsOfDirectoryAtPath(documentsDirectory, error: &error) as [String]
            
            if error != nil {
                let errorString = error!.description
                println("error loading files \(errorString)")
                
            } else {
                for file in allFiles {
                    let fileExtension = file.pathExtension.lowercaseString
                    if fileExtension == "m4v" || fileExtension == "mov" {
                        //videoArray += [file]
                        videoArray.addObject(file)
                    }
                }
                
                let segueNavigationController = segue.destinationViewController as UINavigationController
                
                let fileVC = segueNavigationController.topViewController as FileViewController
                fileVC.delegate = self
                fileVC.fileArray = videoArray

            }
        }
    }
    
    // oberserver method
    
    override func observeValueForKeyPath(keyPath: String, ofObject object: AnyObject, change: [NSObject : AnyObject], context: UnsafeMutablePointer<Void>) {
        if object.isKindOfClass(AVPlayer) && keyPath == "status" {
            let overlayImage = UIImage(named: "logo.png")
            let imageView = UIImageView(image: overlayImage)
            imageView.frame = moviePlayer.videoBounds
            imageView.contentMode = .BottomRight
            imageView.autoresizingMask = .FlexibleHeight | .FlexibleWidth
            
            if moviePlayer.contentOverlayView.subviews.count == 0 {
                self.moviePlayer.contentOverlayView.addSubview(imageView)
            }
            
            object.removeObserver(self, forKeyPath: "status")
            
        } else if object.isKindOfClass(AVPlayerItem) {
            let currentItem = object as AVPlayerItem
            
            if currentItem.status == .Failed {
                let errorString = currentItem.error.description
                println("error playing item: \(errorString)")
                
                if (moviePlayer.player.isKindOfClass(AVQueuePlayer)) {
                    let queuePlayer = moviePlayer.player as AVQueuePlayer
                    queuePlayer.advanceToNextItem()
                } else {
                    let alert = UIAlertView(title: "Error", message: errorString, delegate: self, cancelButtonTitle: "OK")
                    alert.show()
                }
            } else {
                object.removeObserver(self, forKeyPath: "status")
            }
        }
    }

    // FileControllerDelegate methods
    func cancel() {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func didFinishWithFile(filePath: String!) {
        
        var error : NSError? /// =
        
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true) // dot syntax for enums values
        let documentsDirectory = paths[0] as String
        let relativePath = documentsDirectory.stringByAppendingPathComponent(filePath)
        
        let fileURL = NSURL(fileURLWithPath: relativePath)
        moviePlayer.player = AVPlayer(URL: fileURL)
        
        //moviePlayer.player .addObserver(self, forKeyPath: "status", options: nil, context: nil)
        
        dismissViewControllerAnimated(true, completion: { () -> Void in
            self.moviePlayer.player.play()
        })

    }
    
}

