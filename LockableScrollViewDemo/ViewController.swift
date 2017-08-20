//
//  ViewController.swift
//  LockableScrollViewDemo
//
//  Created by Idan Haviv on 16/08/2017.
//  Copyright © 2017 Idan Haviv. All rights reserved.
//

import UIKit

// spec: scroll view will scroll iff addedItem's origin.y is greater than what the user sees as top y and will scroll in the amount of the height of the addedItem
class ViewController: UIViewController {

    @IBOutlet weak var scrollView: LockableScrollView!
    var imageList: [UIImageView] = []
    var lastImageIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.bounces = true
    }
    
    override func viewWillLayoutSubviews() {
        print("viewWillLayoutSubviews")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        scrollView.contentSize = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * 30)
        scrollView.frame = CGRect(x: 0, y: 70, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height - 70)
    }
    
    @IBAction func addToBottom(_ sender: Any) {
        addAtPosition(position: .Bottom)
    }

    @IBAction func addToTop(_ sender: Any) {
        addAtPosition(position: .Top)
    }
    
    @IBAction func addToMiddle(_ sender: Any) { //at random position
        addAtPosition(position: .Middle)
    }
    
    func removeAtPosition(position: Position) -> Void {
        if imageList.count == 0 {
            return
        }
        
        let index = imageIndexAtPosition(position: position, addOrRemove: .Remove)
        let view = imageList.remove(at: index)
        view.removeFromSuperview()
        imageList = updateYPosition(insertedIndex: index, diff: -view.frame.height, views: imageList) as! [UIImageView]
        if view.frame.origin.y < scrollView.contentOffset.y {
            scrollView.contentOffset.y -= view.frame.height
        }
    }
    
    @IBAction func removeTop(_ sender: Any) {
        removeAtPosition(position: .Top)
    }
    
    @IBAction func removeMiddle(_ sender: Any) {
        removeAtPosition(position: .Middle)
    }
    
    @IBAction func removeBottom(_ sender: Any) {
        removeAtPosition(position: .Bottom)
    }
    
    @IBAction func clearAll(_ sender: Any) {
        _ = imageList.map({$0.removeFromSuperview()})
        imageList = []
//        scrollView.contentSize = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
//        scrollView.frame = CGRect(x: 0, y: 70, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height - 70)
    }
    
    enum Position {
        case Top
        case Middle
        case Bottom
    }
    
    enum AddOrRemove {
        case Add
        case Remove
    }
    
    func imageIndexAtPosition(position: Position, addOrRemove: AddOrRemove) -> Int {
        switch position {
        case .Top:
            return 0
        case .Middle:
            return Int(arc4random_uniform(UInt32(imageList.count)))
        case .Bottom:
            switch addOrRemove {
                case .Add:
                    return imageList.count
                case .Remove:
                    return imageList.count - 1
            }
            
        }
    }
    
    func updateYPosition(insertedIndex: Int, diff: CGFloat, views: [UIView]) -> [UIView] {
        if diff > 0 {
            return views.enumerated().map { (index, view) -> UIView in
                if index > insertedIndex {
                    view.frame.origin.y += diff
                }
                
                return view
            }
        } else {
            return views.enumerated().map { (index, view) -> UIView in
                if index >= insertedIndex {
                    view.frame.origin.y += diff
                }
                
                return view
            }
        }
    }
    
    func getYPositionForIndex(index: Int) -> CGFloat {
        return imageList.enumerated().reduce(0) { (res: CGFloat, elm: (offset: Int, element: UIImageView)) -> CGFloat in
            return elm.offset < index ?  res + elm.element.frame.height : res
        }
    }
    
    func addAtPosition(position: Position) {
        let newImage = UIImageView(image: UIImage(named: "\(lastImageIndex).jpeg"))
        newImage.layer.borderColor = UIColor.black.cgColor
        newImage.layer.borderWidth = 6
        let newImageHeight = newImage.frame.height
        
        let imageIndex = imageIndexAtPosition(position: position, addOrRemove: .Add)
        imageList.insert(newImage, at: imageIndex)
        imageList = updateYPosition(insertedIndex: imageIndex, diff: newImageHeight, views: imageList) as! [UIImageView]
        let newImageYPosition = getYPositionForIndex(index: imageIndex)
        newImage.frame.origin = CGPoint(x: scrollView.contentSize.width / 2 - newImage.frame.width / 2,y: newImageYPosition)
        
        scrollView.contentOffset.y += requiredScrollUpdate(scrollView: scrollView, addedView: newImage)
        scrollView.addSubview(newImage)
        updateLastImage()
    }
    
    func requiredScrollUpdate(scrollView: UIScrollView, addedView: UIView) -> CGFloat {
        let viewExceedsTopViewPort = addedView.frame.origin.y < scrollView.contentOffset.y
        let viewIsAddedToTopOfNonScrolledList = imageList.count > 1 && addedView.frame.origin.y == 0
        if  viewExceedsTopViewPort || viewIsAddedToTopOfNonScrolledList {
            return addedView.frame.height
        }
        
        return 0
    }
    
    func updateLastImage() {
        lastImageIndex = (lastImageIndex + 1) % 3
    }
}

