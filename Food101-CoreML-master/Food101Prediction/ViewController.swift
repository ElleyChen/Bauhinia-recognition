//
//  ViewController.swift
//  Food101Prediction
//
//  Created by Philipp Gabriel on 21.06.17.
//  Copyright © 2017 Philipp Gabriel. All rights reserved.
//

import UIKit
import CoreML

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var percentage: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func buttonPressed(_ sender: Any) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let imagePickerView = UIImagePickerController()
        imagePickerView.delegate = self

        alert.addAction(UIAlertAction(title: "Choose Image", style: .default) { _ in
            imagePickerView.sourceType = .photoLibrary
            self.present(imagePickerView, animated: true, completion: nil)
        })

        alert.addAction(UIAlertAction(title: "Take Image", style: .default) { _ in
            imagePickerView.sourceType = .camera
            self.present(imagePickerView, animated: true, completion: nil)
        })

        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String: Any]) {
        dismiss(animated: true, completion: nil)

        guard let image = info["UIImagePickerControllerOriginalImage"] as? UIImage else {
            return
        }

        processImage(image)
    }

    func processImage(_ image: UIImage) {
        let model = coreML_resnet50_100ep_zh()
        let size = CGSize(width: 224, height: 224)

        guard let buffer = image.resize(to: size)?.pixelBuffer() else {
            fatalError("Scaling or converting to pixel buffer failed!")
        }

        guard let result = try? model.prediction(data: buffer) else { //edited image:buffer
            fatalError("Prediction failed!")
        }
        
        
        //let confidence = result.BauhiniaConfidence["\(result.classLabel)"]! * 100.0 //edited foodconfidence
        //let converted = String(format: "%.2f", confidence)

        imageView.image = image
        percentage.text = "\(result.classLabel)"
        
        
        //"\(result.classLabel) - \(converted) %" //result.BauhiniaConfidence.description
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
