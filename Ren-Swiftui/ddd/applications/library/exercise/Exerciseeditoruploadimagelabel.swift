//
//  Exercisevieweditoruploadimagelabel.swift
//  Ren-Swiftui
//
//  Created by betterchris on 2022/6/3.
//

import SwiftUI

struct Exercisevieweditoruploadimagelabel_Previews: PreviewProvider {
    static var previews: some View {
        DisplayedView {
            Exercisevieweditoruploadimagelabel(image: .constant(UIImage(systemName: "plus")))
        }
    }
}

struct Exercisevieweditoruploadimagelabel: View {
    @EnvironmentObject var preference: PreferenceDefinition

    @Binding var image: UIImage?
    @State private var shouldPresentImagePicker = false
    @State private var shouldPresentActionScheet = false
    @State private var shouldPresentCamera = false

    var finalimageview: some View {
        ZStack {
            if let _image = image {
                Image(uiImage: _image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 180)
            } else {
                RoundedRectangle(cornerRadius: 10)
                    .foregroundColor(preference.themesecondarycolor)

                Image("photo")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 50)
            }
        }
        .frame(width: 320, height: 180)
        .padding(.top, 20)
    }

    var body: some View {
        VStack {
            Button(action: {
                self.shouldPresentActionScheet = true
            }, label: {
                VStack {
                    finalimageview

                    SPACE

                    LocaleText("uploadimage")
                        .font(
                            .system(size: DEFINE_FONT_SMALLER_SIZE)
                                .bold()
                        )
                        .foregroundColor(NORMAL_LIGHTER_COLOR.opacity(0.7))
                        .padding(.vertical)
                }
                .frame(height: 250)
            })
                .padding(.horizontal)
                .sheet(isPresented: $shouldPresentImagePicker) {
                    SUImagePickerView(sourceType: self.shouldPresentCamera ? .camera : .photoLibrary, image: self.$image, isPresented: self.$shouldPresentImagePicker)
                }.actionSheet(isPresented: $shouldPresentActionScheet) { () -> ActionSheet in
                    ActionSheet(title: Text("Choose mode"), message: Text("Please choose your preferred mode to set your profile image"), buttons: [ActionSheet.Button.default(Text("Camera"), action: {
                        self.shouldPresentImagePicker = true
                        self.shouldPresentCamera = true
                    }), ActionSheet.Button.default(Text("Photo Library"), action: {
                        self.shouldPresentImagePicker = true
                        self.shouldPresentCamera = false
                    }), ActionSheet.Button.cancel()])
                }
        }
    }
}
