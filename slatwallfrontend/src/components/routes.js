import React from "react"
import { Route, Switch } from "react-router-dom"
import { NotFound, Home, ProductDetail, ProductListing, Cart } from "."

const Routes = () => {
  return (
    <div>
      <Switch>
        <Route exact path="/">
          <Home />
        </Route>
        <Route path="/product/:id">
          <ProductDetail />
        </Route>
        <Route path="/products" children={<ProductListing />} />
        <Route path="/about">
          <h1>About</h1>
        </Route>
        <Route path="/cart">
          <Cart />
        </Route>
        <Route path="/search">
          <h1>search</h1>
        </Route>
        <Route path="/checkout">
          <h1>checkout</h1>
        </Route>
        <Route path="*">
          <NotFound />
        </Route>
      </Switch>
    </div>
  )
}

export default Routes
