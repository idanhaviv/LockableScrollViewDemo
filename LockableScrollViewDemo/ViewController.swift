//
//  ViewController.swift
//  LockableScrollViewDemo
//
//  Created by Idan Haviv on 16/08/2017.
//  Copyright © 2017 Idan Haviv. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    var imageList: [UIImageView] = []
    var lastScrollPosition: CGFloat = 0
    var lastImageIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        scrollView.bounces = true
//        scrollView.observeValue(forKeyPath: , of: , change: , context: )
//        scrollView.addObserver(self, forKeyPath: "contentSize", options: [.new, .old], context: nil)
//        scrollView.addObserver(self, forKeyPath: "contentOffset", options: [.new, .old], context: nil)
    }
    
    override func viewWillLayoutSubviews() {
        print("viewWillLayoutSubviews")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("viewWillAppear")
        scrollView.contentSize = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        scrollView.frame = CGRect(x: 0, y: 70, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height - 70)
        print("\(UIScreen.main.bounds.width)")
        print("scroll view \(scrollView.frame)")
    }

    override func viewWillDisappear(_ animated: Bool) {
        scrollView.removeObserver(self, forKeyPath: "contentSize")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
//        if keyPath == "contentSize" {
//            let old = change![.oldKey]
//            print("old value \(old!)")
//            
//            let new = change![.newKey]
//            print("new value \(new!)")
//            print("1contentOffset \(scrollView.contentOffset) contentSize \(scrollView.contentSize)")
//            if old as! CGSize != new as! CGSize {
//                scrollToLastPosition()
//            }
//        }
//        
////        if keyPath == "contentOffset" {
////            lastScrollPosition = scrollView.contentOffset.y
////        }
//    }
    
//    func scrollToLastPosition() -> Void {
//        scrollView.contentOffset.y = lastScrollPosition
//        print("2contentOffset \(scrollView.contentOffset) contentSize \(scrollView.contentSize)")
//    }

    @IBAction func addToTop(_ sender: Any) {
        let newImage = UIImageView(image: UIImage(named: "\(lastImageIndex).jpeg"))
//        newImage.bounds = newImage.frame.insetBy(dx: 10, dy: 10)
        let newImageHeight = newImage.frame.height
        imageList = updateYPositionBy(diff: newImageHeight, views: imageList) as! [UIImageView]
        newImage.frame.origin = CGPoint(x: scrollView.contentSize.width / 2 - newImage.frame.width / 2,y: 0)
        imageList.insert(newImage, at: 0)
        lastScrollPosition += newImage.frame.height
        scrollView.contentSize.height += newImage.frame.height
//        scrollView.contentSize = CGSize(width: 400, height: imageList.reduce(0, { (res, view) -> CGFloat in
//            res + view.frame.height
//        }))
        scrollView.contentOffset.y += newImageHeight
        scrollView.addSubview(newImage)
        updateLastImage()
//        print("scrollView.contentSize \(scrollView.contentSize) scrollView.contentOffset \(scrollView.contentOffset)")
//        print("last image \(lastImageIndex)")
    }
    
    func updateYPositionBy(diff: CGFloat, views: [UIView]) -> [UIView] {
        return views.map { view in
            view.frame.origin.y += diff
            return view
        }
    }

    @IBAction func addToBottom(_ sender: Any) {
        let newImage = UIImageView(image: UIImage(named: "\(lastImageIndex).jpeg"))
//        newImage.bounds = newImage.frame.insetBy(dx: 10, dy: 10)
        let bottomImageFrame = getBottomImageFrame()
        newImage.frame.origin = CGPoint(x: scrollView.contentSize.width / 2 - newImage.frame.width / 2,y: bottomImageFrame.maxY)
        imageList.append(newImage)
        scrollView.contentSize.height += newImage.frame.height
//        scrollView.contentSize = CGSize(width: 400, height: imageList.reduce(0, { (res, view) -> CGFloat in
//            res + view.frame.height
//        }))
        scrollView.addSubview(newImage)
        updateLastImage()
//        print("scrollView.contentSize \(scrollView.contentSize) scrollView.contentOffset \(scrollView.contentOffset)")
//        print("last image \(lastImageIndex)")
    }
    
    func getTopImageFrame() -> CGRect {
        return imageList.first?.frame ?? CGRect(x: 0, y: 0, width: 0, height: 0)
    }
    
    func getBottomImageFrame() -> CGRect {
        return imageList.last?.frame ?? CGRect(x: 0, y: 0, width: 0, height: 0)
    }
    
    func updateLastImage() {
        lastImageIndex = (lastImageIndex + 1) % 3
    }
}

