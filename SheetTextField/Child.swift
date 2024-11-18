import ComposableArchitecture
import SwiftUI

@Reducer
struct Child {
  @ObservableState
  struct State {
    var value = ""
  }
  enum Action: BindableAction {
    case binding(BindingAction<State>)
    case cancelButtonTapped
  }
  
  @Dependency(\.dismiss) var dismiss
  
  var body: some ReducerOf<Self> {
    BindingReducer()
    Reduce { state, action in
      switch action {
      case .cancelButtonTapped:
        return .run { [dismiss] send in
          await dismiss()
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
    TextField(
      "Child",
      text: Binding(
        get: { store.value },
        set: { store.send(.binding(.set(\.value, $0))) }
      )
    )
    .textFieldStyle(.roundedBorder)
    .frame(maxWidth: 200)
    .toolbar {
      Button("Cancel") {
        store.send(.cancelButtonTapped)
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
