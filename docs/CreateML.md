# Designing datasets for CreateML

After a converstation with my lecturer Jenni, I understood that a simple dataset was needed to start training the TitanUp Model. While further research will be needed to begin setting up training data, Here is my understanding so far.

For a complete dataset the following is needed:

1. Data points: for a push up, this would be two points. the top of the pushup and the bottom of the push up.
2. Each data point would need to be separated into a folder.
3. Images of each pose would need to be placed into the correct folder.
4. each data point would need a minimum of 20 images each.
5. test data would need to be separated into another folder with 80 images each, plus image of incorrect pushups.

The take away understanding here is: CreateML models are set up using folders and subfolders of images that are separated so the application can distinguish the different datapoints. For example. a folder named "top" or "up" would contain all the images of the straight-armed pushup position ready, and a folder named "down" or "Bottom" would hold the bent-arm pushup completed images. Each folder will contain lots of images in the same general position at the same angle. 

<p align= "center">
<img src="/docs/assets/up_1.jpg"/width=300>
</p>

## Labeling Data
I used Roboflow to annotate my images for object detection, focusing on three distinct classes: "start," "finish," and "wrong." Roboflow is an online platform designed to streamline the image annotation and dataset preparation process for machine learning projects. I began by uploading my dataset of images directly into Roboflow's user-friendly interface. Each image was loaded into the annotation tool, where I manually drew bounding boxes around areas representing the three classes.

The "start" class was used to label the initial position of a push-up, the "finish" class marked the lowered position, and the "wrong" class highlighted incorrect or improper form during the exercise. For each annotation, I ensured consistency in labeling to maintain dataset integrity, which is critical for accurate model training.

Once all images were annotated, Roboflow automatically generated a dataset summary, providing insights into annotation coverage and class distribution. I then exported the annotated dataset in a format compatible with CreateML, specifically in JSON format, ensuring it included both the image files and corresponding annotation metadata. Roboflow's streamlined tools and validation checks made the annotation process efficient, laying a strong foundation for training an accurate push-up detection model in CreateML.

## Training The Model

A set of 20 images were used to train a simple detection model. The images were separated into 3 classes:

* Start: This can be also called push-up position ready. The arms are straight and knees are off the ground.
* Finish: this is push-up complete or the bottom of the rep.
* Wrong: is any position other than the two mentioned above.

The model trained for 25 iterations but converged at 17.

p align= "center">
<img src="/docs/assets/modelTestXcode.png"/width=300>
</p>
