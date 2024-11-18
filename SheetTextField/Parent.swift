import ComposableArchitecture
import SwiftUI

@Reducer
struct Parent {
  @Reducer
  enum Destination {
    case child(Child)
  }

  @ObservableState
  struct State {
    @Presents var destination: Destination.State?
  }
  enum Action: ViewAction {
    case destination(PresentationAction<Destination.Action>)
    case view(View)
    
    enum View {
      case showChildButtonTapped
    }
  }
  var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case .view(let viewAction):
        switch viewAction {
        case .showChildButtonTapped:
          state.destination = .child(Child.State())
          return .none
        }
        
      case .destination:
        return .none
      }
    }
    .ifLet(\.$destination, action: \.destination)
  }
}

@ViewAction(for: Parent.self)
struct ParentView: View {
  @Bindable var store: StoreOf<Parent>
  
  var body: some View {
    Button("Show Child") {
      send(.showChildButtonTapped)
    }
    .sheet(item: $store.scope(state: \.destination?.child, action: \.destination.child)) {
      ChildView(store: $0)
    }
  }
}

#Preview {
  ParentView(
    store: Store(
      initialState: Parent.State()
    ) {
      Parent()
    }
  )
}
