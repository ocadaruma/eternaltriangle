//
//  MainViewController.swift
//  iOSSample
//
//  Created by hokada on 9/11/15.
//  Copyright (c) 2015 Haruki Okada. All rights reserved.
//

import UIKit
import EternalTriangle

class MainViewController: UIViewController {
  private let sequencer = Sequencer()
  private var tune: Tune! = nil

  @IBOutlet weak var sheet: OneLineSheet!

  override func viewDidLoad() {
    super.viewDidLoad()

    let tunePath = NSBundle.mainBundle().pathForResource("sample_tune", ofType: "txt")!
    let tuneString = String(contentsOfFile: tunePath, encoding: NSUTF8StringEncoding, error: nil)!
    let parser = ABCParser(string: tuneString)
    let result = parser.parse()

    tune = result.tune
//    sequencer.loadTune(tune)

    // Do any additional setup after loading the view.
  }

  override func viewDidAppear(animated: Bool) {
    sheet.loadTune(tune)
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.

  }

  @IBAction func start(sender: AnyObject) {
    sequencer.play()
  }

  @IBAction func stop(sender: AnyObject) {
    sequencer.stop()
  }

  /*
  // MARK: - Navigation

  // In a storyboard-based application, you will often want to do a little preparation before navigation
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
  // Get the new view controller using segue.destinationViewController.
  // Pass the selected object to the new view controller.
  }
  */

  static func controller() -> MainViewController {
    return UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("main") as! MainViewController
  }
}
