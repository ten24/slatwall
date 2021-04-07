import React, { Suspense, useEffect } from 'react'
import { Switch, Route } from 'react-router-dom'
import { useDispatch, useSelector } from 'react-redux'
import { Loading, Header, SEO, CMSWrapper } from './components'
import lazyWithPreload from './components/lazyWithPreload/lazyWithPreload'
import ScrollToTop from './components/ScrollToTop/ScrollToTop'
import { getConfiguration } from './actions/configActions'
const Home = lazyWithPreload(() => import('./pages/Home/Home'))
const Cart = lazyWithPreload(() => import('./pages/Cart/Cart'))
const MyAccount = lazyWithPreload(() => import('./pages/MyAccount/MyAccount'))
const ProductListing = lazyWithPreload(() => import('./pages/ProductListing/ProductListing'))
const Checkout = lazyWithPreload(() => import('./pages/Checkout/Checkout'))
const ProductDetail = lazyWithPreload(() => import('./pages/ProductDetail/ProductDetail'))
const CategoryListing = lazyWithPreload(() => import('./pages/CategoryListing/CategoryListing'))
const Testing = lazyWithPreload(() => import('./pages/Testing/Testing'))
const Brand = lazyWithPreload(() => import('./pages/Brand/Brand'))

const NotFound = lazyWithPreload(() => import('./pages/NotFound/NotFound'))
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
  MyAccount,
  ProductListing,
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
  OrderConfirmation,
}

//https://itnext.io/react-router-transitions-with-lazy-loading-2faa7a1d24a
export default function App() {
  const routing = useSelector(state => state.configuration.router)
  const dispatch = useDispatch()
  useEffect(() => {
    Object.keys(pageComponents).map(key => {
      return pageComponents[key].preload()
    })
    dispatch(getConfiguration())
  }, [dispatch])
  return (
    <Suspense fallback={<Loading />}>
      <ScrollToTop />
      <SEO />
      <Header />
      <CMSWrapper />
      <Switch>
        <Route path="/404" component={NotFound} />
        {routing.length &&
          routing.map(({ URLKey, URLKeyType }, index) => {
            return <Route key={index} path={`/${URLKey}/:id`} component={pageComponents[URLKeyType]} />
          })}
        <Route path="/order-confirmation" component={OrderConfirmation} />
        <Route path="/products" component={ProductListing} />
        <Route path="/product" component={ProductListing} />
        <Route path="/search" component={ProductListing} />
        <Route path="/category-listing" component={CategoryListing} />
        <Route path="/my-account" component={MyAccount} />
        <Route path="/checkout" component={Checkout} />
        <Route path="/checkout/:id" component={Checkout} />
        <Route path="/MyAccount" component={MyAccount} />
        <Route path="/testing" component={Testing} />
        <Route path="/shopping-cart" component={Cart} />
        <Route exact path="/" component={Home} />
        <Route path="" component={ContentPage} />
      </Switch>
    </Suspense>
  )
}
