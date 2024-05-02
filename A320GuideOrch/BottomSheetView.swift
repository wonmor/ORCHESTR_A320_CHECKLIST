import SwiftUI

fileprivate enum Constants {
    static let radius: CGFloat = 16
    static let indicatorHeight: CGFloat = 6
    static let indicatorWidth: CGFloat = 60
    static let snapRatio: CGFloat = 0.25
    static let minHeightRatio: CGFloat = 0.3
}


public enum BottomSheetDisplayType {
  case fullScreen
  case halfScreen
  case none
}

struct BottomSheetAdvanceView<Content: View>: View {
    @Binding var displayType: BottomSheetDisplayType

    let maxHeight: CGFloat
    let minHeight: CGFloat
    let content: Content

    @GestureState private var translation: CGFloat = 0
  //MARK:- Offset from top edge
    private var offset: CGFloat {
      switch displayType {
      case .fullScreen :
        return 0
      case .halfScreen :
        return maxHeight * 0.40
      case .none :
        return maxHeight - minHeight
      }
      
    }

    private var indicator: some View {
        RoundedRectangle(cornerRadius: Constants.radius)
            .fill(Color.secondary)
            .frame(
                width: Constants.indicatorWidth,
                height: Constants.indicatorHeight
        ).onTapGesture {
//            self.isOpen.toggle()
        }
    }

    init(displayType: Binding<BottomSheetDisplayType>, maxHeight: CGFloat, @ViewBuilder content: () -> Content) {
        self.minHeight = 70
        self.maxHeight = maxHeight
        self.content = content()
        self._displayType = displayType
    }

    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                self.indicator.padding()
                self.content
            }
            .frame(width: geometry.size.width, height: self.maxHeight, alignment: .top)
            .background(Color(.secondarySystemBackground))
            .cornerRadius(Constants.radius)
            .frame(height: geometry.size.height, alignment: .bottom)
            .offset(y: max(self.offset + self.translation, 0))
            .animation(.interactiveSpring())
            .gesture(
                DragGesture().updating(self.$translation) { value, state, _ in
                    state = value.translation.height
                }.onEnded { value in
                  let snapDistanceFullScreen = self.maxHeight * 0.35
                  let snapDistanceHalfScreen =  self.maxHeight * 0.85
                  if value.location.y <= snapDistanceFullScreen {
                    self.displayType = .fullScreen
                  } else if value.location.y > snapDistanceFullScreen  &&  value.location.y <= snapDistanceHalfScreen{
                    self.displayType = .halfScreen
                  }else {
                    self.displayType = .none
                  }
                }
            )
        }
    }
}

struct BottomSheetView_Previews: PreviewProvider {
    @State static var type = BottomSheetDisplayType.halfScreen
    
    static var previews: some View {
        BottomSheetAdvanceView(displayType: $type, maxHeight: 600) {
            Rectangle().fill(Color.black)
        }.edgesIgnoringSafeArea(.all)
            .preferredColorScheme(.dark)
    }
}
