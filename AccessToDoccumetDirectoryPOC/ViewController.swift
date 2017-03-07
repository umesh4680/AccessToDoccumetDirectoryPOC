//
//  ViewController.swift
//  AccessToDoccumetDirectoryPOC
//
//  Created by Umesh on 07/03/17.
//  Copyright © 2017 Umesh. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var fileNameTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func createFileButtonClicked(_ sender: Any) {
        
        self.createFileInDirectoryIfNotExists()

        
    }
    
    
    
    
    func createFileInDirectoryIfNotExists() {
        
        // let fileManager = FileManager.default
        
        //=== Check for Directory and create if not exist
        let dirPath = self.createDirectoryIfNotExist()
        
        if dirPath.length != 0
        {
            let fileName = self.fileNameTextField.text
            
            //=== Create File at Doc Path
           let filePath = dirPath.appendingPathComponent("abc.png"); // provide ur path component
           // let filePath = dirPath.appendingPathComponent("\(fileName).png"); // provide ur path component

            let filePathURL:URL = URL(string: filePath)!
            
            print("filePath = \(filePath)")
            
            let sourceURL = URL(string: "http://demo.myhubsolutions.com/Uploads/Demo/Documents/2015_04_17_13_25_17_869_15/pho2_2017_02_09_10_51_37_802_1.jpg")!
            
            
            var result : Bool = true
            
            if !FileManager.default.fileExists(atPath: filePath)  // Check If file Already there or not, If NOT write file at destination path
            {
                result = writeFileToDocDirectoryFromURL(sourceUrlPath: sourceURL, destinationPath: filePath)
            }
            
            if result {
                // load imaage from destination path.
               // webViewObj.loadRequest(NSURLRequest(url: filePathURL) as URLRequest)
                
                //self.webViewObj.loadData(tempData!, MIMEType: "application/pdf", textEncodingName: "UTF-8", baseURL: NSURL() as URL)
            }
        }
    }
    

    
    
    
    func createDirectoryIfNotExist()-> NSString {
        
        // Path to Doc directory
        let documentDirectorypath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first
        
        var digDocDirectoryPath = ""
        
        if let documentDirectorypath = documentDirectorypath{
            
            // Create Custom Folder Path
            digDocDirectoryPath = (documentDirectorypath.appending("/811ExpressDoc") as NSString) as String
            
            let fileManager = FileManager.default
            
            if
                !fileManager.fileExists(atPath: digDocDirectoryPath as String) // Check DocDirectory exist or not If not Create it.
            {
                
                do{
                    print("Not Exist Create Directory")
                    
                    try fileManager.createDirectory(atPath: digDocDirectoryPath as String, withIntermediateDirectories: false, attributes: nil)
                }
                catch
                {
                    print("Unable to Create Directory")
                    digDocDirectoryPath = ""
                }
            }
            else
            {
                print("Exist Directory  - Create file and write")
                
            }
        }
        return digDocDirectoryPath as NSString
    }
    
    
    
    
    func writeFileToDocDirectoryFromURL(sourceUrlPath:URL,destinationPath:String) -> Bool {
        
        let result : Bool
        //  let childURL = URL(string: "http://demo.myhubsolutions.com/Uploads/Demo/Documents/2015_04_17_13_25_17_869_15/pho2_2017_02_09_10_51_37_802_1.jpg")!
        var childPathData = NSData()
        
        do{
            childPathData = try NSData(contentsOf: sourceUrlPath, options: NSData.ReadingOptions())
            print("Source Data 1 = \(childPathData)")
            
            FileManager.default.createFile(atPath: destinationPath, contents: childPathData as Data, attributes: nil)
            
            result = true
        }
        catch
        {
            print("Source Data 2 = \(childPathData)")
            result = false
        }
        
        return result
    }

    
    /*
     
     
     Call = 
     
     [self createFileInDirectoryIfNotExists:"File name"];

 
     -(void)createFileInDirectoryIfNotExists:(DocumentsListJSONParser *)documentsListJSONParser {
     NSString *directoryPath = [self createDirectoryIfNotExists];
     NSArray *arrURLComponents = [strPdfFileURL componentsSeparatedByString:@"/"];
     strPDFfilePath = [directoryPath stringByAppendingPathComponent:[arrURLComponents lastObject]];
     NSFileManager *fileManager = [NSFileManager defaultManager];
     BOOL fileExists = [fileManager fileExistsAtPath:strPDFfilePath];
     if (!fileExists) {
     // File does not exist in Document Directory
     // Make api call to download it into Document Directory
     NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:strPdfFileURL]];
     AFHTTPRequestOperation *operation =   [[AFHTTPRequestOperation alloc] initWithRequest:request];
     operation.outputStream = [NSOutputStream outputStreamToFileAtPath:strPDFfilePath append:NO];
     [operation setDownloadProgressBlock:^(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead) {
     // myProgressTask uses the HUD instance to update progress
     progressHUD.progress = (float)totalBytesRead / (float)totalBytesExpectedToRead;
     }];
     [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
     
     [self hideprogressHUD];
     [self readPDFFile];
     if (documentsListJSONParser.intContentDetailsId > 0 && !documentsListJSONParser.isContentRead) {
     [self doAPICallToUpdateReadStatusOfDocument:documentsListJSONParser.intContentDetailsId];
     }
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
     #if k_IS_LOG_ENABLED
     NSLog(@"Error in downloading Newsletter Document from server: %@", error);
     #endif
     [self hideprogressHUD];
     [[NSFileManager defaultManager] removeItemAtPath:strPDFfilePath error:nil]; // Delete the file
     [self showAlertViewWithTitle:kALERT_TITLE_SORRY setMessage:kALERT_MESSAGE_API_FAILED_TO_CONNECT_TO_SERVER setDelegete:nil setOtherbuttonTitles:nil];
     }];
     
     [operation start];
     } else {
     // File exists in Document Directory
     // Load file from Document Directory
     [self hideprogressHUD];
     if ([fileManager isReadableFileAtPath:strPDFfilePath]) {
     [self readPDFFile];
     }
     }
     }
     
     -(NSString *)createDirectoryIfNotExists {
     NSError *error;
     NSFileManager *fileManager = [NSFileManager defaultManager];
     NSString *directoryPath = [documentsDirectoryPath stringByAppendingPathComponent:kDIRECTORY_NEWSLETTERS];
     if (![fileManager fileExistsAtPath:directoryPath]) {
     [fileManager createDirectoryAtPath:directoryPath withIntermediateDirectories:NO attributes:nil error:&error];
     }
     
     if (error) {
     return [error localizedDescription];
     }
     return directoryPath;
     }
     
     -(void)readPDFFile {
     NSFileManager *fileManager = [NSFileManager defaultManager];
     if ([fileManager fileExistsAtPath: strPDFfilePath] && strPDFfilePath != nil)
     {
     // File exists at path
     //creating the object of the QLPreviewController
     QLPreviewController *previewController = [[QLPreviewController alloc] init];
     //settnig the datasource property to self
     previewController.dataSource = self;
     previewController.delegate = self;
     [previewController setCurrentPreviewItemIndex:0];
     [self.navigationController pushViewController:previewController animated:YES];
     } else {
     // File does not exist at path
     // Download it again
     [self showAlertViewWithTitle:kALERT_TITLE_SORRY setMessage:kALERT_MESSAGE_API_FAILED_TO_CONNECT_TO_SERVER setDelegete:nil setOtherbuttonTitles:nil];
     }
     }

 
 
 
        */
    

    

}

