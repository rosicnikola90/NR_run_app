//
//  CountViewController.swift
//  NR_run_app
//
//  Created by MacBook on 2/7/21.
//  Copyright © 2021 MacBook. All rights reserved.
//

import UIKit

@available(iOS 10.0, *)

 class CountViewController: UIViewController {

    var counting = 3
    
    @IBOutlet weak var CountLabel: UILabel!
    
    var timer: Timer? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = true
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        CountLabel.isHidden = false
        CountLabel.font = UIFont(name: CountLabel.font.fontName, size: 30)
        CountLabel.text = "GET READY"
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector:#selector (self.timerMethod), userInfo: nil, repeats: true)
        
    }
    
    
    @objc func timerMethod ()  {
        CountLabel.font = UIFont(name: CountLabel.font.fontName, size: 150)
        CountLabel.alpha = 1.0
        CountLabel.text = "\(counting)"
        UIView.animate(withDuration: 0.9, animations: {
            self.CountLabel.alpha = 0.0
        }
            ,completion: { (bool) in
                self.counting -= 1
            })
        if counting == 0 {
            timer?.invalidate()
            CountLabel.text = "GOO"
            DispatchQueue.main.asyncAfter(deadline: DispatchTime(uptimeNanoseconds: 20000)) {
                self.performSegue(withIdentifier: "startRun", sender: self)
            }
        }
    }
    
    
    deinit {
        print("deinit CountVC")
    }
    
}
