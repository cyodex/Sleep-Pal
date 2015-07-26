//
//  SleepEntryTableViewController.swift
//  Sleep Pal
//
//  Created by Cody Caldwell on 7/26/15.
//  Copyright (c) 2015 Cody Caldwell. All rights reserved.
//

import UIKit
import HealthKit

class SleepEntryTableViewController: UITableViewController {
    
    var entries = [HKCategorySample]()
    let healthManager = HealthKitManager.sharedManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        healthManager.readSleepData({ [weak self](results, error) -> Void in
            if let results = results {
                self!.entries = results as! [HKCategorySample]
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self!.tableView.reloadData()
                })
            }
        })
    }

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return entries.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("SleepEntryCell", forIndexPath: indexPath) as! SleepEntryCell
        
        let sleepData = entries[indexPath.row]
        let startDate = sleepData.startDate
        let endDate = sleepData.endDate
        
        cell.dateLabel.text = getDateStringForSleepData(sleepData)
        cell.timeLabel.text = getTimeStringForSleepData(sleepData)
        cell.durationLabel.text = getDurationStringForSleepData(sleepData)
        cell.sleepEfficiencyLabel.text = getSleepEfficiencyStringForSleepData(sleepData)

        return cell
    }
    
    func getDateStringForSleepData(sleepData: HKCategorySample) -> String {
        let formatter = NSDateFormatter()
        formatter.dateFormat = "MMM dd, yyyy"
        formatter.locale = NSLocale(localeIdentifier: "en_US")
        return formatter.stringFromDate(sleepData.startDate)
    }
    
    func getTimeStringForSleepData(sleepData: HKCategorySample) -> String {
        let formatter = NSDateFormatter()
        formatter.dateFormat = "h:mm a"
        formatter.locale = NSLocale(localeIdentifier: "en_US")
        return "\(formatter.stringFromDate(sleepData.startDate)) - \(formatter.stringFromDate(sleepData.endDate))"
    }
    
    func getDurationStringForSleepData(sleepData: HKCategorySample) -> String {
        var intervalInSeconds = sleepData.endDate.timeIntervalSinceDate(sleepData.startDate)
        let hours = floor(intervalInSeconds / 3600)
        if (hours > 0) { intervalInSeconds -= hours * 3600 }
        let minutes = floor(intervalInSeconds / 60)
        if (minutes > 0) { intervalInSeconds -= minutes * 60 }
        return "\(Int(hours))h \(Int(minutes))min"
    }
    
    func getSleepEfficiencyStringForSleepData(sleepData: HKCategorySample) -> String {
        return "95%"
    }
}