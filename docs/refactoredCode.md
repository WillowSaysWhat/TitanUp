# table of contents

- [table of contents](#table-of-contents)
  - [CustomTextField](#customtextfield)
  - [CustomSecureField](#customsecurefield)
  - [LoginButton](#loginbutton)

## CustomTextField

This is the textfield found in the login page. Honestly, there was no need to refactor this code as it is unlikely to be reused. It is probably going at the bottom of the login view file. But for now, it is in the widgets folder.

The CustomTextField is use a textfield with its decoration.

```swift
struct CustomTextField: View {
    
    let placeholder: String
    
    @Binding var text: String
    
    var body: some View {
        TextField(placeholder, text: $text)
            .padding()
            .background(Color.white.opacity(0.5))
            .cornerRadius(10)
            .autocapitalization(.none)
            .disableAutocorrection(true)
            .shadow(radius: 5)
            
    }
}
```

## CustomSecureField

The companion to the text field, the secure field was refactored out of the login page for readability. But it will soon be placed back into the file as its own struct. There is no need for it to be in another file and folder.

```swift
struct CustomSecureField: View {
    var placeholder: String
    @Binding var text: String
    
    var body: some View {
        SecureField(placeholder, text: $text)
            .padding()
            .background(Color.white.opacity(0.5))
            .cornerRadius(10)
            .shadow(radius: 5)
    }
}
```

## LoginButton

The login button is another refaction, but this button is used in the Start View. Again this does not need to be separated, but is is. Future improvements will see the login button moved back to the Start View. 

the view requests a title (name), width, height, font, and color of the button. The button returns a view. This is basically the page that it will open - whether that be the register or login page.

```swift
struct LoginButton<Destination: View>: View {
    var name: String
    var width: Double
    var height: Double
    var colour: Color
    var destination: Destination
    var  font: Font
    
    var body: some View {
        
        NavigationLink(destination: destination){
            ZStack{
                RoundedRectangle(cornerRadius: 15)
                    .frame(width: width, height: height)
                    .foregroundStyle(colour)
                Text(name)
                    .foregroundStyle(Color.white)
                    .font(font)
            }
        }
    }
}
```