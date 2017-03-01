//
//  ClickViewController.swift
//  Places4Travel
//
//  Created by Brick Bai on 2017-02-28.
//  Copyright © 2017 Brick Bai. All rights reserved.
//

import UIKit

class ClickViewController: UIViewController {

	@IBOutlet weak var navBar: UINavigationItem!
	@IBOutlet weak var imageView: UIImageView!
	@IBOutlet weak var label: UILabel!
	
	var image = UIImage()
	var labelText = String()
	var navTitle = String()
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		self.imageView.image = self.image
		self.label.text = self.labelText
		self.navBar.title = self.navTitle
		self.navBar.hidesBackButton = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
