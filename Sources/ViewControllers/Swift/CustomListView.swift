//
//  CustomListViewController.swift
//  Obj-C-Demo
//
//  Created by ricolwang on 2026/1/12.
//

import SwiftUI

struct ListRow: Hashable {
    static func == (lhs: ListRow, rhs: ListRow) -> Bool {
        lhs.title == rhs.title
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(title)
    }
    
    let title: String
    let block: () -> Void
}

struct CustomListView: View {
    @State var rows = [ListRow(title: "Case 1", block: { print("case 1") }), ListRow(title: "Case 2", block: { print("case 2") })]
    @State private var result: String = ""
    var title: String = "List View"
    var navigationView: Bool = false

    var body: some View {
        if navigationView {
            NavigationView {
                getBody()
            }
        } else {
            getBody()
        }
    }

    @ViewBuilder
    func getBody() -> some View {
        ScrollView {
            VStack {
                ForEach(rows, id: \.self) { row in
                    VStack(spacing: 0) {
                        HStack {
                            Text(row.title).font(.system(size: 13)).onTapGesture {
                                row.block()
                            }.padding(.vertical, 8).padding(.horizontal, 16)
                            Spacer()
                        }
                        Spacer(minLength: 7)
                        Color.gray.opacity(0.3).frame(height: 1)
                    }
                }
            }
            Text("Result: \(result)").font(.system(size: 13)).padding(.top, 8)
        }.navigationTitle(title).navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    CustomListView()
}
