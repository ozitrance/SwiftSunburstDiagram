//
//  SunburstView.swift
//  SunburstDiagram
//
//  Created by Ludovic Landry on 6/10/19.
//  Copyright © 2019 Ludovic Landry. All rights reserved.
//

import SwiftUI

public struct SunburstView: View {

    @ObjectBinding var sunburst: Sunburst
    
    public init(configuration: SunburstConfiguration) {
        sunburst = configuration.sunburst
    }
    
    public var body: some View {
        let arcs = ZStack {
            configureViews(arcs: sunburst.rootArcs)
            
            // Stop the window shrinking to zero when there is no arcs.
            Spacer()
        }
        .flipsForRightToLeftLayoutDirection(true)
        .padding()
        
        let drawnArcs = arcs.drawingGroup()
        return drawnArcs
    }
    
    private func configureViews(arcs: [Sunburst.Arc], parentArc: Sunburst.Arc? = nil) -> some View {
        return ForEach(arcs) { arc in
            ArcView(arc: arc, configuration: self.sunburst.configuration)
                .tapAction {
                    withAnimation(.fluidSpring()) {
                        print(">>> Tapped arc: \(arc.text)")
                    }
                }
            IfLet(arc.childArcs) { childArcs in
                AnyView(self.configureViews(arcs: childArcs, parentArc: arc))
            }
        }
    }
}
