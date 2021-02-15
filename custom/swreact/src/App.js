import React, { Suspense, useEffect } from 'react'
import { Switch, Route } from 'react-router-dom'
import { useSelector } from 'react-redux'
import { Header, Layout, SEO } from './components'
import lazyWithPreload from './components/lazyWithPreload/lazyWithPreload'
import ScrollToTop from './components/ScrollToTop/ScrollToTop'
const Home = lazyWithPreload(() => import('./pages/Home/Home'))
const MyAccount = lazyWithPreload(() => import('./pages/MyAccount/MyAccount'))
const ProductListing = lazyWithPreload(() => import('./pages/ProductListing/ProductListing'))

const ProductDetail = lazyWithPreload(() => import('./pages/ProductDetail/ProductDetail'))

const CategoryListing = lazyWithPreload(() => import('./pages/CategoryListing/CategoryListing'))

const Testing = lazyWithPreload(() => import('./pages/Testing/Testing'))
const Brand = lazyWithPreload(() => import('./pages/Brand/Brand'))

const NotFound = lazyWithPreload(() => import('./pages/NotFound/NotFound'))
const ContentPage = lazyWithPreload(() => import('./pages/ContentPage/ContentPage'))
const pageComponents = {
  Home,
  MyAccount,
  ProductListing,
  ProductDetail,
  Testing,
  Brand,
  NotFound,
  ProductType: NotFound,
  Category: NotFound,
  Account: MyAccount,
  Address: NotFound,
  Attribute: NotFound,
  ContentPage,
}
const Loading = () => {
  return <Layout></Layout>
}
//https://itnext.io/react-router-transitions-with-lazy-loading-2faa7a1d24a
export default function App() {
  const routing = useSelector(state => state.preload.router)
  useEffect(() => {
    Object.keys(pageComponents).map(key => {
      return pageComponents[key].preload()
    })
  }, [])

  return (
    <Suspense fallback={<Loading />}>
      <ScrollToTop />
      <SEO />
      <Header />
      <Switch>
        {routing.length &&
          routing.map(({ URLKey, URLKeyType }, index) => {
            return <Route key={index} path={`/${URLKey}/:id`} component={pageComponents[URLKeyType]} />
          })}
        <Route path="/products" component={ProductListing} />
        <Route path="/product/:id" component={ProductDetail} />
        <Route path="/product" component={ProductListing} />
        <Route path="/sp/:id" component={ProductDetail} />
        <Route path="/shop/:id" component={Brand} />
        <Route path="/brand/:id" component={Brand} />
        <Route path="/category-listing" component={CategoryListing} />
        <Route path="/my-account" component={MyAccount} />
        <Route path="/MyAccount" component={MyAccount} />
        <Route path="/testing" component={Testing} />
        <Route exact path="/" component={Home} />
        <Route path="" component={ContentPage} />
      </Switch>
    </Suspense>
  )
}
