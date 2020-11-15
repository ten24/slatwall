import React from "react"
import ReactDOM from "react-dom"
import "./index.css"
import { App, SWSlider } from "./components/index"
import reportWebVitals from "./reportWebVitals"
import "./styles/slatwall.scss"
import { Provider } from "react-redux"
import { store, persistor } from "./store"
import { PersistGate } from "redux-persist/integration/react"
const isMulti = true

if (isMulti) {
  ReactDOM.render(
    <React.StrictMode>
      <Provider store={store}>
        <PersistGate loading={null} persistor={persistor}>
          <div>
            <h1>Home 1 </h1>
            <SWSlider />
          </div>
        </PersistGate>
      </Provider>
    </React.StrictMode>,
    document.getElementById("multi1")
  )

  ReactDOM.render(
    <React.StrictMode>
      <Provider store={store}>
        <PersistGate loading={null} persistor={persistor}>
          <div>
            <h1>Home 2 </h1>
            <SWSlider />
          </div>
        </PersistGate>
      </Provider>
    </React.StrictMode>,
    document.getElementById("multi2")
  )
} else {
  ReactDOM.render(
    <React.StrictMode>
      <Provider store={store}>
        <PersistGate loading={null} persistor={persistor}>
          <App />
        </PersistGate>
      </Provider>
    </React.StrictMode>,
    document.getElementById("root")
  )
}

// If you want to start measuring performance in your app, pass a function
// to log results (for example: reportWebVitals(console.log))
// or send to an analytics endpoint. Learn more: https://bit.ly/CRA-vitals
reportWebVitals()
