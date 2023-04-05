// This is the first file that ReactNative will run when it starts up.
// If you use Expo (`yarn expo:start`), the entry point is ./App.js instead.
// Both do essentially the same thing.

import App from "./app/app.tsx"
import React from "react"
import { AppRegistry } from "react-native"
import RNBootSplash from "react-native-bootsplash"
import { Provider } from "react-redux"
import { store } from "./app/store"

function IgniteApp() {
  return <Provider store={store}>
    <App hideSplashScreen={RNBootSplash.hide} />
  </Provider>
}

AppRegistry.registerComponent("RNPlayground", () => IgniteApp)
export default App
