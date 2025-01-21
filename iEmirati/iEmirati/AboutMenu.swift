//
//  AboutMenu.swift
//  iEmirati
//
//  Created by TY on 10/17/24.
//

import SwiftUI
import UIKit
import WebKit

struct WebView: UIViewRepresentable {
    let url: URL

    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        return webView
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {
        let request = URLRequest(url: url)
        uiView.load(request)
    }
}

struct AboutMenu: View {
    @State private var appVersion: String = ""
    var body: some View {
        NavigationStack{
            Image("Logo")
                .resizable()
                .frame(width: 250, height: 250)
            Text("iEmirati")
                .font(.system(size: 40, weight: .bold))

            Text("Version: \(appVersion)")
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(Color(.secondaryLabel))
            Text("Built with Xcode")
                .font(.system(size: 20, weight: .light))
                .foregroundColor(Color(.secondaryLabel))
                .navigationTitle("About")
                .onAppear{
                    appVersion = getAppVersion()
                        
                }
            Form {
                Section(header: Text("More")) {
                    NavigationLink(destination: CreditsView()) {
                        Text("Credits")
                    }
                    NavigationLink(destination: GitHubLink()) {
                        Text("GitHub Repo")
                    }
                    NavigationLink(destination: AboutView()) {
                        Text("What's this..?")
                    }
                }
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
struct GitHubLink: View {
    let url = URL(string: "https://www.github.com/tyandco/iEmirati")!

    var body: some View {
        VStack {
            WebView(url: url)

            Button("Open in Safari") {
                openInSafari(url: url)
            }
            .padding()
            .foregroundColor(.white)
            .background(Color.blue)
            .cornerRadius(30)
        }
    }

    private func openInSafari(url: URL) {
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        }
    }
}
    
struct CreditsView: View {
    var body: some View {
        ScrollView{
            VStack {
                Text("App Dev:")
                    .font(.largeTitle)
                    .padding(.top, 20)
                HStack {
                    //me
                    Image("typfp")
                        .resizable()
                        .frame(width: 150, height: 150)
                        .clipShape(Circle())
                    VStack{
                        Text("Yousef Alkhemeiri")
                            .font(.headline)
                            .fontWeight(.bold)
                            .padding()
                        Text("also known as tyandco on GitHub")
                            .foregroundStyle(.secondary)
                            .font(.caption)
                            .multilineTextAlignment(.center)
                            .padding()
                    }
                }
                Text("Teammates/Contributors:")
                    .font(.largeTitle)
                    .padding(.top, 20)
                VStack{
                    HStack {
                        //mayed
                        VStack{
                            Text("Mayed AlKaabi")
                                .font(.headline)
                                .fontWeight(.bold)
                                .padding()
                            Text("also known as MayDreemurr on GitHub")
                                .foregroundStyle(.secondary)
                                .font(.caption)
                                .multilineTextAlignment(.center)
                                .padding()
                        }
                        Image("mayypfp")
                            .resizable()
                            .frame(width: 150, height: 150)
                            .clipShape(Circle())
                    }
                    HStack {
                        //saeed
                        Image("saeedpfp")
                            .resizable()
                            .frame(width: 150, height: 150)
                            .clipShape(Circle())
                        VStack{
                            Text("Saeed Yasser")
                                .font(.headline)
                                .fontWeight(.bold)
                                .padding()
                            Text("also known as S3eedMV1 on GitHub")
                                .foregroundStyle(.secondary)
                                .multilineTextAlignment(.center)
                                .font(.caption)
                                .padding()
                        }
                    }
                    HStack {
                        //khamis
                        VStack{
                            Text("Khamis Matter")
                                .font(.headline)
                                .fontWeight(.bold)
                                .padding()
                            Text("also known as (insert username here) on GitHub")
                                .foregroundStyle(.secondary)
                                .multilineTextAlignment(.center)
                                .font(.caption)
                                .padding()
                        }
                        Image("test")
                            .resizable()
                            .frame(width: 150, height: 150)
                            .clipShape(Circle())
                    }
                }
                
                Text("Special thanks to:")
                    .font(.title)
                    .fontWeight(.bold)
                    .padding(.top, 10)
                
                VStack(alignment: .center, spacing: 5) {
                    Text("My Teachers")
                        .font(.headline)
                        .fontWeight(.bold)
                        .padding()
                    
                    Text("for encouraging me to make this app")
                        .foregroundStyle(.secondary)
                        .font(.caption)
                        .padding()
                    
                    Text("My Friends")
                        .font(.headline)
                        .fontWeight(.bold)
                        .padding()
                    
                    Text("for helping me with their wonderful ideas")
                        .foregroundStyle(.secondary)
                        .font(.caption)
                        .padding()
                    
                    Text("My Family")
                        .font(.headline)
                        .fontWeight(.bold)
                        .padding()
                    
                    Text("for supporting my work")
                        .foregroundStyle(.secondary)
                        .font(.caption)
                        .padding()
                    
                    Text("You!")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .padding()
                    
                    Text("for testing the app")
                        .foregroundStyle(.secondary)
                        .font(.caption)
                        .padding()
                    Image("scribblethanks")
                        .resizable()
                        .scaledToFit()
                }
                .padding()
                
                Spacer()
                    .padding()
            }
        }
        .padding()
    }
}
struct AboutView: View {
    var body: some View {
   ScrollView {
            VStack {
                Image("iosdesign")
                    .resizable()
                    .scaledToFit()
                Text("This app was made for the iOS Design Challenge 2024-2025. The theme was \"UAE National Identity\".")
                    .font(.headline)
                    .padding()
                Text("We were told to create an app prototype via either Keynote or Figma, that captures the essence of UAE National Identity, focusing on Heritage and Values - the core of what it means to be Emirati and part of the UAE.")
                    .font(.headline)
                    .padding()
                Text("But instead of using these choices, I decided to just straight up program it, although it's my first time joining the challenge.")
                    .font(.headline)
                    .padding()
                Text("May the best prototype win!")
                    .font(.title2)
                    .fontWeight(.bold)
                    .padding()
            }
        }
   .navigationTitle("The Story")
   .padding()
    }
}

#Preview {
    AboutMenu()
}
