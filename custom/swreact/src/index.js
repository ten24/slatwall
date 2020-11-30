import React from 'react'
import ReactDOM from 'react-dom'
import reportWebVitals from './reportWebVitals'
import { Footer, Header } from './components'
import './i18n'
import '@slatwall/slatwallassetlibrary/dist/app.bundle.css'
import '@slatwall/slatwallassetlibrary/dist/app.bundle.js'
import { Home } from './pages'

ReactDOM.render(
  <React.StrictMode>
    <Header
      themePath={document
        .getElementById('reactHeader')
        .getAttribute('data-themePath')}
      mainNavigation={document
        .getElementById('reactHeader')
        .getAttribute('data-mainNavigation')}
      productCategories={document
        .getElementById('reactHeader')
        .getAttribute('data-productCategories')}
    />
  </React.StrictMode>,
  document.getElementById('reactHeader')
)

ReactDOM.render(
  <React.StrictMode>
    <Home
      homeBanner={document
        .getElementById('reactHome')
        .getAttribute('data-homeBanner')}
      homeContent={document
        .getElementById('reactHome')
        .getAttribute('data-homeContent')}
      homeBrand={document
        .getElementById('reactHome')
        .getAttribute('data-homeBrand')}
      shopBy={document.getElementById('reactHome').getAttribute('data-shopBy')}
    />
  </React.StrictMode>,
  document.getElementById('reactHome')
)
ReactDOM.render(
  <React.StrictMode>
    <Footer
      isContact={document
        .getElementById('reactFooter')
        .getAttribute('data-isContact')}
      contactUs={document
        .getElementById('reactFooter')
        .getAttribute('data-contactUs')}
      getInTouch={document
        .getElementById('reactFooter')
        .getAttribute('data-getInTouch')}
      siteLinks={document
        .getElementById('reactFooter')
        .getAttribute('data-siteLinks')}
      stayInformed={document
        .getElementById('reactFooter')
        .getAttribute('data-stayInformed')}
      copywriteDate={document
        .getElementById('reactFooter')
        .getAttribute('data-copywriteDate')}
    />
  </React.StrictMode>,
  document.getElementById('reactFooter')
)

// If you want to start measuring performance in your app, pass a function
// to log results (for example: reportWebVitals(console.log))
// or send to an analytics endpoint. Learn more: https://bit.ly/CRA-vitals
reportWebVitals()
