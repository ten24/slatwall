import React, { Suspense } from 'react'
import { BrowserRouter as Router, Switch, Route, Link } from 'react-router-dom'
// import Button from '../../components/Button/Button'
const Button = React.lazy(() => import('../../components/Button/Button'))
const HookSample = React.lazy(() =>
  import('../../components/HookSample/HookSample')
)

const Loading = () => {
  console.log('Loading....')
  return <span>Loading...</span>
}

export default function Demo() {
  return (
    <Suspense fallback={<Loading></Loading>}>
      <Router>
        <div>
          <nav>
            <ul>
              <li>
                <Link to="/">Button</Link>
              </li>
              <li>
                <Link to="/HookSample">HookSample</Link>
              </li>
              {/* <li>
                <Link to="/about">About</Link>
              </li>
              <li>
                <Link to="/users">Users</Link>
              </li> */}
            </ul>
          </nav>
          {/* A <Switch> looks through its children <Route>s and
              renders the first one that matches the current URL. */}
          <Switch>
            <Route path="/HookSample" component={HookSample} />
            <Route path="/" render={() => <Button label="dfgdfgdfgf" />} />

            {/* <Route path="/users">
              <Users />
            </Route>
            <Route path="/">
              <Home />
            </Route> */}
          </Switch>
        </div>
      </Router>
    </Suspense>
  )
}
