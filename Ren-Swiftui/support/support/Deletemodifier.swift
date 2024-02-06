//
//  Delete.swift
//  Ren-Swiftui
//
//  Created by betterchris on 2022/8/30.
//

import SwiftUI

struct Deletemodifier: ViewModifier {
    let action: () -> Void

    @State var offset: CGSize = .zero
    @State var initialOffset: CGSize = .zero
    @State var contentWidth: CGFloat = 0.0
    @State var willDeleteIfReleased = false

    func body(content: Content) -> some View {
        ZStack {
            content
                .background(
                    GeometryReader { geometry in
                        ZStack {
                            Rectangle()
                                .foregroundColor(.red)

                            if offset.width < -20 {
                                Image(systemName: "trash")
                                    .foregroundColor(.white)
                                    .font(.system(size: DEFINE_FONT_SMALL_SIZE).bold())
                                    .layoutPriority(-1)
                            }
                            
                        }
                        .offset(x: geometry.size.width)
                        .frame(width: -offset.width)
                        .onAppear {
                            contentWidth = geometry.size.width
                        }
                        .onTapGesture {
                            delete()
                        }
                    }
                    
                )
                .offset(x: offset.width, y: 0)
                .gesture(
                    DragGesture()
                        .onChanged { gesture in
                            if gesture.translation.width + initialOffset.width <= 0 {
                                self.offset.width = gesture.translation.width + initialOffset.width
                            }
                            if self.offset.width < -deletionDistance && !willDeleteIfReleased {
                                hapticFeedback()
                                willDeleteIfReleased.toggle()
                            } else if offset.width > -deletionDistance && willDeleteIfReleased {
                                hapticFeedback()
                                willDeleteIfReleased.toggle()
                            }
                        }
                        .onEnded { _ in
                            if offset.width < -deletionDistance {
                                delete()
                            } else if offset.width < -halfDeletionDistance {
                                offset.width = -tappableDeletionWidth
                                initialOffset.width = -tappableDeletionWidth
                            } else {
                                offset = .zero
                                initialOffset = .zero
                            }
                        }
                )
                .animation(.interactiveSpring())
        }
    }

    private func delete() {
        offset.width = -contentWidth
        action()
    }

    private func hapticFeedback() {
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
    }

    // MARK: Constants

    let deletionDistance = CGFloat(200)
    let halfDeletionDistance = CGFloat(50)
    let tappableDeletionWidth = CGFloat(100)
}

extension View {
    func onDelete(perform action: @escaping () -> Void) -> some View {
        modifier(Deletemodifier(action: action))
    }
}
