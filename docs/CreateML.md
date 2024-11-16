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
<img src="/docs/assets/up_1.jpg"/>
</p>

