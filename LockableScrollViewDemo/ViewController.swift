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
    var lastImage = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.contentSize = CGSize(width: 400, height: 0)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func addToTop(_ sender: Any) {
        let newImage = UIImageView(image: UIImage(named: "\(lastImage).jpeg"))
        let newImageHeight = newImage.frame.height
        imageList = updateYPositionBy(diff: newImageHeight, views: imageList) as! [UIImageView]
        newImage.frame.origin = CGPoint(x: scrollView.contentSize.width / 2 - newImage.frame.width / 2,y: 0)
        imageList.insert(newImage, at: 0)
        scrollView.contentSize = CGSize(width: 400, height: imageList.reduce(0, { (res, view) -> CGFloat in
            res + view.frame.height
        }))
        scrollView.addSubview(newImage)
        updateLastImage()
        print("scrollView.contentSize \(scrollView.contentSize) scrollView.contentOffset \(scrollView.contentOffset)")
        print("last image \(lastImage)")
    }
    
    func updateYPositionBy(diff: CGFloat, views: [UIView]) -> [UIView] {
        return views.map { view in
            view.frame.origin.y += diff
            return view
        }
    }

    @IBAction func addToBottom(_ sender: Any) {
        let newImage = UIImageView(image: UIImage(named: "\(lastImage).jpeg"))
        let bottomImageFrame = getBottomImageFrame()
        newImage.frame.origin = CGPoint(x: scrollView.contentSize.width / 2 - newImage.frame.width / 2,y: bottomImageFrame.maxY)
        imageList.append(newImage)
        scrollView.contentSize = CGSize(width: 400, height: imageList.reduce(0, { (res, view) -> CGFloat in
            res + view.frame.height
        }))
        scrollView.addSubview(newImage)
        updateLastImage()
        print("scrollView.contentSize \(scrollView.contentSize) scrollView.contentOffset \(scrollView.contentOffset)")
        print("last image \(lastImage)")
    }
    
    func getTopImageFrame() -> CGRect {
        return imageList.first?.frame ?? CGRect(x: 0, y: 0, width: 0, height: 0)
    }
    
    func getBottomImageFrame() -> CGRect {
        return imageList.last?.frame ?? CGRect(x: 0, y: 0, width: 0, height: 0)
    }
    
    func updateLastImage() {
        lastImage = (lastImage + 1) % 3
    }
}

