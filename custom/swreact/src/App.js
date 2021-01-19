import React, { Suspense } from 'react'
import { BrowserRouter as Router, Switch, Route } from 'react-router-dom'
import { Header, Layout, SEO } from './components'
const Home = React.lazy(() => import('./pages/Home/Home'))
const MyAccount = React.lazy(() => import('./pages/MyAccount/MyAccount'))
const ProductListing = React.lazy(() => import('./pages/ProductListing/ProductListing'))

const ProductDetail = React.lazy(() => import('./pages/ProductDetail/ProductDetail'))

const CategoryListing = React.lazy(() => import('./pages/CategoryListing/CategoryListing'))

const Contact = React.lazy(() => import('./pages/Contact/Contact'))

const About = React.lazy(() => import('./pages/About/About'))

const Testing = React.lazy(() => import('./pages/Testing/Testing'))

const Loading = () => {
  return <Layout></Layout>
}
//https://itnext.io/react-router-transitions-with-lazy-loading-2faa7a1d24a
export default function App() {
  return (
    <Router>
      <Suspense fallback={<Loading />}>
        <SEO />
        <Header />
        {/* TODO: We need a spinner */}
        {/* A <Switch> looks through its children <Route>s and
              renders the first one that matches the current URL. */}
        <Switch>
          <Route path="/products" component={ProductListing} />
          <Route path="/product-detail" component={ProductDetail} />
          <Route path="/sp/:id" component={ProductDetail} />
          <Route path="/category-listing" component={CategoryListing} />
          <Route path="/about" component={About} />
          <Route path="/contact" component={Contact} />
          <Route path="/my-account" component={MyAccount} />
          <Route path="/MyAccount" component={MyAccount} />
          <Route path="/testing" component={Testing} />
          <Route path="/" render={() => <Home />} />
        </Switch>
      </Suspense>
    </Router>
  )
}
