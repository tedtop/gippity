import SwiftUI
import WebKit

struct ChatGPT_MenuView: View {
    @AppStorage("webViewHeight") var webViewHeight: Double = 650
    @AppStorage("webViewWidth") var webViewWidth: Double = 480

    var body: some View {
        ZStack(alignment: .topTrailing) {
            WebView(urlString: AppConfig.Constants.chatgpt_url)
                .frame(width: webViewWidth, height: webViewHeight)

            Menu {
                Button("Settings") {
                    NSApp.sendAction(Selector(("showSettingsWindow:")), to: nil, from: nil)
                    for window in NSApplication.shared.windows {
                        window.level = .popUpMenu
                    }
                }

                Button("Quit") { exit(0) }
            } label: {
                Text("Menu")
                    .foregroundColor(.white.opacity(0.85))
                    .font(.system(size: 14.5))
            }
            .menuStyle(.borderlessButton)
            .menuIndicator(.hidden)
            .offset(x: -60, y: 15)
            .fixedSize()
        }
    }
}

struct WebView: NSViewRepresentable {
    let urlString: String

    func makeNSView(context: Context) -> WKWebView {
        let webView = WKWebView()
        webView.navigationDelegate = context.coordinator
        return webView
    }

    func updateNSView(_ nsView: WKWebView, context: Context) {
        if let url = URL(string: urlString) {
            let request = URLRequest(url: url)
            nsView.load(request)
        }
    }
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
            print("WebView failed to load: \(error.localizedDescription)")
        }
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, WKNavigationDelegate {
        var parent: WebView

        init(_ parent: WebView) {
            self.parent = parent
        }
    }
}


struct ChatGPT_MenuView_Previews: PreviewProvider {
    static var previews: some View {
        ChatGPT_MenuView()
    }
}

