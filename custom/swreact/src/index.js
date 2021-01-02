import React from 'react'
import ReactDOM from 'react-dom'
import reportWebVitals from './reportWebVitals'
import './i18n'
import '@slatwall/slatwallassetlibrary/dist/app.bundle.css'
import '@slatwall/slatwallassetlibrary/dist/app.bundle.js'
import { Home } from './pages'
import { Provider } from 'react-redux'
import store from './createStore'

ReactDOM.render(
  // <React.StrictMode>
  <Provider store={store}>
    <Home
      homeMainBanner={document
        .getElementById('reactHome')
        .getAttribute('data-homeMainBanner')}
      featuredSlider={document
        .getElementById('reactHome')
        .getAttribute('data-featuredSlider')}
      homeContent={document
        .getElementById('reactHome')
        .getAttribute('data-homeContent')}
      homeBrand={document
        .getElementById('reactHome')
        .getAttribute('data-homeBrand')}
      shopBy={document.getElementById('reactHome').getAttribute('data-shopBy')}
    />
  </Provider>,
  // </React.StrictMode>
  document.getElementById('reactHome')
)

// If you want to start measuring performance in your app, pass a function
// to log results (for example: reportWebVitals(console.log))
// or send to an analytics endpoint. Learn more: https://bit.ly/CRA-vitals
reportWebVitals()
