#### @Flutter Branch

###### Uses:

- Firebase Authentication, Firestore, Storage
- State Management: BLoC

###### Configs before running the app:

Android, ios, web, windows, macos directories are git ignored. So you need to create them. Config guide is below:

- First be inside project directory (postreal)
- Run below commands
  ```
  # to create ios directory
  flutter create -i swift .
  # to create android directory
  flutter create -a kotlin .
  ```
- If you are going to run in ios, you need to specify camera permission to Info.plist file.
- Info.plist is located at ios/Runner/Info.plist
- Below is the key/string values that you need to add within the 'dict' tag of Info.plist file
  ```
  <key>NSCameraUsageDescription</key>
  <string>Camera Usage</string>
  ```
- Now after specifying ios permission requirement, you need to configure Firebase to this project.
- Add your own firebase_options.dart file which consists of your Firebase keys and configs inside lib directory. You can do this step by reading any docs of configuring Firebase with Flutter.
- For ios, you need GoogleService-Info.plist file. You can get this file from Firebase Console inside ios app section.
- After getting GoogleService-Info.plist file, Open ios directory in Xcode, now add this file to Runner/Runner directory.
- After setting your own Firebase, now you need to update the app bundle id of this app. Match same bundle id for this app and what you kept during Firebase configuration.
- Add google-services.json file that you download from Firebase Console to android/app directory.
- For android, add the Firebase SDK dependencies in the Project Level build.gradle file (android/build.gradle). Add below line in dependencies{} section
  ```
  classpath 'com.google.gms:google-services:4.3.10'
  ```
- Now you need to specify Google Services plugin in App Level build.gradle file (android/app/build.grade), to do it add below line
  ```
  apply plugin: 'com.google.gms.google-services'
  ```
- You also need to set minSdkVersion to 19 and enable multidex to true like shown below in the defaultConfig{} section

  ```
  minSdkVersion 19
  multiDexEnabled true
  ```

- Now you are ready to run the app.
