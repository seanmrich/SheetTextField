import ComposableArchitecture
import SwiftUI

@main
struct SheetTextFieldApp: App {
  let store = Store(
    initialState: Parent.State(),
    reducer: { Parent()._printChanges() }
  )
  var body: some Scene {
    WindowGroup {
      ParentView(store: store)
    }
  }
}
