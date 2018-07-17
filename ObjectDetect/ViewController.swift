//
//  ViewController.swift
//  ObjectDetect
//
//  Created by Indra Aristya on 7/16/18.
//  Copyright © 2018 Indra Aristya. All rights reserved.
//

import UIKit
import CoreML
import Vision

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var appLabel: UILabel!
    @IBOutlet weak var ndrLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var classificationLabel: UITextView!
    @IBOutlet weak var mainButton: UIButton!
    @IBOutlet weak var secondButton: UIBarButtonItem!
    
    let imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        imagePicker.allowsEditing = false
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let imageUsed = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imageView.image = imageUsed
            guard let _ciimage = CIImage(image: imageUsed) else {
                fatalError("Couldn't Conver into CIImage")
            }
            detect(image: _ciimage)
        }
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    func detect(image: CIImage) {
        guard let model = try? VNCoreMLModel(for: Inceptionv3().model) else {
            fatalError("Failed to load MLModel")
        }
        let request = VNCoreMLRequest(model: model) { (request, error) in
            guard let result = request.results as? [VNClassificationObservation] else {
                fatalError("Failed to process Image")
            }
            self.navigationItem.title = "Object Recognition"
            self.classificationLabel.text = result.first?.identifier
            self.appLabel.isHidden = true
            self.ndrLabel.isHidden = true
            print(result)
        }
        let handler = VNImageRequestHandler(ciImage: image)
        do {
            try handler.perform([request])
        } catch {
            print(error)
        }
    }
    
    @IBAction func cameraPressed(_ sender: UIBarButtonItem) {
        present(imagePicker, animated: true, completion: nil)
    }
    
    
    @IBAction func camPressed(_ sender: UIButton) {
        present(imagePicker, animated: true, completion: nil)
        self.mainButton.isHidden = true
        
    }
}

