//
//  MainViewController.swift
//  Freehand
//
//  Created by Carrl on 16/3/26.
//  Copyright © 2016年 monk-studio. All rights reserved.
//

import Cocoa

class MainViewController: NSViewController {

    @IBOutlet weak var board: Board!
    @IBOutlet weak var colorPlate: ColorPlate!
    @IBOutlet weak var lineWidthPlate: LineWidthPlate!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let colors = [
            NSColor(calibratedRed: 69.0/255.0, green: 69.0/255.0, blue: 69.0/255.0, alpha: 1),
            NSColor(calibratedRed: 245.0/255.0, green: 245.0/255.0, blue: 245.0/255.0, alpha: 1),
            NSColor(calibratedRed: 237.0/255.0, green: 229.0/255.0, blue: 68.0/255.0, alpha: 1),
            NSColor(calibratedRed: 185.0/255.0, green: 219.0/255.0, blue: 73.0/255.0, alpha: 1),
            NSColor(calibratedRed: 226.0/255.0, green: 81.0/255.0, blue: 80.0/255.0, alpha: 1),
            NSColor(calibratedRed: 58.0/255.0, green: 230.0/255.0, blue: 226.0/255.0, alpha: 1)
        ]

        
        self.board.layer!.cornerRadius = 6
        self.board.layer!.backgroundColor = NSColor.whiteColor().CGColor
        self.board.layer!.shadowOpacity = 0.1
        self.board.layer!.shadowOffset = CGSizeMake(0,-2)
        self.board.layer!.shadowRadius = 4
        self.board.currentStrokeColor = colors[0]
        
        
        self.colorPlate.delegate = self
        self.colorPlate.setupColors(colors)
        
        self.lineWidthPlate.delegate = self
        
        
    }
    
    
    
    @IBAction func didPressClear(sender: AnyObject) {
        self.board.clearboard()
    }
    
    @IBAction func didPressCopyToClipboard(sender: AnyObject) {
        let pasteboard = NSPasteboard.generalPasteboard()
        pasteboard.clearContents()
        let copiesObjects = [self.board.produceImage()]
        pasteboard.writeObjects(copiesObjects)
    }
    
    @IBAction func didPressExit(sender: AnyObject) {
        NSApplication.sharedApplication().terminate(nil)
        self.undoManager
    }
    @IBAction func didPressSave(sender: AnyObject) {
        //Desktop Path
//        let paths = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DesktopDirectory, NSSearchPathDomainMask.UserDomainMask, true)
//        let path = paths[0]
        //Save
        let img = self.board.produceImage()
        img.lockFocus()
        let imgRep = NSBitmapImageRep(focusedViewRect: NSMakeRect(0.0, 0.0, img.size.width, img.size.height))
        img.unlockFocus()
        let data = imgRep!.representationUsingType(.NSJPEGFileType, properties: [:])
        data!.writeToFile("/Users/\(NSUserName())/Desktop/Freehand-" + "\(NSDate().description)" + ".png", atomically: false)
        
        
        /*
         NSBitmapImageRep *imgRep = [[image representations] objectAtIndex: 0];
         NSData *data = [imgRep representationUsingType: NSPNGFileType properties: nil];
         [data writeToFile: @"/path/to/file.png" atomically: NO];
         */
    }
    
}

// MARK: Control Delegates
extension MainViewController:ColorPlateDelegate{
    func didSelected(color: NSColor) {
        self.board.currentStrokeColor = color
    }
}
extension MainViewController:LineWidthPlateDelegate{
    func didChange(width: CGFloat) {
        self.board.currentStrokeWidth = width
    }
}
 