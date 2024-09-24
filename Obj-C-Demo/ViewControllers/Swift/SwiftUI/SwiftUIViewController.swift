//
//  SwiftUIViewController.swift
//  Obj-C-Demo
//
//  Created by ricolwang on 2024/9/24.
//

import Foundation
import SwiftUI

class SwiftUIViewController: ListTableViewController {
    
    @objc func testSwiftUI() {
        let hosting = UIHostingController(rootView: SwiftUIMainView())
        self.navigationController?.pushViewController(hosting, animated: true)
    }
}

struct SwiftUIMainView: View {
    var body: some View {
        List {
            Section("Default") {
                NavigationLink {
                    Text("Show Navigation Bar and back button")
                        .navigationBarVisible()
                        .navigationBarBackButtonHidden(false)
                } label: {
                    Text("Show Navigation Bar and back button")
                }
                
                NavigationLink {
                    Text("Show Navigation Bar and no back button")
                        .navigationBarVisible()
                        .navigationBarBackButtonHidden()
                } label: {
                    Text("Show Navigation Bar and no back button")
                }
                
                NavigationLink {
                    Text("Hide Navigation Bar and no back button")
                        .navigationBarVisible(false)
                        .navigationBarBackButtonHidden()
                } label: {
                    Text("Hide Navigation Bar and no back button")
                }
                
                NavigationLink {
                    Text("Hide Navigation Bar and no back button")
                        .navigationBarVisible(false)
                        .navigationBarBackButtonHidden()
                } label: {
                    Text("Hide Navigation Bar and no back button")
                }
            }
            Section("Customize") {
                NavigationLink {
                    CustomBackButtonView()
                } label: {
                    Text("Show Navigation Bar and back button")
                }
            }
        }.navigationTitle("Swift UI Demo")
    }
}

struct CustomBackButtonView: View {
    @Environment(\.dismiss) var dismiss
    var body: some View {
        Text("Show Navigation Bar and custom back button")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        HStack {
                            Image(systemName: "chevron.backward")
                            Text("Back")
                        }
                    }
                }
            }
            .navigationBarBackButtonHidden()
            .navigationBarVisible()
            .navigationTitle("Custom Back")
    }
}

extension View {
    func navigationBarVisible(_ v: Bool = true) -> some View {
        if #available(iOS 18.0, *) {
            print("navigationBarVisible.toolbarVisibility...")
            return self.toolbarVisibility(v ? .visible : .hidden, for: .navigationBar)
        } else {
            // Fallback on earlier versions
            print("navigationBarVisible.fallback...")
            return self.navigationBarHidden(!v)
        }
    }
    
    func tabBarVisible(_ v: Bool = true, tabbarVC: UITabBarController? = nil) -> some View {
        if #available(iOS 18.0, *) {
            print("tabBarVisible.toolbarVisibility...")
            return self.toolbarVisibility(v ? .visible : .hidden, for: .tabBar)
        } else {
            // Fallback on earlier versions
            print("tabBarVisible.fallback...")
            tabbarVC?.tabBar.isHidden = !v
            return self
        }
    }
}
