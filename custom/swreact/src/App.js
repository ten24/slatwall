import React, { Suspense, useEffect } from 'react'
import { Switch, Route } from 'react-router-dom'
import { useDispatch, useSelector } from 'react-redux'
import { Header, Layout, SEO } from './components'
import lazyWithPreload from './components/lazyWithPreload/lazyWithPreload'
import ScrollToTop from './components/ScrollToTop/ScrollToTop'
import { getConfiguration } from './actions/configActions'
const Home = lazyWithPreload(() => import('./pages/Home/Home'))
const Cart = lazyWithPreload(() => import('./pages/Cart/Cart'))
const MyAccount = lazyWithPreload(() => import('./pages/MyAccount/MyAccount'))
const ProductListing = lazyWithPreload(() => import('./pages/ProductListing/ProductListing'))
<<<<<<< HEAD
const Checkout = lazyWithPreload(() => import('./pages/Checkout/Checkout'))

=======
>>>>>>> develop-team
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
const pageComponents = {
  Home,
<<<<<<< HEAD
  Checkout,
=======
  Cart,
>>>>>>> develop-team
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
}
const Loading = () => {
  return <Layout></Layout>
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
        <Route path="/product" component={ProductListing} />
        <Route path="/products" component={ProductListing} />
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
