//
//  TableViewSwipe.swift
//  TableSwipeTest
//
//  Created by Jin Sasaki on 2015/11/08.
//  Copyright © 2015年 AWA Co.Ltd. All rights reserved.
//

import UIKit

/**
 Direction of swipe
 
 - Left:  to Left
 - Right: to Right
 */
@objc public enum SwipeDirection: Int {
    case Left
    case Right
}

/**
 *  Delegate of TableView Swipe
 */
@objc public protocol SwipeDelegate {

    /**
     Should begin to swipe cell at index path

     If not implemented, return true as default.
     
     - parameter direction: The direction of swipe
     - parameter indexPath: The indexPath of table view cell which will be swiped
        
     - returns: will swipe or not
     */
    optional func swipe(direction: SwipeDirection, shouldBeginAtIndexPath indexPath: NSIndexPath) -> Bool

    /**
     Custom title label under the swiped cell at index path

     If not implemented, return default label.
     
     - parameter direction:  The direction of swipe
     - parameter titleLabel: The title label under the swiped cell
     - parameter indexPath:  The indexPath of swiped table view cell
     - parameter active:     The cell is active or not
     
     - returns: customed title label
     */
    optional func swipe(direction: SwipeDirection, titleLabel: UILabel, atIndexPath indexPath: NSIndexPath, active: Bool) -> UILabel
    
    /**
     Custom background color under the swiped cell at index path

     If not implemented, return default background color.

     - parameter direction: The direction of swipe
     - parameter indexPath: The indexPath of swiped table view cell
     - parameter active:    The cell is activate or not
     
     - returns: customed background color
     */
    optional func swipe(direction: SwipeDirection, backgroundColorAtIndexPath indexPath: NSIndexPath, active: Bool) -> UIColor
    
    /**
     Active of cell with rate
     If not implemented, cell is acitve when rate is over 0.3.
     
     - parameter direction: The direction of swipe
     - parameter rate:      The rate of translation with respect to the table view width
     
     - returns: active or not
     */
    optional func swipe(direction: SwipeDirection, acitiveWithRate rate: CGFloat) -> Bool
    
    /**
     Swipe events
     */
    optional func swipe(direction: SwipeDirection, willBeginAtIndexPath indexPath: NSIndexPath)
    optional func swipe(direction: SwipeDirection, didBeginAtIndexPath indexPath: NSIndexPath)
    optional func swipe(direction: SwipeDirection, atIndexPath indexPath: NSIndexPath, rate: CGFloat)
    optional func swipe(direction: SwipeDirection, willEndAtIndexPath indexPath: NSIndexPath)
    optional func swipe(direction: SwipeDirection, didEndAtIndexPath indexPath: NSIndexPath)
}

public extension UITableView {
    
    func swipeEnabled(enabled: Bool, delegate: SwipeDelegate?) {
        self.swipeEnabled(enabled)
        self.setSwipeDelegate(delegate)
    }
    
    func swipeEnabled(enabled: Bool) {
        let swipeController = SwipeController.sharedController
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: "handlePanGesture:")
        if enabled {
            panGestureRecognizer.delegate = swipeController
            self.panGestureRecognizer.requireGestureRecognizerToFail(panGestureRecognizer)
            self.addGestureRecognizer(panGestureRecognizer)
            swipeController.tableView = self
            self.setupSwipeViews()
        } else {
            panGestureRecognizer.delegate = nil
            self.removeGestureRecognizer(panGestureRecognizer)
            swipeController.tableView = nil
            self.removeSwipeViews()
        }
    }
    
    func setSwipeDelegate(delegate: SwipeDelegate?) {
        SwipeController.sharedController.delegate = delegate
    }
}

// MARK: - TableViewSwipe Internal
/**
 *  SwipeDelegate default impelementation
 */
extension SwipeDelegate {
    func swipe(direction: SwipeDirection, shouldBeginAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }

    func swipe(direction: SwipeDirection, titleLabel: UILabel, atIndexPath indexPath: NSIndexPath, active: Bool) -> UILabel {
        switch direction {
        case .Left:
            titleLabel.text = "Right side"
        case .Right:
            titleLabel.text = "Left side"
        }
        if active {
            titleLabel.textColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1.0)
        } else {
            titleLabel.textColor = UIColor(red: 244 / 255, green: 67 / 255, blue: 54 / 255, alpha: 1.0)
        }
        return titleLabel
    }
    
    func swipe(direction: SwipeDirection, backgroundColorAtIndexPath indexPath: NSIndexPath, active: Bool) -> UIColor {
        if active {
            return UIColor(red: 244 / 255, green: 67 / 255, blue: 54 / 255, alpha: 1.0/2)
        } else {
            return UIColor(red: 236 / 255, green: 239 / 255, blue: 241 / 255, alpha: 1.0/2)
        }
    }
    
    func swipe(direction: SwipeDirection, acitiveWithRate rate: CGFloat) -> Bool {
        return abs(rate) > 0.3
    }
}

/// Swipe Controller
internal class SwipeController: NSObject, UIGestureRecognizerDelegate {
    /// Singleton instance
    internal static let sharedController = SwipeController()
    /// The target table view to swipe
    internal weak var tableView: UITableView?
    /// A view under the swiped cell
    internal weak var swipeMenuView: UIView?
    /// A label under the swiped cell
    internal weak var swipeMenuLabel: UILabel?
    /// The swiped cell
    internal weak var swipeCell: UITableViewCell!
    /// Swipe delegate class
    internal weak var delegate: SwipeDelegate?
    
    func gestureRecognizerShouldBegin(gestureRecognizer: UIGestureRecognizer) -> Bool {
        if let panGestureRecognizer = gestureRecognizer as? UIPanGestureRecognizer {
            let translation = panGestureRecognizer.translationInView(self.tableView)
            
            // Detect swipe between -2 and 2 difference as landscape drag
            if fabs(translation.y) < 2 {
                let location = panGestureRecognizer.locationInView(self.tableView)
                guard let indexPath = self.tableView?.indexPathForRowAtPoint(location) else {
                    return false
                }
                let direction: SwipeDirection = translation.x < 0 ? .Left : .Right
                if self.delegate?.swipe(direction, shouldBeginAtIndexPath: indexPath) ?? false {
                    return true
                }
            }
        }
        return false
    }
}

// MARK: - TableViewSwipe UITableView extensions as internal

public extension UITableView {

    private func setupSwipeViews() {
        let swipeController = SwipeController.sharedController
        if swipeController.swipeMenuView == nil {
            // Set swipe view below the swiped cell
            let swipeMenuView = UIView()
            self.insertSubview(swipeMenuView, atIndex: 0)
            swipeController.swipeMenuView = swipeMenuView
            
            if swipeController.swipeMenuLabel == nil {
                // Set swipe label
                let swipeMenuLabel = UILabel()
                swipeController.swipeMenuView?.addSubview(swipeMenuLabel)
                swipeController.swipeMenuLabel = swipeMenuLabel
            }
        }
    }
    
    private func removeSwipeViews() {
        let swipeController = SwipeController.sharedController
        swipeController.swipeMenuView?.removeFromSuperview()
        swipeController.swipeMenuLabel?.removeFromSuperview()
        swipeController.swipeMenuLabel = nil
        swipeController.swipeMenuView = nil
    }
    
    private func swipeViewsHidden(hidden: Bool) {
        let swipeController = SwipeController.sharedController
        swipeController.swipeMenuLabel?.hidden = hidden
        swipeController.swipeMenuView?.hidden = hidden
    }
    
    private func layoutSwipeViews(frame: CGRect) {
        let swipeController = SwipeController.sharedController
        swipeController.swipeMenuView?.frame = frame
        swipeController.swipeMenuLabel?.frame = CGRect(x: 8, y: 0, width: frame.width - 8*2, height: frame.height)
    }
    
    func handlePanGesture(panGestureRecognizer: UIPanGestureRecognizer) {
        let state = panGestureRecognizer.state
        let translation = panGestureRecognizer.translationInView(self)
        
        let location = panGestureRecognizer.locationInView(self)
        guard let indexPath = self.indexPathForRowAtPoint(location),
            let cell = self.cellForRowAtIndexPath(indexPath) else {
                return
        }
        
        let swipeController = SwipeController.sharedController
        var swipeCell = swipeController.swipeCell
        if swipeCell == nil {
            swipeCell = cell
            swipeController.swipeCell = cell
            self.layoutSwipeViews(swipeCell.frame)
        }
        
        let direction: SwipeDirection = translation.x < 0 ? .Left : .Right
        let rate = translation.x / self.frame.width
        switch direction {
        case .Left:
            swipeController.swipeMenuLabel?.textAlignment = .Right
        case .Right:
            swipeController.swipeMenuLabel?.textAlignment = .Left
        }
        switch state {
        case .Began:
            swipeController.delegate?.swipe?(direction, willBeginAtIndexPath: indexPath)
            swipeController.swipeMenuView?.backgroundColor = swipeController.delegate?.swipe(direction, backgroundColorAtIndexPath: indexPath, active: false)
            swipeController.swipeMenuLabel = swipeController.delegate?.swipe(direction, titleLabel: swipeController.swipeMenuLabel!, atIndexPath: indexPath, active: false)
            self.swipeViewsHidden(false)
            swipeController.delegate?.swipe?(direction, didBeginAtIndexPath: indexPath)
        case .Changed:
            let active = swipeController.delegate?.swipe(direction, acitiveWithRate: rate) ?? false
            swipeController.swipeMenuView?.backgroundColor = swipeController.delegate?.swipe(direction, backgroundColorAtIndexPath: indexPath, active: active)
            swipeController.swipeMenuLabel = swipeController.delegate?.swipe(direction, titleLabel: swipeController.swipeMenuLabel!, atIndexPath: indexPath, active: active)
            swipeCell?.transform = CGAffineTransformMakeTranslation(translation.x, 0)
            swipeController.delegate?.swipe?(direction, atIndexPath: indexPath, rate: rate)
        case .Cancelled, .Ended:
            swipeController.delegate?.swipe?(direction, willEndAtIndexPath: indexPath)
            if swipeController.delegate?.swipe(direction, acitiveWithRate: rate) ?? false {
                // Swipe out
                UIView.animateWithDuration(0.2,
                    delay: 0,
                    options: .CurveEaseInOut,
                    animations: { () -> Void in
                        var translationX: CGFloat = 0
                        switch direction {
                        case .Left:
                            translationX = -self.frame.width
                        case .Right:
                            translationX = self.frame.width
                            break
                        }
                        swipeCell?.transform = CGAffineTransformMakeTranslation(translationX, 0)
                    },
                    completion: { (finished: Bool) -> Void in
                        swipeCell?.transform = CGAffineTransformIdentity
                        swipeController.swipeCell = nil
                        self.swipeViewsHidden(true)
                        swipeController.delegate?.swipe?(direction, didEndAtIndexPath: indexPath)
                })
            } else {
                // Return origin position
                UIView.animateWithDuration(0.2,
                    delay: 0,
                    options: .CurveEaseInOut,
                    animations: { () -> Void in
                        swipeCell?.transform = CGAffineTransformIdentity
                    },
                    completion: { (finished: Bool) -> Void in
                        swipeController.swipeCell = nil
                        self.swipeViewsHidden(true)
                        swipeController.delegate?.swipe?(direction, didEndAtIndexPath: indexPath)
                })
            }
            break
        default:
            break
        }
    }
}

