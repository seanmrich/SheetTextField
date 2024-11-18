import ComposableArchitecture
import SwiftUI

@Reducer
struct Child {
  @ObservableState
  struct State {
    var value = 0
  }
  enum Action: BindableAction, ViewAction {
    case binding(BindingAction<State>)
    case view(View)
    
    enum View {
      case cancelButtonTapped
      case valueChanged(Int)
    }
  }
  
  @Dependency(\.dismiss) var dismiss
  
  var body: some ReducerOf<Self> {
    BindingReducer()
    Reduce { state, action in
      switch action {
      case .view(let viewAction):
        switch viewAction {
        case .cancelButtonTapped:
          return .run { [dismiss] send in
            await dismiss()
          }
          
        case .valueChanged(let new):
          state.value = new
          return .none
        }
        
      case .binding:
        return .none
      }
    }
  }
}

struct ChildView: View {
  @Bindable var store: StoreOf<Child>
  
  var body: some View {
    NavigationStack {
      TextField(
        "Child",
//        value: $store.valueTop,
        value: Binding(
          get: { store.value },
          set: { store.send(.binding(.set(\.value, $0))) }
//          set: { store.send(.view(.valueChanged($0))) }
        ),
        format: IntegerFormatStyle<Int>.number
      )
      .textFieldStyle(.roundedBorder)
      .keyboardType(.numberPad)
      .frame(maxWidth: 200)
      .toolbar {
        Button("Cancel") {
          store.send(.view(.cancelButtonTapped))
        }
      }
    }
  }
}

#Preview {
  ChildView(
    store: Store(
      initialState: Child.State(),
      reducer: { Child() }
    )
  )
}
