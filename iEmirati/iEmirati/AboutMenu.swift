//
//  AboutMenu.swift
//  iEmirati
//
//  Created by TY on 10/17/24.
//

import SwiftUI
import UIKit
struct AboutMenu: View {
    @State private var appVersion: String = ""
    var body: some View {
        NavigationStack{
            Image("Logo")
                .resizable()
                .frame(width: 250, height: 250)
            Text("iEmirati")
                .font(.system(size: 40, weight: .bold))
                .padding()
            Text("Version: \(appVersion)")
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(Color(.secondaryLabel))
                .padding()
            Text("Built with Xcode")
                .font(.system(size: 20, weight: .light))
                .foregroundColor(Color(.secondaryLabel))
                .navigationTitle("About")
                .onAppear{
                    appVersion = getAppVersion()
                        
                }
        }
    }
}
func getAppVersion() -> String {
        if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String,
           let build = Bundle.main.infoDictionary?["CFBundleVersion"] as? String {
            return "\(version) (\(build))"
        }
        return "Unknown version"
    }

class SecondViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        let secondSwiftUIView = UIHostingController(rootView: AboutMenu())
                
                // Add it as a child view controller
                addChild(secondSwiftUIView)
                
                // Add the SwiftUI view to the view controller's view hierarchy
                view.addSubview(secondSwiftUIView.view)
                
                // Ensure it takes up the full view with constraints
                secondSwiftUIView.view.translatesAutoresizingMaskIntoConstraints = false
                NSLayoutConstraint.activate([
                    secondSwiftUIView.view.topAnchor.constraint(equalTo: view.topAnchor),
                    secondSwiftUIView.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
                    secondSwiftUIView.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                    secondSwiftUIView.view.trailingAnchor.constraint(equalTo: view.trailingAnchor)
                ])
                
                // Notify the child view controller that the move is complete
                secondSwiftUIView.didMove(toParent: self)
            }
    }


#Preview {
    AboutMenu()
}
