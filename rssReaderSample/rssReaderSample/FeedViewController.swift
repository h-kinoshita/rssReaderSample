//
//  FeedViewController.swift
//  rssReaderSample
//
//  Created by h.kinoshita on 2016/04/02.
//  Copyright © 2016年 mebro Inc. All rights reserved.
//

import UIKit

class FeedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, NSXMLParserDelegate {
    
    let feedUrl : NSURL = NSURL(string: "http://news.yahoo.co.jp/pickup/computer/rss.xml")!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // MARK: - Overrides -
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let parser : NSXMLParser = NSXMLParser(contentsOfURL: feedUrl)!
        parser.delegate = self;
        parser.parse()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Outlets -
    @IBOutlet weak var tableView: UITableView!
    
    
    // MARK: - Private Vars -
    var items : [Item] = [Item]()
    var currentElementName: String?
    var attributePicture : String?
    
    
    // MARK: - Private lets -
    let itemElementName = "item"
    let titleElementName = "title"
    let linkElementName = "link"
    let enclosureElementName = "enclosure"
    
    
    // MARK: - Delegates -
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell: CustomTableViewCell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! CustomTableViewCell
        let item = items[indexPath.row]
        let imgData: NSData!
        
        if item.picture != nil {
            let url = NSURL(string: item.picture!);
            do {
                imgData = try NSData(contentsOfURL:url!,options: NSDataReadingOptions.DataReadingMappedIfSafe)
                let img = UIImage(data:imgData)!;
                cell.picture.image = img;
            } catch {
                print("Error: can't create image.")
            }
        }
        
        cell.title.text = item.title
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let item = items[indexPath.row]
        UIApplication.sharedApplication().openURL(NSURL(string: item.url)!)
    }
    
    // Private func
    func parserDidStartDocument(parser: NSXMLParser)
    {
    }

    func parser(parser: NSXMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String])
    {
        currentElementName = nil
        if elementName == itemElementName {
            items.append(Item())
        } else {
            currentElementName = elementName
            attributePicture = attributeDict["url"] as String?
        }
    }
    
    func parser(parser: NSXMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?)
    {
        currentElementName = nil;
        attributePicture = nil;
    }
    
    func parser(parser: NSXMLParser, foundCharacters string: String)
    {
        if items.count > 0 {
            let lastItem = items[items.count-1]
            if currentElementName == titleElementName {
                let tmpString : String? = lastItem.title
                lastItem.title = (tmpString != nil) ? tmpString! + string : string
            } else if currentElementName == linkElementName {
                lastItem.url = string
            } else if currentElementName == enclosureElementName {
                lastItem.picture = attributePicture!
            }
        }
    }
    
    func parserDidEndDocument(parser: NSXMLParser)
    {
        self.tableView.reloadData()
    }
}

