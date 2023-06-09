//
//  ChartSwiftUIView.swift
//  BarugahDrip2.0
//
//  Created by Eskay Yap on 26/5/2023.
//

import SwiftUI
import Charts

struct WearCountStruc: Identifiable {
    var month: String // month
    var wears: Int // number of wears per month
    var id = UUID() // id of column
}

struct ChartUIView: View {
    
    var data: [WearCountStruc] = [
        .init(month: "Jan", wears: 0),
            .init(month: "Feb", wears: 45732),
            .init(month: "Mar", wears: 58432),
            .init(month: "Apr", wears: 35483),
            .init(month: "May", wears: 45478),
            .init(month: "Jun", wears: 0),
            .init(month: "Jul", wears: 0),
            .init(month: "Aug", wears: 0),
            .init(month: "Sep", wears: 0),
            .init(month: "Oct", wears: 0),
            .init(month: "Nov", wears: 0),
            .init(month: "Dec", wears: 0)
    ] // filler data, that is present if there is no data set
    var body: some View {
        Chart(data) { mediaData in
            BarMark(x: .value("Months", mediaData.month),
                    y: .value("Number of Wears", mediaData.wears))
        }
    }
}

struct ChartUIView_Previews: PreviewProvider {
    static var previews: some View {
        ChartUIView()
    }
}
