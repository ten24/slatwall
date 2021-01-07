import React, { Suspense } from 'react'
import { BrowserRouter as Router, Switch, Route } from 'react-router-dom'
const Home = React.lazy(() => import('./pages/Home/Home'))
const MyAccount = React.lazy(() => import('./pages/MyAccount/MyAccount'))
const ProductSearch = React.lazy(() => import('./pages/ProductSearch/ProductSearch'))

const ProductDetail = React.lazy(() => import('./pages/ProductDetail/ProductDetail'))

const CategoryListing = React.lazy(() => import('./pages/CategoryListing/CategoryListing'))

const Contact = React.lazy(() => import('./pages/Contact/Contact'))

const About = React.lazy(() => import('./pages/About/About'))

const Testing = React.lazy(() => import('./pages/Testing/Testing'))

const Loading = () => {
  return <span>Loading...</span>
}
//https://itnext.io/react-router-transitions-with-lazy-loading-2faa7a1d24a
export default function App() {
  return (
    <Suspense fallback={<Loading />}>
      <Router>
        {/* A <Switch> looks through its children <Route>s and
              renders the first one that matches the current URL. */}
        <Switch>
          <Route path="/products" component={ProductSearch} />
          <Route path="/product-detail" component={ProductDetail} />
          <Route path="/category-listing" component={CategoryListing} />
          <Route path="/about" component={About} />
          <Route path="/contact" component={Contact} />
          <Route path="/my-account" component={MyAccount} />
          <Route path="/MyAccount" component={MyAccount} />
          <Route path="/testing" component={Testing} />
          <Route path="/" render={() => <Home />} />
        </Switch>
      </Router>
    </Suspense>
  )
}
