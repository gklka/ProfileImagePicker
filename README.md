# ProfileImagePicker
Craft iOS Coding Challenge

## Goals

The goal of this project is to create a profile image editor class, which can be reused anywhere. The editor should provide controls for adding colors, text, and images to the profile picture.

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
