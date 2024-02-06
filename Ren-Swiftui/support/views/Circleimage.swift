import SwiftUI

struct Circleimage: View {
    var image: Image

    var body: some View {
        image
            .resizable()
            .overlay(
                NORMAL_LIGHT_GRAY_COLOR.opacity(0.2)
            )
            .clipShape(Circle())
            .shadow(radius: 0)
            
            
            /*
             
             .background(
                 Circle().foregroundColor(
                     NORMAL_BG_COLOR
                 )
             )
             
             */
    }
}

struct CircleImage_Previews: PreviewProvider {
    static var previews: some View {
        Circleimage(
            image: Image("female_abductors")
        )
        .frame(width: 100, height: 100, alignment: .center)
    }
}
