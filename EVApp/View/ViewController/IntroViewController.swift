//
//  IntroViewController.swift
//  EVApp
//
//  Created by Brijesh Bhardwaj on 16/05/23.
//

import UIKit
//import SideMenuSwift

class IntroViewController: UIViewController {
    @IBOutlet weak var container: UIView!
    @IBOutlet weak var pageControl: UIPageControl!
    var pages = [UIViewController]()
    var pageCount = 4
    var pageViewController: UIPageViewController?
    var currentIndex = 0
    var pendingIndex: Int?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.setHidesBackButton(true, animated: true)

        for i in 0 ..< 4 {
            if let vc = UIStoryboard(name: StoryBoardsType.AuthStoryBoard.rawValue, bundle: nil).instantiateViewController(withIdentifier: ViewControllerIdentifier.IntroPageContentViewController.rawValue) as? IntroPageContentViewController {
                    vc.index = i
                    pages.append(vc)
            }
        }
     
        pageViewController = self.children[0] as? UIPageViewController
        pageViewController!.delegate = self
        pageViewController!.dataSource = self
        pageViewController!.setViewControllers([pages[0]], direction: .forward, animated: true, completion: nil)
        pageControl.numberOfPages = pageCount
        pageControl.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
    }
    @IBAction func skip(_ sender: Any) {
        let vc = WelcomeVC.instantiateUsingStoryboard()

//        self.present(vc, animated: true)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
        @IBAction func pageControlValueChanged(_ sender: UIPageControl) {
            if sender.currentPage > currentIndex {
                pageViewController!.setViewControllers([pages[sender.currentPage]], direction: .forward, animated: true, completion: nil)
            } else {
                pageViewController!.setViewControllers([pages[sender.currentPage]], direction: .reverse, animated: true, completion: nil)
            }
            currentIndex = sender.currentPage
        }

}
extension IntroViewController: UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        let currentIndex = pages.firstIndex(of: viewController)!
        if currentIndex == pages.count - 1 {
            return nil
        }
        let nextIndex = abs((currentIndex + 1) % pages.count)
        return pages[nextIndex]

    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        let currentIndex = pages.firstIndex(of: viewController)!
        if currentIndex == 0 {
            return nil
        }
        let previousIndex = abs((currentIndex - 1) % pages.count)
        return pages[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
        pendingIndex = pages.firstIndex(of: pendingViewControllers.first!)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if completed {
            if let pendingIndex = pendingIndex {
                currentIndex = pendingIndex
                pageControl.currentPage = currentIndex
            }
        }
    }
  
    
}
