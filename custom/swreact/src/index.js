import React from 'react'
import ReactDOM from 'react-dom'
// import reportWebVitals from './reportWebVitals'
import { BrowserRouter as Router } from 'react-router-dom'

import './i18n'
import { Provider } from 'react-redux'
import store from './createStore'
import App from './App'
import './assets/theme'
import TagManager from 'react-gtm-module'
import devData from './preload'

TagManager.initialize({
  gtmId: devData.analytics.tagManager.gtmId,
})

ReactDOM.render(
  <Provider store={store}>
    <Router>
      <App />
    </Router>
  </Provider>,
  document.getElementById('app')
)

// If you want to start measuring performance in your app, pass a function
// to log results (for example: reportWebVitals(console.log))
// or send to an analytics endpoint. Learn more: https://bit.ly/CRA-vitals
// reportWebVitals(console.log)
