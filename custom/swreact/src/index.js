import React from 'react'
import ReactDOM from 'react-dom'
// import reportWebVitals from './reportWebVitals'
import { BrowserRouter as Router } from 'react-router-dom'
import { createBrowserHistory } from 'history'

import './i18n'
import { Provider } from 'react-redux'
import store from './createStore'
import App from './App'
import './assets/theme'
import TagManager from 'react-gtm-module'
import devData from './preload'
import * as Sentry from '@sentry/react'
import { Integrations } from '@sentry/tracing'
const history = createBrowserHistory()

if (process.env.NODE_ENV !== 'production') {
  TagManager.initialize({
    gtmId: devData.analytics.tagManager.gtmId,
  })
  Sentry.init({
    dsn: 'https://4e0cbc76bd6f4c38ae1c595180de6eb5@o47339.ingest.sentry.io/5821545',
    release: process.env.REACT_APP_NAME + '@' + process.env.REACT_APP_VERSION,
    integrations: [
      new Integrations.BrowserTracing({
        // Can also use reactRouterV3Instrumentation or reactRouterV4Instrumentation
        routingInstrumentation: Sentry.reactRouterV5Instrumentation(history),
      }),
    ],
    // We recommend adjusting this value in production, or using tracesSampler
    // for finer control
    tracesSampleRate: process.env.REACT_APP_SENTRY_SAMPLE_RATE || 0.5,
  })
}

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
