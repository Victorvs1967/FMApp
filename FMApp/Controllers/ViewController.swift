//
//  ViewController.swift
//  FMApp
//
//  Created by Victor Smirnov on 08/06/2019.
//  Copyright © 2019 Victor Smirnov. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
  
  let fileManager = FileManager()
  
  var filesInDirectory = [String]() {
    didSet {
      tableView.reloadData()
    }
  }
  
  @IBOutlet weak var directoryContents: UITextView!
  
  @IBOutlet weak var tableView: UITableView!
  
  @IBAction func createFileButton(_ sender: UIButton) {
    
    for i in (1...10) {
      let fName = "file\(i).txt"
      let path = fileManager.temporaryDirectory.appendingPathComponent(fName).path
      let contentOfFile = "\(i) Some text here.\n\(i) Some text here.\n\(i) Some text here.\n\(i) Some text here."
      
      do {
        try contentOfFile.write(toFile: path, atomically: true, encoding: .utf8)
        directoryContents.text = "\(i) files create in temp directory."
        filesInDirectory.append(fName)
      } catch {
        directoryContents.text = "Could not create text file: \(error.localizedDescription)"
      }
    }
  }
  
  @IBAction func readFileButton(_ sender: UIButton) {
    
    if let fName = filesInDirectory.first {
      directoryContents.text = readFile(fName)
    } else {
      directoryContents.text = "Contents of directory:\nEmpty"
    }
    
  }
  
  @IBAction func deleteFileButton(_ sender: UIButton) {
    
    if filesInDirectory.count > 0 {
      
      do {
        let fName = filesInDirectory.first!
        let path = fileManager.temporaryDirectory.appendingPathComponent(fName).path
        try fileManager.removeItem(atPath: path)
        filesInDirectory.removeFirst()
        directoryContents.text = "\(fName) delete"
      } catch {
        directoryContents.text = error.localizedDescription
      }
    } else {
      directoryContents.text = "Contents of directory:\nEmpty"
    }
  }
  
  @IBAction func viewDirectoryButton(_ sender: UIButton) {
    
    checkDirectory()
    
    if filesInDirectory.count > 0 {
      directoryContents.text = "Contents of directory:\n\(filesInDirectory.joined(separator: "\n"))"
    } else {
      directoryContents.text = "Contents of directory:\nEmpty"
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view.
  }
//  Reading file content
  private func readFile(_ fileName: String) -> String {
    
    var result: String
    
    if filesInDirectory.count > 0 {
      let path = fileManager.temporaryDirectory.appendingPathComponent(fileName).path
      
      do {
        let contentOfFile = try String(contentsOfFile: path, encoding: .utf8)
        result = contentOfFile
      } catch {
        result = error.localizedDescription
      }
    } else {
      result = "Contents of directory:\nEmpty"
    }
    return result
  }
//  Reading directory content
  private func checkDirectory() {
    
    do {
      let files = try fileManager.contentsOfDirectory(atPath: fileManager.temporaryDirectory.path)
      
      if files.count > 0 {
        filesInDirectory = files
      } else {
        directoryContents.text = "Files not found"
      }
    } catch {
      directoryContents.text = error.localizedDescription
    }
  }
  
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
  
  //  Calculate rows in table
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
    return filesInDirectory.count
  }
  //  Put data to cell of table
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
    let item = filesInDirectory[indexPath.row]
    
    cell.textLabel?.text = item
    
    return cell
  }
  //  Call action with selected cell of table
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
    directoryContents.text = readFile(filesInDirectory[indexPath.row])
  }
}

