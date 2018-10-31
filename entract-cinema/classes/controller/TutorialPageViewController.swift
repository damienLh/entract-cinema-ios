//
//  TutorialPageViewController.swift
//  entract-cinema
//
//  Created by Damien Lheuillier on 30/10/2018.
//  Copyright © 2018 Damien Lheuillier. All rights reserved.
//

import UIKit

class TutorialPageViewController : UIPageViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataSource = self
        
        if !UserDefaults.standard.bool(forKey: Constants.visualiserTuto) {
           self.performSegue(withIdentifier: "goToApp", sender: self)
        } else {
            if let firstViewController = orderedViewControllers.first {
                setViewControllers([firstViewController],
                                   direction: .forward,
                                   animated: true,
                                   completion: nil)
            }
        }
    }
    
    private(set) lazy var orderedViewControllers: [UIViewController] = {
        return [tutorialViewController(picture: "tuto1", page: 0),
                tutorialViewController(picture: "tuto2", page: 1),
                tutorialViewController(picture: "tuto3", page: 2),
                tutorialViewController(picture: "tuto4", page: 3),
                tutorialViewController(picture: "tuto5", page: 4),
                tutorialViewController(picture: "tuto6", page: 5),
                tutorialViewController(picture: "tuto7", page: 6),
                tutorialViewController(picture: "tuto8", page: 7)]
    }()
    
    private func tutorialViewController(picture: String, page: Int) -> UIViewController {
        let vc: TutorialViewController = UIStoryboard(name: "Main", bundle: nil) .
            instantiateViewController(withIdentifier: "tutorialViewController") as! TutorialViewController
        vc.myPicture = picture
        vc.currentPage = page
        return vc
    }
}

// MARK: UIPageViewControllerDataSource
extension TutorialPageViewController: UIPageViewControllerDataSource {
    
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        if viewController is TutorialViewController {
            let vc: TutorialViewController  = viewController as! TutorialViewController
            let viewControllerIndex = vc.pageControl.currentPage
            let previousIndex = viewControllerIndex - 1
            
            guard previousIndex >= 0 else {
                return nil
            }
            
            guard orderedViewControllers.count > previousIndex else {
                return nil
            }
            return orderedViewControllers[previousIndex]
        }
        
        return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        if viewController is TutorialViewController {
            let vc: TutorialViewController  = viewController as! TutorialViewController
            let viewControllerIndex = vc.pageControl.currentPage
            let nextIndex = viewControllerIndex + 1
            let orderedViewControllersCount = orderedViewControllers.count
            
            guard orderedViewControllersCount != nextIndex else {
                return nil
            }
            
            guard orderedViewControllersCount > nextIndex else {
                return nil
            }
            
            return orderedViewControllers[nextIndex]
        }
        
        return nil
    }
}
