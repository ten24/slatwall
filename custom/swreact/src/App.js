import React, { Suspense, useEffect } from 'react'
import { Switch, Route } from 'react-router-dom'
import { useDispatch, useSelector } from 'react-redux'
import { Loading, Header, SEO, CMSWrapper } from './components'
import lazyWithPreload from './components/lazyWithPreload/lazyWithPreload'
import ScrollToTop from './components/ScrollToTop/ScrollToTop'
import { getConfiguration } from './actions/configActions'
import logo from './assets/images/logo.png'
import mobileLogo from './assets/images/logo-mobile.png'
import { ErrorBoundary } from 'react-error-boundary'

const Home = lazyWithPreload(() => import('./pages/Home/Home'))
const Cart = lazyWithPreload(() => import('./pages/Cart/Cart'))
const Contact = lazyWithPreload(() => import('./pages/Contact/Contact'))
const MyAccount = lazyWithPreload(() => import('./pages/MyAccount/MyAccount'))
const Search = lazyWithPreload(() => import('./pages/Search/Search'))
const Checkout = lazyWithPreload(() => import('./pages/Checkout/Checkout'))
const ProductDetail = lazyWithPreload(() => import('./pages/ProductDetail/ProductDetail'))
const Testing = lazyWithPreload(() => import('./pages/Testing/Testing'))
const Brand = lazyWithPreload(() => import('./pages/Brand/Brand'))
const Manufacturer = lazyWithPreload(() => import('./pages/Manufacturer/Manufacturer'))

const NotFound = lazyWithPreload(() => import('./pages/NotFound/NotFound'))
const ErrorFallback = lazyWithPreload(() => import('./pages/ErrorFallback/ErrorFallback'))
const ContentPage = lazyWithPreload(() => import('./pages/ContentPage/ContentPage'))
const Product = lazyWithPreload(() => import('./pages/Product/Product'))
const ProductType = lazyWithPreload(() => import('./pages/ProductType/ProductType'))
const Category = lazyWithPreload(() => import('./pages/Category/Category'))
const Account = lazyWithPreload(() => import('./pages/Account/Account'))
const Address = lazyWithPreload(() => import('./pages/Address/Address'))
const Attribute = lazyWithPreload(() => import('./pages/Attribute/Attribute'))
const OrderConfirmation = lazyWithPreload(() => import('./pages/OrderConfirmation/OrderConfirmation'))

const pageComponents = {
  Home,
  Checkout,
  Cart,
  Contact,
  MyAccount,
  Search,
  ProductDetail,
  Testing,
  NotFound,
  ContentPage,
  Product,
  ProductType,
  Category,
  Brand,
  Account,
  Address,
  Attribute,
  Manufacturer,
  OrderConfirmation,
}

//https://itnext.io/react-router-transitions-with-lazy-loading-2faa7a1d24a
export default function App() {
  const routing = useSelector(state => state.configuration.router)
  const shopByManufacturer = useSelector(state => state.configuration.shopByManufacturer)
  const dispatch = useDispatch()
  useEffect(() => {
    Object.keys(pageComponents).map(key => {
      return pageComponents[key].preload()
    })
    dispatch(getConfiguration())
  }, [dispatch])

  return (
    <Suspense fallback={<Loading />}>
      <Header logo={logo} mobileLogo={mobileLogo} />
      <ErrorBoundary
        FallbackComponent={ErrorFallback}
        onReset={() => {
          // reset the state of your app so the error doesn't happen again
        }}
      >
        <ScrollToTop />
        <SEO />
        <CMSWrapper />
        <Switch>
          <Route path="/404" component={NotFound} />
          <Route path="/Error" component={ErrorFallback} />
          <Route path="/contact" component={Contact} />
          {routing.length &&
            routing.map(({ URLKey, URLKeyType }, index) => {
              return <Route key={index} path={`/${URLKey}/:id`} component={pageComponents[URLKeyType]} />
            })}
          <Route path="/order-confirmation" component={OrderConfirmation} />
          <Route path={shopByManufacturer.slug} component={Manufacturer} />
          <Route path="/search" component={Search} />
          <Route path="/my-account" component={MyAccount} />
          <Route path="/checkout" component={Checkout} />
          <Route path="/checkout/:id" component={Checkout} />
          <Route path="/MyAccount" component={MyAccount} />
          <Route path="/testing" component={Testing} />
          <Route path="/shopping-cart" component={Cart} />
          <Route exact path="/" component={Home} />
          <Route path="" component={ContentPage} />
        </Switch>
      </ErrorBoundary>
    </Suspense>
  )
}
