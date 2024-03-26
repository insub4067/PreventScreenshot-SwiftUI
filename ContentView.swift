import SwiftUI

struct PreventScreenshotPractice: View {
    
    var body: some View {
        ScrollView {
            LazyVStack(content: {
                ForEach(1...10, id: \.self) { count in
                    Text("Placeholder \(count)")
                        .frame(maxWidth: .infinity)
                        .frame(height: 120)
                        .background(Color.gray.opacity(0.6))
                }
            })
        }
        .preventScreenshot()
    }
}

public struct ScreenshotPreventView<Content: View>: UIViewRepresentable {
    
    let content: () -> Content
    
    public init(@ViewBuilder content: @escaping () -> Content) {
        self.content = content
    }
    
    public func makeUIView(context: Context) -> UIView {
        let secureTextField = UITextField()
        secureTextField.isSecureTextEntry = true
        secureTextField.isUserInteractionEnabled = false
        
        guard let secureView = secureTextField.layer.sublayers?.first?.delegate as? UIView else {
            return UIView()
        }
        
        secureView.subviews.forEach { subview in
            subview.removeFromSuperview()
        }
        
        let contentHostingController = UIHostingController(rootView: content())
        contentHostingController.view.backgroundColor = .clear
        contentHostingController.view.translatesAutoresizingMaskIntoConstraints = false
        
        secureView.addSubview(contentHostingController.view)
        NSLayoutConstraint.activate([
            contentHostingController.view.topAnchor.constraint(equalTo: secureView.topAnchor),
            contentHostingController.view.bottomAnchor.constraint(equalTo: secureView.bottomAnchor),
            contentHostingController.view.leadingAnchor.constraint(equalTo: secureView.leadingAnchor),
            contentHostingController.view.trailingAnchor.constraint(equalTo: secureView.trailingAnchor)
        ])
        
        return secureView
    }
    
    public func updateUIView(_ uiView: UIView, context: Context) { }
}


extension View {
    
    @ViewBuilder func preventScreenshot(_ shouldPrevent: Bool = true) -> some View {
        if shouldPrevent {
            ScreenshotPreventView { self }
        } else {
            self
        }
    }
}
