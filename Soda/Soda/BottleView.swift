//
//  BottleView.swift
//  Soda
//
//  Created by Adam on 3/7/23.
//

import SwiftUI

struct BottleView: Shape {
    func path(in rect: CGRect) -> Path {
        let width = rect.width
        let height = rect.height
        let radius = min(width, height) / 2
        let neckHeight = height / 4
        let neckCurveSize = radius / 4
        let bodyCurveSize = radius / 2
        
        var path = Path()
        path.move(to: CGPoint(x: 0, y: height - radius))
        path.addLine(to: CGPoint(x: 0, y: radius))
        path.addArc(center: CGPoint(x: radius, y: radius), radius: radius, startAngle: Angle(degrees: 180), endAngle: Angle(degrees: 180 * 1.5), clockwise: false)
        path.addLine(to: CGPoint(x: width - radius, y: 0))
        path.addArc(center: CGPoint(x: width - radius, y: radius), radius: radius, startAngle: .degrees(180 * 1.5), endAngle: .degrees(0.0), clockwise: false)
        path.addLine(to: CGPoint(x: width, y: height - radius))
        path.addArc(center: CGPoint(x: width - radius, y: height - radius), radius: radius, startAngle: .degrees(0.0), endAngle: .degrees(180 * 1.5), clockwise: false)
//
//        // Add the neck curve
        path.addQuadCurve(to: CGPoint(x: width - neckCurveSize, y: height - neckHeight), control: CGPoint(x: width, y: height - neckCurveSize))
//
//        // Add the neck
        path.addLine(to: CGPoint(x: neckCurveSize, y: height - neckHeight))
        path.addQuadCurve(to: CGPoint(x: 0, y: height - radius), control: CGPoint(x: 0, y: height - neckCurveSize))
//
//        // Add the body curve
        path.addQuadCurve(to: CGPoint(x: radius, y: height - bodyCurveSize), control: CGPoint(x: radius / 2, y: height))
        
        // Close the path
        path.closeSubpath()
        
        return path
    }
}

struct BottleView_Previews: PreviewProvider {
    static var previews: some View {
        BottleView()
            .stroke()
            .frame(width: 250, height: 250)
    }
}
