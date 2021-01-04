import React, { Suspense } from 'react'
import { BrowserRouter as Router, Switch, Route, Link } from 'react-router-dom'
// import Button from '../../components/Button/Button'
const Home = React.lazy(() => import('./pages/Home/Home'))
const MyAccount = React.lazy(() => import('./pages/MyAccount/MyAccount'))
const HookSample = React.lazy(() =>
  import('./components/HookSample/HookSample')
)

const Loading = () => {
  console.log('Loading....')
  return <span>Loading...</span>
}

export default function App() {
  return (
    <Suspense fallback={<Loading />}>
      <Router>
        {/* A <Switch> looks through its children <Route>s and
              renders the first one that matches the current URL. */}
        <Switch>
          <Route path="/MyAccount" component={MyAccount} />
          <Route path="/HookSample" component={HookSample} />
          <Route path="/" render={() => <Home />} />
        </Switch>
      </Router>
    </Suspense>
  )
}
