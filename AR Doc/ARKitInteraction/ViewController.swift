/*
See LICENSE folder for this sample’s licensing information.

Abstract:
Main view controller for the AR experience.
*/

import ARKit
import SceneKit
import UIKit

class ViewController: UIViewController {
    
    // MARK: IBOutlets
    
    @IBOutlet var sceneView: VirtualObjectARView!
    
    @IBOutlet weak var addObjectButton: UIButton!
    
    @IBOutlet weak var blurView: UIVisualEffectView!
    
    @IBOutlet weak var spinner: UIActivityIndicatorView!

    @IBOutlet weak var backButton: UIButton!
    
    @IBOutlet weak var doneButton: UIButton!
    
    @IBOutlet weak var pictureButton: UIButton!
    
    @IBOutlet weak var colorSlider: ColorSlider!
    
    @IBOutlet weak var colorIndicator: UIButton!
    // MARK: - UI Elements
    
    var focusSquare = FocusSquare()
    
    /// The view controller that displays the status and "restart experience" UI.
    lazy var statusViewController: StatusViewController = {
        return childViewControllers.lazy.flatMap({ $0 as? StatusViewController }).first!
    }()
    
    // MARK: - ARKit Configuration Properties
    
    /// A type which manages gesture manipulation of virtual content in the scene.
    lazy var virtualObjectInteraction = VirtualObjectInteraction(sceneView: sceneView)
    
    /// Coordinates the loading and unloading of reference nodes for virtual objects.
    let virtualObjectLoader = VirtualObjectLoader()
    
    /// Marks if the AR experience is available for restart.
    var isRestartAvailable = true
    
    /// A serial queue used to coordinate adding or removing nodes from the scene.
    let updateQueue = DispatchQueue(label: "com.example.apple-samplecode.arkitexample.serialSceneKitQueue")
    
    var screenCenter: CGPoint {
        let bounds = sceneView.bounds
        return CGPoint(x: bounds.midX, y: bounds.midY)
    }
    
    /// David's Drawing stuff
    
    var drawingNodes = [DynamicGeometryNode]()
    
    var isTouching = false
    
    var hasModel = false
    
    var lastPictureNode: SCNNode?
    
    /// Convenience accessor for the session owned by ARSCNView.
    var session: ARSession {
        return sceneView.session
    }
    
    // MARK: - View Controller Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sceneView.delegate = self
        sceneView.session.delegate = self
        
        backButton.layer.cornerRadius = 10
        doneButton.layer.cornerRadius = 10
        
        colorSlider.orientation = .horizontal
        colorSlider.previewEnabled = true
        
        colorIndicator.layer.cornerRadius = 15
        colorIndicator.backgroundColor = colorSlider.color
        colorIndicator.layer.borderColor = UIColor.white.cgColor
        colorIndicator.layer.borderWidth = 2
        
        let defaults = UserDefaults.standard
        defaults.set(false, forKey: "picture")
        UserDefaults.standard.synchronize()

        // Set up scene content.
        setupCamera()
        sceneView.scene.rootNode.addChildNode(focusSquare)

        /*
         The `sceneView.automaticallyUpdatesLighting` option creates an
         ambient light source and modulates its intensity. This sample app
         instead modulates a global lighting environment map for use with
         physically based materials, so disable automatic lighting.
         */
        sceneView.automaticallyUpdatesLighting = false
        if let environmentMap = UIImage(named: "Models.scnassets/sharedImages/environment_blur.exr") {
            sceneView.scene.lightingEnvironment.contents = environmentMap
        }

        // Hook up status view controller callback(s).
        statusViewController.restartExperienceHandler = { [unowned self] in
            self.restartExperience()
        }
        
        colorSlider.addTarget(self, action: #selector(changedColor(_:)), for: .valueChanged)
        
        //let tapGesture = UITapGestureRecognizer(target: self, action: #selector(showVirtualObjectSelectionViewController))
        // Set the delegate to ensure this gesture is only used when there are no virtual objects in the scene.
        //tapGesture.delegate = self
        //sceneView.addGestureRecognizer(tapGesture)
    }

	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		
		// Prevent the screen from being dimmed to avoid interuppting the AR experience.
		UIApplication.shared.isIdleTimerDisabled = true
        
        //David delete?
        addObjectButton.setImage(#imageLiteral(resourceName: "add"), for: [])
        addObjectButton.setImage(#imageLiteral(resourceName: "addPressed"), for: [.highlighted])

        // Start the `ARSession`.
        resetTracking()
        
        self.statusViewController.showMessage("INITIALIZING")
	}
	
	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)

        session.pause()
	}
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        restartExperience()
    }

    // MARK: - Scene content setup

    func setupCamera() {
        guard let camera = sceneView.pointOfView?.camera else {
            fatalError("Expected a valid `pointOfView` from the scene.")
        }

        /*
         Enable HDR camera settings for the most realistic appearance
         with environmental lighting and physically based materials.
         */
        camera.wantsHDR = true
        camera.exposureOffset = -1
        camera.minimumExposure = -1
        camera.maximumExposure = 3
        
    }

    // MARK: - Session management
    
    /// Creates a new AR configuration to run on the `session`.
	func resetTracking() {
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = .horizontal
		session.run(configuration, options: [.resetTracking, .removeExistingAnchors])

        //statusViewController.scheduleMessage("FIND A SURFACE TO PLACE AN OBJECT", inSeconds: 75.0, messageType: .planeEstimation)
        
        addObjectButton.isHidden = false
	}

    // MARK: - Focus Square

	func updateFocusSquare() {
        let isObjectVisible = virtualObjectLoader.loadedObjects.contains { object in
            return sceneView.isNode(object, insideFrustumOf: sceneView.pointOfView!)
        }
        
        if isObjectVisible {
            focusSquare.hide()
        } else {
            focusSquare.unhide()
            //statusViewController.scheduleMessage("TRY MOVING LEFT OR RIGHT", inSeconds: 5.0, messageType: .focusSquare)
        }
        
        // We should always have a valid world position unless the sceen is just being initialized.
        guard let (worldPosition, planeAnchor, _) = sceneView.worldPosition(fromScreenPosition: screenCenter, objectPosition: focusSquare.lastPosition) else {
            updateQueue.async {
                self.focusSquare.state = .initializing
                self.sceneView.pointOfView?.addChildNode(self.focusSquare)
            }
            addObjectButton.isHidden = true
            return
        }
        
        updateQueue.async {
            self.sceneView.scene.rootNode.addChildNode(self.focusSquare)
            let camera = self.session.currentFrame?.camera
            
            if let planeAnchor = planeAnchor {
                self.focusSquare.state = .planeDetected(anchorPosition: worldPosition, planeAnchor: planeAnchor, camera: camera)
            } else {
                self.focusSquare.state = .featuresDetected(anchorPosition: worldPosition, camera: camera)
            }
        }
        if (hasModel == false) {
            statusViewController.showMessage("SURFACE DETECTED, TAP + TO PLACE OBJECT")
        }
        addObjectButton.isHidden = false
        statusViewController.cancelScheduledMessage(for: .focusSquare)
	}
    
	// MARK: - Error handling
    
    func displayErrorMessage(title: String, message: String) {
        // Blur the background.
        blurView.isHidden = false
        
        // Present an alert informing about the error that has occurred.
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let restartAction = UIAlertAction(title: "Restart Session", style: .default) { _ in
            alertController.dismiss(animated: true, completion: nil)
            self.blurView.isHidden = true
            self.resetTracking()
        }
        alertController.addAction(restartAction)
        present(alertController, animated: true, completion: nil)
    }

    @IBAction func backAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func doneAction(_ sender: Any) {
        print("done")
    }
    
    @IBAction func takePicture(_ sender: Any) {
        
        let defaults = UserDefaults.standard
        /*
        if (defaults.bool(forKey: "picture") == true) {
            let last = sceneView.scene.rootNode.childNodes.count
            sceneView.scene.rootNode.childNodes[last - 1].removeFromParentNode()
        }*/
 
        let image = self.sceneView.snapshot()
        guard let data = UIImageJPEGRepresentation(image, 1) ?? UIImagePNGRepresentation(image) else {
            return
        }
        guard let directory = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false) as NSURL else {
            return
        }
        do {
            try data.write(to: directory.appendingPathComponent("fileName.png")!)
            defaults.set(true, forKey: "picture")
            UserDefaults.standard.synchronize()
            doneButton.setTitle("Next>", for: .normal)
            print("sucessfully saved image")
            statusViewController.showMessage("PICTURE SUCCESSFULLY SAVED")
        } catch {
            print(error.localizedDescription)
            return
        }
        
        if (lastPictureNode != nil) {
            lastPictureNode?.removeFromParentNode()
        }
        
        
        
        guard let pov = sceneView.pointOfView else {
            return
        }
        let imagePlane = SCNPlane(width: sceneView.bounds.width / 6000, height: sceneView.bounds.height / 6000)
        imagePlane.firstMaterial?.diffuse.contents = sceneView.snapshot()
        imagePlane.firstMaterial?.lightingModel = .constant
        let planeNode = SCNNode(geometry: imagePlane)
        lastPictureNode = planeNode
        //planeNode.transform = SCNMatrix4MakeRotation(Float(-CGFloat.pi/2), 1, 0, 0)
        sceneView.scene.rootNode.addChildNode(planeNode)
        planeNode.transform = SCNMatrix4MakeTranslation(pov.transform.m41, pov.transform.m42, pov.transform.m43 - 0.2)
        
        //self.performSegue(withIdentifier: "finishAR", sender: self)
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    @objc func changedColor(_ slider: ColorSlider) {
        colorIndicator.backgroundColor = slider.color
    }
}
