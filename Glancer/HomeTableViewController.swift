//
//  HomeTableViewController.swift
//  Glancer
//
//  Created by Cassandra Kane on 11/29/15.
//  Copyright (c) 2015 Vishnu Murale. All rights reserved.
//

import UIKit

class HomeTableViewController: UITableViewController {
    
    
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    var timer = NSTimer();
    
    @IBOutlet weak var mainDayLabel: UILabel!
    @IBOutlet weak var mainBlockLabel: UILabel!
    @IBOutlet weak var mainTimeLabel: UILabel!
    @IBOutlet weak var mainNextBlockLabel: UILabel!
    
    var dayNum: Int = 0
    var numOfRows: Int = 0
    var row: Int = 0
    var minutesUntilNextBlock: Int = 0
    var labels: [Label] = []
    var cell: BlockTableViewCell = BlockTableViewCell()
    
    var labelsGenerated: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        appDelegate.update()

        timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: "doEverything", userInfo: nil, repeats: true)
    }
    
    override func viewDidAppear(animated: Bool) {
        timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: "doEverything", userInfo: nil, repeats: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent //status bar is white
    }
    
    
    func doEverything() {
        
        if (appDelegate.Days.count > 0){
            
            updateMainHomePage()
            if dayNum < 5 {
                checkSecondLunch()
            }
            generateLabels()
            getNumOfRows()
            
            self.tableView.reloadData()
            
            timer.invalidate()
        }
        
    }
    
    func updateMainHomePage() {
        //updates the main labels on home page
        mainDayLabel.text = getMainDayLabel()
        mainBlockLabel.text = getMainBlockLabel()
        mainTimeLabel.text = getMainTimeLabel()
        mainNextBlockLabel.text = getMainNextBlockLabel()
            
        print("Home Page Updated")
        print("")
        
    }
    
    
    //GETTING HOME PAGE LABELS
    func getMainDayLabel() -> String {
        let currentDateTime = appDelegate.Days[0].getDate_AsString()
        let Day_Num = appDelegate.Days[0].getDayOfWeek_fromString(currentDateTime)
        self.dayNum = Day_Num
        if dayNum == 5 {
            return "Saturday"
        } else if dayNum == 6 {
            return "Sunday"
        } else {
            return appDelegate.Days[Day_Num].name
        }
    }
    
    func getMainBlockLabel() -> String {
        let currentDateTime = appDelegate.Days[0].getDate_AsString()
        let Day_Num = appDelegate.Days[0].getDayOfWeek_fromString(currentDateTime)
        
        if Day_Num < 5 {
            let currentValues = CurrentDayandStuff()
            let currentBlock = currentValues.current_block
            let currentClass = appDelegate.Days[Day_Num].messages_forBlock[currentBlock]
            if currentClass != nil {
                return "\(currentBlock) Block (\(currentClass!))"
            } else if currentBlock == "GetToClass" {
                return "Class Over"
            } else {
                return ""
            }
        } else {
            return ""
        }
        
    }
    
    func getMainTimeLabel() -> String {
        let currentDateTime = appDelegate.Days[0].getDate_AsString()
        let Day_Num = appDelegate.Days[0].getDayOfWeek_fromString(currentDateTime)
        if Day_Num < 5 {
            let currentValues = CurrentDayandStuff()
            let currentBlock = currentValues.current_block
            let currentClass = appDelegate.Days[Day_Num].messages_forBlock[currentBlock]
            if currentClass != nil {
                let minutesRemaining = currentValues.minutesRemaining
                return "\(minutesRemaining) mins remaining"
            } else if currentBlock == "GetToClass" {
                let minutesRemaining = currentValues.minutesRemaining
                let minutesUntil = 5 - (-minutesRemaining)
                return "\(minutesUntil) mins until"
            } else {
                return "School Over"
            }
        } else {
            return "No School"
        }
    }
    
    func getMainNextBlockLabel() -> String {
        let currentDateTime = appDelegate.Days[0].getDate_AsString()
        let Day_Num = appDelegate.Days[0].getDayOfWeek_fromString(currentDateTime)
        
        if Day_Num < 5 {
            let currentValues = CurrentDayandStuff()
            let currentBlock = currentValues.current_block
            let nextBlock = currentValues.next_block
            let nextClass = appDelegate.Days[Day_Num].messages_forBlock[nextBlock]
            if nextClass != nil {
                return "Next: \(nextBlock) Block (\(nextClass!))"
            } else if currentBlock == "GetToClass" {
                return "Next Block"
            } else {
                return ""
            }
        } else {
            return ""
        }
    }
    
    
    
    func checkSecondLunch() {
        //checks for second lunch days
        let defaults = NSUserDefaults(suiteName:"group.vishnu.squad.widget")
        var firstLunch_temp: Bool = true
        if defaults!.objectForKey("SwitchValues") != nil {
            let UserSwitch: [Bool] = defaults!.objectForKey("SwitchValues") as! Array<Bool>
            firstLunch_temp = UserSwitch[dayNum]
        }
        
        if(!firstLunch_temp) {
            
            let time_of_secondLunch = appDelegate.Second_Lunch_Start[dayNum];
            
            appDelegate.Days[dayNum].ordered_times[5] = time_of_secondLunch
      
        }
    }
    
    
    //CREATE TABLE
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows in the section.
        return self.numOfRows
    }
    
    func getNumOfRows() {
        //finds number of rows in table
        numOfRows = labels.count
            
        print("Rows Updated")
        print("")
    }
    
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        //creates cells
        if (appDelegate.Days.count > 0) {
            let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! BlockTableViewCell
            let label = labels[indexPath.row]
            cell.label = label
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! BlockTableViewCell
            let label = Label(bL: "", cN: "", cT: "")
            cell.label = label
            
            return cell
        }
        
    }
    
    
    func generateLabels() {
        //generates array of information for each cell
        if !labelsGenerated {
            if dayNum < 5 {
            for (index, time) in appDelegate.Days[dayNum].ordered_times.enumerate(){
            
                var blockLetter = ""
                let blockName = appDelegate.Days[dayNum].ordered_blocks[index];
                if blockName == "Lab" {
                    blockLetter = "\(appDelegate.Days[dayNum].ordered_blocks[index - 1])L"
                } else if blockName == "Activities" {
                    blockLetter = "Ac"
                } else {
                    blockLetter = blockName
                }
            
                var classLabel = ""
                let className = appDelegate.Days[dayNum].messages_forBlock[blockName];
                if className == blockLetter {
                    classLabel = "\(blockName) Block"
                } else if blockName == "Lab" {
                    classLabel = "\(appDelegate.Days[dayNum].ordered_blocks[index - 1]) Lab"
                } else {
                    classLabel = className!
                }
            
                //time is in the form of string, in military time, so the following converts it to a regular looking time
            
                let hours = substring(time, StartIndex: 1, EndIndex: 3)
                var hours_num:Int! = Int(hours);
                if (hours_num > 12){
                    hours_num = hours_num! - 12;
                }
                let regular_hours:String! = String(hours_num);
                let minutes = substring(time,StartIndex: 4,EndIndex: 6)
                let final_time = regular_hours + ":" + minutes
            
                //converting is ended "final_time" is the correct time
            
                let newLabel = Label(bL: blockLetter, cN: classLabel, cT: final_time)
                labels.append(newLabel)
            
                print(blockLetter + " " + classLabel + " " + final_time + " ")
                print("")
            }
            
            self.labelsGenerated = true
            
            }
        }
        
    }
   
    
    
    
    //OTHER
    
    func find_Minutes(hour_before : Int, hour_after : Int)->Int{
        
        var HOUR_AFTER_MINUS_FIVE = hour_after
        
        if(hour_after%100 < 5){
            
            HOUR_AFTER_MINUS_FIVE = hour_after - 5 - 40
            
        }
        else{
            HOUR_AFTER_MINUS_FIVE = hour_after - 5
        }
        
        
        
        let num_hours_less = Int(hour_before/100)
        let num_hours_more = Int(HOUR_AFTER_MINUS_FIVE/100)
        
        let diff_hours = num_hours_more-num_hours_less
        
        print("Diff in hours" + String(diff_hours))
        
        let diff_minutes = HOUR_AFTER_MINUS_FIVE%100 - hour_before%100
        
        print("Diff in minutes" + String(diff_minutes))
        
        
        return diff_hours*60 + diff_minutes;
        
        
    }
    
    
    
    func CurrentDayandStuff() -> (current_block : String, next_block : String, minutesRemaining : Int){
        
        
        let currentDateTime = appDelegate.Days[0].getDate_AsString()
        let Day_Num = appDelegate.Days[0].getDayOfWeek_fromString(currentDateTime)
        var Widget_Block = appDelegate.Widget_Block;
        var Time_Block = appDelegate.Time_Block;
        var End_Times = appDelegate.End_Times;
        var Curr_block = ""
        var next_block = ""
        
        var minutes_until_nextblock = 0;
        
        //NEW STUFF get's info for the first lunch data for today
        let defaults = NSUserDefaults(suiteName:"group.vishnu.squad.widget")
        let UserSwitch: [Bool] = defaults!.objectForKey("SwitchValues") as! Array<Bool>
        let firstLunch_temp = UserSwitch[Day_Num]
        //NEW STUFF
        
        
        //NEW STUFF
        //we change the time's array to reflect the second lunch if they have second lunch
        if(!firstLunch_temp){ //aka second lunch
            
            print("they have second lunch today, run a different schedule")
            
            let time_of_secondLunch = appDelegate.Second_Lunch_Start[Day_Num];
            
            var counter = 0;
            
            for x in Widget_Block[Day_Num]{
                
                
                if(x.hasSuffix("2")){
                    
                    Time_Block[Day_Num][counter] = time_of_secondLunch;
                    
                }
                
                
                counter++;
                
            }
            
            print("new time schedule");
            print(Time_Block[Day_Num]);
            
        }
        //NEW STUFF
        
        for i in Array((0...Widget_Block[Day_Num].count-1).reverse()){
            
            let dateAfter = Time_Block[Day_Num][i]
            let CurrTime = appDelegate.Days[0].NSDateToStringWidget(NSDate())
            
            //      CurrTime = "-09-33";
            
            var End_Time_String = ""
            if(i+1 <= Widget_Block[Day_Num].count-1){
                End_Time_String = Time_Block[Day_Num][i+1]
            }
            
            print("Date After : " + dateAfter)
            print("Current Date : " + CurrTime)
            
            var hour4 = self.substring(dateAfter,StartIndex: 1,EndIndex: 3)
            hour4 = hour4 + self.substring(dateAfter,StartIndex: 4,EndIndex: 6)
            
            var hour2 = self.substring(CurrTime,StartIndex: 1,EndIndex: 3)
            hour2 = hour2 + self.substring(CurrTime,StartIndex: 4,EndIndex: 6)
            
            var end_time = self.substring(End_Time_String,StartIndex: 1,EndIndex: 3)
            end_time = end_time + self.substring(End_Time_String,StartIndex: 4,EndIndex: 6)
            
            
            let hour_one = Int(hour4)
            let hour_two = Int(hour2)
            let hour_after = Int(end_time)
            
            
            print("Blcok  Date  hour : ")
            print(hour_one, terminator: "")
            print("Current Date hour: ")
            print(hour_two, terminator: "")
            print("After Date  hour : ")
            print(hour_after)
            
            
            
            if(i == Widget_Block[Day_Num].count-1 && hour_two >= hour_one){
                
                let EndTime = End_Times[Day_Num]
                if(hour_two! - EndTime < 0){
                    
                    
                    minutes_until_nextblock = self.find_Minutes(hour_two!, hour_after: (EndTime))
                    
                    print("Miuntes until next blok " + String(minutes_until_nextblock))
                    if(minutes_until_nextblock > 0){
                        Curr_block = Widget_Block[Day_Num][i]
                    }
                    else {
                        Curr_block = "GetToClass"
                    }
                }
                else{
                    print("After School")
                    Curr_block = "NOCLASSNOW"
                }
                
                break;
                
            }
            
            
            if(hour_two >= hour_one){
                
                
                minutes_until_nextblock = self.find_Minutes(hour_two!, hour_after: (hour_after!))
                
                print("Miuntes unitl next block " + String(minutes_until_nextblock))
                
                if(minutes_until_nextblock > 0){
                    
                    Curr_block = Widget_Block[Day_Num][i]
                    
                    next_block = Widget_Block[Day_Num][i + 1]
                }
                else{
                    Curr_block = "GetToClass"
                    next_block = ""
                }
                
                break;
            }
            
        }
        
        return (Curr_block, next_block, minutes_until_nextblock);
        
    }
    
    
    
    func substring(origin :String, StartIndex : Int, EndIndex : Int)->String{
        var counter = 0
        var subString = ""
        for char in origin.characters{
            
            if(StartIndex <= counter && counter < EndIndex){
                subString += String(char)
            }
            
            counter++;
            
        }
        
        return subString
        
    }
    
}
