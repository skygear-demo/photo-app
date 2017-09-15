//
//  SecondViewController.swift
//  photo-app
//
//  Created by David Ng on 14/9/2017.
//  Copyright © 2017 Skygear. All rights reserved.
//

import UIKit
import SKYKit

class SecondViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet var tableView: UITableView!

    var posts = [Any]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        loadPosts()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.refreshView()
        self.loadPosts()
    }

    func refreshView() {
        if (SKYContainer.default().auth.currentUser != nil) {
            self.tableView.isHidden = false
        } else {
                self.tableView.isHidden = true
        }
    }
    
    func onCompletion(_ records:[Any]) {
        print("There are \(records.count) posts")
        print(records)
        self.posts = records
        self.tableView.reloadData()
    }
    
    func loadPosts() {
        let publicDB = SKYContainer.default().publicCloudDatabase
        let query = SKYQuery(recordType: "post", predicate: nil)
        let sortDescriptor = NSSortDescriptor(key: "_created_at", ascending: false)
        query.sortDescriptors = [sortDescriptor]
        
        publicDB.perform(query, completionHandler: { posts, error in
            if let error = error {
                print("Error retrieving photos: \(error)")
//                self.onCompletion(posts!)
            } else {
                self.onCompletion(posts!)
            }
        })
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let newsCell = tableView.dequeueReusableCell(withIdentifier: "feedcell", for: indexPath) as! FeedCell
        
        // Configure the cell...
        let record = self.posts[indexPath.row]
        let post = record as? SKYRecord
        
        let title = post?.object(forKey: "title" as NSCopying) as? String
        let content = post?.object(forKey: "content" as NSCopying) as? String
        
        newsCell.titleLabel.text = title
        newsCell.contentLabel.text = content
        newsCell.feedImageView.image = UIImage(named: "Placeholder")
        
        
        let imageAsset = post?.object(forKey: "asset") as? SKYAsset
        if let imageUrl = imageAsset?.url {
            print("URL: \(String(describing: imageAsset?.url))")
            URLSession.shared.dataTask(with: imageUrl) { data, response, error in
                if let imageData = data {
                    DispatchQueue.main.async {
                        newsCell.feedImageView.image = UIImage(data: imageData)
                    }
                }
                }.resume()
        }

        return newsCell

    }

    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    @IBAction func addPhotoButtonDidPress(_ sender: AnyObject) {
        self.presentImagePicker()
    }

    func presentImagePicker() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.modalPresentationStyle = .popover
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
    
    func presentPhotoDetailAlert(uploadedAsset: SKYAsset) {
        let alertController = UIAlertController(title: "Photo Detail", message: "Please input details below:", preferredStyle: .alert)
        
        let confirmAction = UIAlertAction(title: "Save", style: .default) { (_) in
            let titleField = alertController.textFields![0] as UITextField
            let contentField = alertController.textFields![1] as UITextField
            
            let post = SKYRecord(recordType: "post")
            post.setObject(titleField.text!, forKey: "title" as NSCopying)
            post.setObject(contentField.text!, forKey: "content" as NSCopying)
            post.setObject(SKYSequence(), forKey: "order" as NSCopying)
            
            post.setObject(uploadedAsset, forKey: "asset" as NSCopying)
            
            SKYContainer.default().publicCloudDatabase.save(post, completion: { (record, error) in
                if (error != nil) {
                    print("error saving post: \(String(describing: error))")
                    return
                }
                
                self.posts.insert(post, at: 0)
                let indexPath = IndexPath(row: 0, section: 0)
                self.tableView.insertRows(at: [indexPath], with: .automatic)
                self.showAlert(title: "Post Saved", message: "This post is shared!", actionText: "OK")
            })
        }
        
        let cancelAction = UIAlertAction(title: "Discard", style: .cancel) { (_) in
            self.showAlert(title: "Post Discard", message: "This post isn't saved", actionText: "OK")
        }
        
        alertController.addTextField { (textField) in
            textField.placeholder = "title"
        }
        
        alertController.addTextField { (textField) in
            textField.placeholder = "content"
        }
        
        alertController.addAction(confirmAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    func showAlert(title: String, message: String, actionText: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: actionText, style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
}

extension SecondViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    // Add implementation here
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage,
            let resizedImageData = PhotoHelper.resize(image: pickedImage, maxWidth: 800, quality: 0.9) {
            
            PhotoHelper.upload(imageData: resizedImageData, onCompletion: {uploadedAsset in
                if (uploadedAsset != nil) {
                    print("has photo")
                    
                    self.presentPhotoDetailAlert(uploadedAsset: uploadedAsset!)
                    

                } else {
                    print("no photo")
                }
            })
        }
        dismiss(animated: true, completion: {
            
        })
    }}

