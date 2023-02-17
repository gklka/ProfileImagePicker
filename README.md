# ProfileImagePicker
[Craft iOS Coding Challenge](https://www.craft.do/s/UEmNt7phWBwxhi)

## Goals

The goal of this project is to create a profile image editor class, which can be reused anywhere. The editor should provide controls for adding colors, text, and images to the profile picture.

![Demo](http://gk.lka.hu/x/demo.gif)

## Requirements

- Manual layouting (no AutoLayout)
- No Interface Designer
- No SwiftUI
- Swift language
- Use Craft's design language
- Fully cross-platform iOS/iPadOS/macOS (Catalyst)

## Designing

I've decided to provide three basic functionalities to a profile image:

1. Add images from anywhere - this can act either as a background below the text overlay, or the main content.

2. Selectable colors for solid or gradient backgrounds - If the user provides two colors, a vertical gradient is being drawn.

3. Text overlay - Can be used to display initials of the profile, short words or even a big emoji

I've considered and dropped the idea of providing the user the recent images, because the whole purpose of setting profile images to things is to make them distinguishable, which involves using different images, colors and settings. It is unlikely, that users want to reuse images frequently.

## Implementation

 The final implementation consists of three parts:
 
 - A `ProfileImage` model which stores the colors, images and settings of a profile image
 - A `ProfileImageView` class, which can display a profile image, and if set, it can open the editor
 - The `EditProfileImageController` editor, where the user can customize a profile image
 
The demo project demonstrates a `ProfileImageView` with a default text and gradient, which can be resized. The profile image view also supports rectangular, circular and round-rect shapes. The demo provides controls for testing this.

Both `ProfileImageView` and `EditProfileImageController` uses the delegate pattern to provide the results to the caller. It is the callers responsibility to store the profile image details and upload the underlying images if needed.

The profile image has either an `image`, a `color` or a `gradient` background, and (a nullable) `text` on it:

```swift
struct ProfileImage {
    enum BackgroundType {
        case color(UIColor)
        case gradient(UIColor, UIColor)
        case image(UIImage)
    }

    var background = BackgroundType.color(.gray)
    var text: String?
}
```

## Usage

You can add `ProfileImageView` to a view just by instantiating it:

```swift
var profileImageView = ProfileImageView()
profileImageView.profileImage = ProfileImage(background: .gradient(.blue, .purple), text: "GK")
self.view.addSubview(profileImageView)
```

The profile image can act as a display only view instance, or as a button. This can be set using the `editable` property:

```swift
profileImageView.editable = true
```

If editing is enabled, tapping the profile image view opens a modal view with the profile image editor.

You can also set the shape and corner radius of the profile image view:

```swift
profileImageView.shape = .roundRect(5)
```

The editor provides the changed image via it's delegate:

```swift
extension ViewController: ProfileImageViewDelegate {
    func profileImageView(_ profileImageView: ProfileImageView, wantsToChangeImageTo profileImage: ProfileImage) {
        // TODO: upload image, store it permanently
    }
}
```

You can change the displayed profile image or any properties of the `ProfileImageView` at any time, the view refreshes accordingly.

## Editor Features

- The image can be set from the camera, from the user's Photo Library, Files app/File requester (depending on platform), or by dragging it over the profile image preview on the editor. The code uses iOS's built-in `UIImagePickerController` for camera and photos, and `UIDocumentPickerViewController` for files. Be aware of the project settings, entitlements might needed.
- If no image is provided, a color will be used. The editor displays pickable start and end colors. The code displays iOS's `UIColorPickerViewController` for selecting a color.
- If the two selected colors are the same, or the second one is transparent, only a solid color will be rendered and stored.
- The text on the profile image can be changed, or left empty. It supports any text length, but only the first few characters will be shown. Text shrinks if the entered text is longer.
- Changes can be seen instantly on the profile image preview
- When there was an image added previously, and the user selects "Color", it is possible for the user to change his mind and press the button again to revert to the image.
- Last set colors are also remembered.
- I am using iOS's "editing" feature after the camera and photos pickers, so the user can zoom and move the selected image to square aspect ratio
- The set image is resized to 500x500 px
- Color settings are hidden when an image is set
- Supports dark/light appearance
- Supports both macOS (Catalyst) and iOS presentation
- Adapts to the presented controller size
- The editor provides a standard "X" button to close, this causes the currently set profile image to "save" (which is provided by the caller). You can also drag the modal sheet to dismiss it without changing the image.

## Known limitations

- There is no check for camera availability. We should always check if any camera is available.
- Opening Photo Library picker with large libraries takes time. We should display a progress indicator for this using the app's design language
- Design language does not exactly match Craft app's. The general style and way of thinking is as close as possible, but I did not want to recreate every detail, like button borders on macOS, etc. The final implementation should use the same buttons already programmed in the code.
- I did not add animations
- The color of the overlay text on the profile image is either dark or light depending on the background below it. I implemented this only for `solid` colors. `gradient`s use the top color for determining, and `image`s always use light color. We should add code to handle these cases correctly.
- On small screens the text field can be covered by the keyboard.

## Improvement ideas

- We could use an own, more sophisticated code or a prebuilt library, like [TOCropViewController](https://github.com/TimOliver/TOCropViewController) to provide more convenient image cropping
- I'd like to see support for clipboard. For this I'd add a "paste" menu item to the preview of the editor. This way the user could copy paste images.
- The code can be turned into a library
- Custom font settings can be added. The rendering part is already done.
- We could also add a fifth button to open Craft's already built Unsplash image search
- Instead of solid elevated background, the edit panel could use a transparent material
- The `ProfileImage` should conform `Codable`, for easier serialization and saving
