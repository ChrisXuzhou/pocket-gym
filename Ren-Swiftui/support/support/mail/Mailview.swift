
import MessageUI
import SwiftUI
import UIKit

struct Mailfacadeview: View {
    @Binding var supportEmail: SupportEmail
    let callback: MailViewCallback

    var body: some View {
        ZStack {
            if MFMailComposeViewController.canSendMail() {
                MailView(supportEmail: $supportEmail, callback: callback)
            } else {
                VStack(spacing: 50) {
                    SPACE
                    
                    HStack {
                        LocaleText("mailnotsupport", usefirstuppercase: false)
                            .font(.system(size: DEFINE_FONT_SIZE).bold().italic())
                            .foregroundColor(NORMAL_GRAY_COLOR)
                    }
                    .foregroundColor(NORMAL_RED_COLOR)

                    LocaleText("mailnotsupportdesc", usefirstuppercase: false)
                        .font(.system(size: DEFINE_FONT_SMALL_SIZE))
                        .foregroundColor(NORMAL_LIGHTER_COLOR)

                    SPACE
                }
            }
        }
    }
}

typealias MailViewCallback = ((Result<MFMailComposeResult, Error>) -> Void)?

struct MailView: UIViewControllerRepresentable {
    @Environment(\.presentationMode) var presentation
    @Binding var supportEmail: SupportEmail
    let callback: MailViewCallback

    class Coordinator: NSObject, MFMailComposeViewControllerDelegate {
        @Binding var presentation: PresentationMode
        @Binding var data: SupportEmail
        let callback: MailViewCallback

        init(presentation: Binding<PresentationMode>,
             data: Binding<SupportEmail>,
             callback: MailViewCallback) {
            _presentation = presentation
            _data = data
            self.callback = callback
        }

        @objc(mailComposeController:didFinishWithResult:error:)
        func mailComposeController(_ controller: MFMailComposeViewController,
                                   didFinishWith result: MFMailComposeResult,
                                   error: Error?) {
            if let error = error {
                callback?(.failure(error))
            } else {
                callback?(.success(result))
            }
            $presentation.wrappedValue.dismiss()
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(presentation: presentation, data: $supportEmail, callback: callback)
    }

    func makeUIViewController(context: UIViewControllerRepresentableContext<MailView>) -> MFMailComposeViewController {
        if MFMailComposeViewController.canSendMail() {
            let mvc = MFMailComposeViewController()
            mvc.mailComposeDelegate = context.coordinator
            mvc.setSubject(supportEmail.subject)
            mvc.setToRecipients([supportEmail.toAddress])
            mvc.setMessageBody(supportEmail.body, isHTML: false)

            mvc.accessibilityElementDidLoseFocus()
            return mvc
        } else {
            return MFMailComposeViewController()
        }
    }

    func updateUIViewController(_ uiViewController: MFMailComposeViewController,
                                context: UIViewControllerRepresentableContext<MailView>) {
    }

    static var canSendMail: Bool {
        MFMailComposeViewController.canSendMail()
    }
}
