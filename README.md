# README
This app displays the last 30 photos of the Nasa API (Astronomy Picture of the Day)

## Features
It has 3 screens :
- The first displays the photo of the day of the last 30 days 
- A loader is on each cell
- If the data returned by the API is a video, we will display a video logo :video_camera:)
- If an error is returned, the cell will be a bomb :bomb:
- A tap on a picture will display the picture details.
- A tap on a button of the 2nd screen will open the picture in high resolution modally 
- the HD image can be long to load, so a loader is displayed)

## How to run it
1. Clone this repo
2. Navigate to project folder
3. Run pod install
4. Build the project
5. Go to [NasaService.swift](/nasaApp/Network/NasaService.swift) and replace apiKey by your key
6. Run it on a simulator :iphone:

## Pods
The pods installed are:
```
'SwifterSwift'
'RxSwift', '~> 4.4.0'
'RxCocoa', '~> 4.4.0'
'RxFlow'
'Moya/RxSwift', '~> 12.0.1'
'RxDataSources', '~> 3.1.0'
'Kingfisher', '~> 4.0'
'RxGesture'
'RxSwiftExt', '~> 3.4.0'
'lottie-ios', '~> 3.0.1'
'RxTest'
```
