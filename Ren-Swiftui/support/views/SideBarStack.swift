//
//  SideBarStack.swift
//  Ren-Swiftui
//
//  Created by betterchris on 2022/7/1.
//

import SwiftUI

extension View {
    func leftslider<Content: View>(isPresented: Binding<Bool>,
                                   @ViewBuilder content: @escaping () -> Content) -> some View {
        LeftsliderviewWrapper(isPresented: isPresented,
                              content: content,
                              parent: self
        )
    }
}

struct LeftsliderviewWrapper<Parent: View, Content: View>: View {
    @EnvironmentObject var sidebarmanager: Sidebarmanager

    @Binding var isPresented: Bool
    let content: () -> Content
    let parent: Parent

    var body: some View {
        parent
            .onChange(of: isPresented,
                      perform: {
                          _ in
                          updateContent()
                      })
    }

    private func updateContent() {
        sidebarmanager.updateLeftslider(
            isPresented: isPresented,
            content: content,
            onDismiss: {
                withAnimation {
                    self.isPresented = false
                }
            }
        )
    }
}

extension View {
    func eraseToAnyView() -> AnyView {
        AnyView(self)
    }
}

class Sidebarmanager: ObservableObject {
    @Published var isPresented: Bool = false {
        didSet {
            if !isPresented {
                DispatchQueue.main.async { [weak self] in

                    if let _onDismiss = self?.onDismiss {
                        _onDismiss()
                    }

                    self?.content = EmptyView().eraseToAnyView()
                    self?.onDismiss = nil
                }
            }
        }
    }

    @Published var content: AnyView
    var slideAnimation = SlideAnimation()

    private(set) var onDismiss: (() -> Void)?

    init() {
        content = EmptyView().eraseToAnyView()
    }

    func updateLeftslider<T>(isPresented: Bool,
                             content: () -> T,
                             onDismiss: @escaping (() -> Void)) where T: View {
        self.content = AnyView(content())
        self.onDismiss = onDismiss
        withAnimation(isPresented ? slideAnimation.slideIn : slideAnimation.slideOut) {
            self.isPresented = isPresented
        }
    }
}

public struct SlideAnimation {
    var slideIn: Animation
    var slideOut: Animation

    private(set) var defaultSlideAnimation: Animation = {
        .interpolatingSpring(stiffness: 300.0, damping: 30.0, initialVelocity: 10.0)
    }()

    public init(slideIn: Animation? = nil, slideOut: Animation? = nil) {
        self.slideIn = slideIn ?? defaultSlideAnimation
        self.slideOut = slideOut ?? defaultSlideAnimation
    }
}

let SIDEBAR_WIDTH: CGFloat = UIScreen.width * 0.7

struct Sidebar: ViewModifier {
    @EnvironmentObject var manager: Sidebarmanager

    func body(content: Content) -> some View {
        ZStack(alignment: .leading) {
            content

            if manager.isPresented {
                Color.black
                    .ignoresSafeArea()
                    .opacity(manager.isPresented ? 0.3 : 0)
                    .onTapGesture {
                        manager.isPresented = false
                    }
            } else {
                Color.clear
                    .opacity(manager.isPresented ? 0 : 0)
                    .onTapGesture {
                        manager.isPresented = false
                    }
            }

            leftslide()
                .frame(width: SIDEBAR_WIDTH, alignment: .center)
                .offset(x: manager.isPresented ? 0 : -1 * SIDEBAR_WIDTH, y: 0)
                .animation(Animation.easeInOut.speed(2))
        }
    }

    private func leftslide() -> some View {
        return manager.content
    }
}

extension View {
    func attachLeftslideToRoot() -> some View {
        let manager: Sidebarmanager = Sidebarmanager()
        return modifier(Sidebar())
            .environmentObject(manager)
    }
}

struct SideBarStack<SidebarContent: View, Content: View>: View {
    let sidebarContent: SidebarContent
    let mainContent: Content
    let sidebarWidth: CGFloat
    @Binding var showSidebar: Bool

    init(sidebarWidth: CGFloat, showSidebar: Binding<Bool>, @ViewBuilder sidebar: () -> SidebarContent, @ViewBuilder content: () -> Content) {
        self.sidebarWidth = sidebarWidth
        _showSidebar = showSidebar
        sidebarContent = sidebar()
        mainContent = content()
    }

    var body: some View {
        ZStack(alignment: .leading) {
            mainContent

            if showSidebar {
                Color.black
                    .ignoresSafeArea()
                    .opacity(showSidebar ? 0.3 : 0)
                    .onTapGesture {
                        self.showSidebar = false
                    }
            } else {
                Color.clear
                    .opacity(showSidebar ? 0 : 0)
                    .onTapGesture {
                        self.showSidebar = false
                    }
            }

            sidebarContent
                .frame(width: sidebarWidth, alignment: .center)
                .offset(x: showSidebar ? 0 : -1 * sidebarWidth, y: 0)
                .animation(Animation.easeInOut.speed(2))
        }
    }
}
