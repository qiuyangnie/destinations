//
//  AddViewController.swift
//  QiuyangNieAssign2
//
//  Created by Qiuyang Nie on 11/04/2019.
//  Copyright © 2019 Qiuyang Nie. All rights reserved.
//

import UIKit
import CoreData

class AddViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var webButton: UIBarButtonItem!
    @IBOutlet weak var cityNameTextField: UITextField!
    @IBOutlet weak var cityStateTextField: UITextField!
    
    @IBOutlet weak var cityImageView: UIImageView!
    @IBAction func addUpdate(_ sender: Any) {
        if citiesManagedObject != nil {
            Update()
        } else {
            add()
        }
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func pickUpImage(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum) {
            imagePicker.delegate = self
            imagePicker.sourceType = .savedPhotosAlbum
            imagePicker.allowsEditing = false
            present(imagePicker, animated: true, completion: nil)
        }
    }
    
    // CoreData
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    private var entity: NSEntityDescription! = nil
    var citiesManagedObject: Cities! = nil
    
    // add to CoreData
    func add() {
        // validation test
        if cityNameTextField.text == "" {
            alert(titleSetted: "Alert", messageSetted: "Please input the city name")
        } else {
            if cityStateTextField.text == "" {
                alert(titleSetted: "Alert", messageSetted: "Please input the city nation")
            } else {
                if cityImageView.image == nil {
                    alert(titleSetted: "Alert", messageSetted: "Please pick up an image for the city")
                } else {
                    citiesManagedObject = Cities(context: context)
                    citiesManagedObject.name = cityNameTextField.text
                    citiesManagedObject.state = cityStateTextField.text
                    if imageUpdated {
                        saveImage(name: photoURL)
                    }
                }
            }
        }
        do {try context.save()}
        catch { print("CoreData cannot be saved")}
    }
    
    // update CoreData
    func Update() {
        // validation test
        if cityNameTextField.text == "" {
            alert(titleSetted: "Alert", messageSetted: "Please input the city name")
        } else {
            if cityStateTextField.text == "" {
                alert(titleSetted: "Alert", messageSetted: "Please input the city nation")
            } else {
                if cityImageView.image == nil {
                    alert(titleSetted: "Alert", messageSetted: "Please pick up an image for the city")
                } else {
                    citiesManagedObject.name = cityNameTextField.text
                    citiesManagedObject.state = cityStateTextField.text
                    if imageUpdated {
                        saveImage(name: photoURL)
                    }
                }
            }
        }
        do {try context.save()}
        catch { print("CoreData cannot be saved")}
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Add & Update City"
        
        cityNameTextField.layer.borderWidth = 1.0
        cityStateTextField.layer.borderWidth = 1.0
        cityNameTextField.layer.borderColor = #colorLiteral(red: 0.4756349325, green: 0.4756467342, blue: 0.4756404161, alpha: 1)
        cityStateTextField.layer.borderColor = #colorLiteral(red: 0.4756349325, green: 0.4756467342, blue: 0.4756404161, alpha: 1)
        
        if citiesManagedObject != nil {
            cityNameTextField.text = citiesManagedObject.name
            cityStateTextField.text = citiesManagedObject.state
            cityImageView.image = UIImage(named: citiesManagedObject.image!)
            //cityImageView.image = UIImage(contentsOfFile: citiesManagedObject.image!)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // pick image
    private var photoURL: String! = nil
    private var imageUpdated = false
    
    private let imagePicker = UIImagePickerController()
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        cityImageView.image = image
        imageUpdated = true
        
        if let imgUrl = info[UIImagePickerControllerImageURL] as? URL{
            let imgName = imgUrl.lastPathComponent
            let documentDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first
            let localPath = documentDirectory?.appending(imgName)
            
            let image = info[UIImagePickerControllerOriginalImage] as! UIImage
            let data = UIImagePNGRepresentation(image)! as NSData
            data.write(toFile: localPath!, atomically: true)
            let url = String(describing: URL.init(fileURLWithPath: localPath!))
            photoURL = url.replacingOccurrences(of: "file://", with: "", options: .regularExpression, range: nil)
            print(photoURL)
        }
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func saveImage(name: String) {
        citiesManagedObject.image = name
    }
    
    func alert(titleSetted: String, messageSetted: String) {
        let alert = UIAlertController(title: titleSetted, message: messageSetted, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            switch action.style{
            case .default:
                print("default")
                
            case .cancel:
                print("cancel")
                
            case .destructive:
                print("destructive")
            }}))
        self.present(alert, animated: true, completion: nil)
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "webSegue" {
            let destination = segue.destination as! CityWebViewController
            destination.citiesManagedObject = citiesManagedObject
        }
    }
    
}
