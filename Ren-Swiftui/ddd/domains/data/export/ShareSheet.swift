//
//  ShareSheet.swift
//  Ren-Swiftui
//
//  Created by betterchris on 2022/10/31.
//

import LinkPresentation
import SwiftUI

struct ShareSheet_Previews: PreviewProvider {
    static var previews: some View {
        DisplayedView {
            VStack {
            }
            // ShareSheet()
        }
    }
}

struct SharesheetSample: View {
    @EnvironmentObject var preference: PreferenceDefinition

    /*
     Button(action: {
         self.uiImage = UIApplication.shared.windows[0].rootViewController?.view!.getImage(rect: self.rect)
         self.showShareSheet.toggle()
     }) {
         Image(systemName: "square.and.arrow.up")
             .resizable()
             .aspectRatio(contentMode: .fit)
             .frame(width: 50, height: 50)
             .padding()
             .background(Color.pink)
             .foregroundColor(Color.white)
             .mask(Circle())
     }.sheet(isPresented: self.$showShareSheet) {
         ShareSheet(photo: self.uiImage!)
     }.padding()
     */

    @StateObject var openswitch = Viewopenswitch()

    var body: some View {
        VStack {
            Button {
                openswitch.value.toggle()
            } label: {
                LocaleText("share")
            }
            /*
             
             .sheet(isPresented: $openswitch.value) {
                 ShareSheet(title: "shared doc", sharedata: Data("shared data content".utf8))
             }
             
             */
        }
    }
}

struct ShareSheet: UIViewControllerRepresentable {
    let title: String
    let sharedata: Data

    func makeUIViewController(context: Context) -> UIActivityViewController {
        let itemSource = ShareActivityItemSource(sharetitle: title, sharedata: sharedata)

        let activityItems: [Any] = [sharedata, title, itemSource]

        let controller = UIActivityViewController(
            activityItems: activityItems,
            applicationActivities: nil)

        return controller
    }

    func updateUIViewController(_ vc: UIActivityViewController, context: Context) {
    }
}

class ShareActivityItemSource: NSObject, UIActivityItemSource {
    var sharetitle: String
    var sharedata: Data
    var linkMetaData = LPLinkMetadata()

    init(sharetitle: String, sharedata: Data) {
        self.sharetitle = sharetitle
        self.sharedata = sharedata
        linkMetaData.title = sharetitle
        super.init()
    }

    func activityViewControllerPlaceholderItem(_ activityViewController: UIActivityViewController) -> Any {
        return UIImage(named: "AppIcon ") as Any
    }

    func activityViewController(_ activityViewController: UIActivityViewController, itemForActivityType activityType: UIActivity.ActivityType?) -> Any? {
        return nil
    }

    func activityViewControllerLinkMetadata(_ activityViewController: UIActivityViewController) -> LPLinkMetadata? {
        return linkMetaData
    }
}

struct RectangleGetter: View {
    @Binding var rect: CGRect

    var body: some View {
        GeometryReader { geometry in
            self.createView(proxy: geometry)
        }
    }

    func createView(proxy: GeometryProxy) -> some View {
        DispatchQueue.main.async {
            self.rect = proxy.frame(in: .global)
        }
        return Rectangle().fill(Color.clear)
    }
}

extension UIView {
    func getImage(rect: CGRect) -> UIImage {
        let renderer = UIGraphicsImageRenderer(bounds: rect)
        return renderer.image { rendererContext in
            layer.render(in: rendererContext.cgContext)
        }
    }
}
