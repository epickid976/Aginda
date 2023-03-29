// Kevin Li - 4:30 PM - 6/13/20

import SwiftUI

struct EventCell: View {
    
    //let event: Event

    var body: some View {
        HStack {
            tagView

            VStack(alignment: .leading) {
//                locationName
//                visitDuration
            }

            Spacer()
        }
        .frame(height: EventPreviewConstants.cellHeight)
        .padding(.vertical, EventPreviewConstants.cellPadding)
    }

}

private extension EventCell {

    var tagView: some View {
        RoundedRectangle(cornerRadius: 8)
            //.fill(event.tagColor)
            .frame(width: 5, height: 30)
    }


}

