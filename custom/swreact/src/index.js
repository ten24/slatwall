import React from 'react'
import ReactDOM from 'react-dom'
import reportWebVitals from './reportWebVitals'
import './i18n'
import '@slatwall/slatwallassetlibrary/dist/app.bundle.css'
import '@slatwall/slatwallassetlibrary/dist/app.bundle.js'
import { Provider } from 'react-redux'
import store from './createStore'
import App from './App'

ReactDOM.render(
  // <React.StrictMode>
  <Provider store={store}>
    <App />
  </Provider>,
  // </React.StrictMode>
  document.getElementById('app')
)

// If you want to start measuring performance in your app, pass a function
// to log results (for example: reportWebVitals(console.log))
// or send to an analytics endpoint. Learn more: https://bit.ly/CRA-vitals
reportWebVitals()
