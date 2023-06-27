# Orienteering App

## Description

The Orienteering App is an iOS application that helps users navigate through a series of checkpoints in a designated area. The app uses the device's GPS to track the user's location and provide detailed directions to each checkpoint.

## Sensor

1. GPS (Global Positioning System)

   The GPS sensor is used to track players' locations while they navigate through the designated area.
   
2. Magnetometer

   The magnetometer is used to provide the user with a compass heading that they can use to navigate in the correct direction towards the next checkpoint.
   
3. Camera

   The camera is used to scan QR codes to activate the competitions or checkpoints

## How to play?

  1. scan the event qr code to activate the competition

     Once the valid event code is scanned, the app will insert the checkpoints to the current player on Firestore. However, players can only view the annotations of the checkpoint on the map and the checkpoint task. The tasks are locked until they reach the the checkpoints.
     
  2. scan the checkpoint qr code to activate the checkpoints

     Once the valid checkpoint code is scanned, the task will be unlocked.

  3. complete the task

     After Player finish the tasks. The score will be updated on Firestore.

## Checkpoints format
  There can be different formats of checkpoints in an orienteering activities. In this application, I have set up three types:

  1. Count the number of the [ballons]

     When player arrive this checkpoint location, they have to count the number of ballons or anything they can see in the checkpoint.
     
  2. Answer some simple quiz

     Players have to anwer some questions. The answers can be found in the checkpoint. (In this app, only some simple maths calculation is set)
     
  3. Upload a designated cat image

     The task will ask the player to upload a specific breed of cat.

## 3rd Party APIs

  1. Zyla: Identify cat breed
  2. TinyURL: Shorten the url.
    
  The image url store in Firestorage is very long or the format does not fit Zyla API that errors occur when calling the Zyla API to identify the cat breed . That's why the second api is used to conert the image url.

## Packages

<img width="883" alt="image" src="https://github.com/jasonkitfan/orienteering/assets/65491363/5f35fb60-1b01-4e37-afd4-54e6763823c6">

This application use Firebase SDK and Google Sign In SDK.

1. FirebaseAuth
2. FirebaseFirestore
3. FirebaseStorage
4. GoogleSignIn
5. GoogleSignInSwift

## Project Set Up

Xcode Version 13.3 (13E113)

Apple Swift version 5.6

## Ignored File

GoogleService-Info.plist

Secret.swift (containing the api key from Zyla)

## Additional Information

The commit history is not completed as the GoogleService-Info.plist is pushed by accident. As a result, some of the earlier commit information is no longer be available. This is the second push for the repository.



