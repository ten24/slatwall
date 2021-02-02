import React, { Suspense, useEffect } from 'react'
import { BrowserRouter as Router, Switch, Route } from 'react-router-dom'
import { Header, Layout, SEO } from './components'
import lazyWithPreload from './components/lazyWithPreload/lazyWithPreload'
import ScrollToTop from './components/ScrollToTop/ScrollToTop'
const Home = lazyWithPreload(() => import('./pages/Home/Home'))
const MyAccount = lazyWithPreload(() => import('./pages/MyAccount/MyAccount'))
const ProductListing = lazyWithPreload(() => import('./pages/ProductListing/ProductListing'))

const ProductDetail = lazyWithPreload(() => import('./pages/ProductDetail/ProductDetail'))

const CategoryListing = lazyWithPreload(() => import('./pages/CategoryListing/CategoryListing'))

const Contact = lazyWithPreload(() => import('./pages/Contact/Contact'))

const About = lazyWithPreload(() => import('./pages/About/About'))

const Testing = lazyWithPreload(() => import('./pages/Testing/Testing'))
const Brand = lazyWithPreload(() => import('./pages/Brand/Brand'))

const NotFound = React.lazy(() => import('./pages/NotFound/NotFound'))

const Loading = () => {
  return <Layout></Layout>
}
//https://itnext.io/react-router-transitions-with-lazy-loading-2faa7a1d24a
export default function App() {
  useEffect(() => {
    Home.preload()
    MyAccount.preload()
    ProductListing.preload()
    ProductDetail.preload()
    CategoryListing.preload()
    Contact.preload()
    About.preload()
    Testing.preload()
    Brand.preload()
  }, [Home, About, Brand])

  return (
    <Router>
      <ScrollToTop />
      <Suspense fallback={<Loading />}>
        <SEO />
        <Header />
        {/* TODO: We need a spinner */}
        {/* A <Switch> looks through its children <Route>s and
              renders the first one that matches the current URL. */}
        <Switch>
          <Route path="/products" component={ProductListing} />
          <Route path="/product/:id" component={ProductDetail} />
          <Route path="/product" component={ProductListing} />
          <Route path="/sp/:id" component={ProductDetail} />
          <Route path="/shop/:id" component={Brand} />
          <Route path="/brand/:id" component={Brand} />
          <Route path="/category-listing" component={CategoryListing} />
          <Route path="/about" component={About} />
          <Route path="/contact" component={Contact} />
          <Route path="/my-account" component={MyAccount} />
          <Route path="/MyAccount" component={MyAccount} />
          <Route path="/testing" component={Testing} />
          <Route exact path="/" component={Home} />
          <Route path="" component={NotFound} />
        </Switch>
      </Suspense>
    </Router>
  )
}