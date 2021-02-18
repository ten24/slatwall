import { BreadCrumb, Layout } from '../../components'
import { useSelector } from 'react-redux'
import { useLocation } from 'react-router-dom'

// https://www.digitalocean.com/community/tutorials/how-to-create-multistep-forms-with-react-and-semantic-ui
// https://github.com/srdjan/react-multistep/blob/master/react-multistep.js
// https://www.geeksforgeeks.org/how-to-create-multi-step-progress-bar-using-bootstrap/

const PageHead = () => {
  return (
    <div className="page-title-overlap bg-lightgray pt-4">
      <div className="container d-lg-flex justify-content-between py-2 py-lg-3">
        <div className="order-lg-2 mb-3 mb-lg-0 pt-lg-2">
          <nav aria-label="breadcrumb">
            <ol className="breadcrumb breadcrumb-dark flex-lg-nowrap justify-content-center justify-content-lg-start">
              <li className="breadcrumb-item">
                <a className="text-nowrap" href="/">
                  <i className="far fa-home"></i>Home
                </a>
              </li>
              <li className="breadcrumb-item text-nowrap">
                <a href="##">Shop</a>
              </li>
              <li className="breadcrumb-item text-nowrap active" aria-current="page">
                Checkout
              </li>
            </ol>
          </nav>
        </div>
        <div className="order-lg-1 pr-lg-4 text-center text-lg-left">
          <h1 className="h3 mb-0">Checkout</h1>
        </div>
      </div>
    </div>
  )
}

const Steps = () => {
  return (
    <div className="steps steps-dark pt-2 pb-3 mb-5">
      <a className="step-item active" href="/shopping-cart">
        <div className="step-progress">
          <span className="step-count">1</span>
        </div>
        <div className="step-label">
          <i className="fal fa-shopping-cart"></i>Cart
        </div>
      </a>
      <a className="step-item active current" href="#">
        <div className="step-progress">
          <span className="step-count">2</span>
        </div>
        <div className="step-label">
          <i className="fal fa-shipping-fast"></i>Shipping
        </div>
      </a>
      <a className="step-item" href="##">
        <div className="step-progress">
          <span className="step-count">3</span>
        </div>
        <div className="step-label">
          <i className="fal fa-credit-card"></i>Payment
        </div>
      </a>
      <a className="step-item" href="##">
        <div className="step-progress">
          <span className="step-count">4</span>
        </div>
        <div className="step-label">
          <i className="fal fa-check-circle"></i>Review
        </div>
      </a>
    </div>
  )
}

const SlideBody = () => {
  return (
    <>
      {' '}
      {/* <!-- Shipping address--> */}
      <h2 className="h6 pt-1 pb-3 mb-3 border-bottom">Shipping address</h2>
      <div className="row">
        <div className="col-sm-6">
          <div className="form-group">
            <label for="checkout-country">Country</label>
            <select className="form-control custom-select" id="checkout-country">
              <option value="">Choose country</option>
              <option value="CA">Canada</option>
              <option value="US" selected>
                USA
              </option>
            </select>
          </div>
        </div>
        <div className="col-sm-6">
          <div className="form-group">
            <label for="checkout-n">Name</label>
            <input className="form-control" type="text" id="checkout-n" />
          </div>
        </div>
      </div>
      <div className="row">
        <div className="col-sm-6">
          <div className="form-group">
            <label for="checkout-address-1">Address 1</label>
            <input className="form-control" type="text" id="checkout-address-1" />
          </div>
        </div>
        <div className="col-sm-6">
          <div className="form-group">
            <label for="checkout-address-2">Address 2</label>
            <input className="form-control" type="text" id="checkout-address-2" />
          </div>
        </div>
      </div>
      <div className="row">
        <div className="col-sm-6">
          <div className="form-group">
            <label for="checkout-address-1">City</label>
            <input className="form-control" type="text" id="checkout-city" />
          </div>
        </div>
        <div className="col-sm-3">
          <div className="form-group">
            <label for="checkout-country">State</label>
            <select className="form-control custom-select" id="checkout-state">
              <option value="AL">Alabama</option>
              <option value="AK">Alaska</option>
              <option value="AZ">Arizona</option>
              <option value="AR">Arkansas</option>
              <option value="CA">California</option>
              <option value="CO">Colorado</option>
              <option value="CT">Connecticut</option>
              <option value="DE">Delaware</option>
              <option value="DC">District Of Columbia</option>
              <option value="FL">Florida</option>
              <option value="GA">Georgia</option>
              <option value="HI">Hawaii</option>
              <option value="ID">Idaho</option>
              <option value="IL">Illinois</option>
              <option value="IN">Indiana</option>
              <option value="IA">Iowa</option>
              <option value="KS">Kansas</option>
              <option value="KY">Kentucky</option>
              <option value="LA">Louisiana</option>
              <option value="ME">Maine</option>
              <option value="MD">Maryland</option>
              <option value="MA">Massachusetts</option>
              <option value="MI">Michigan</option>
              <option value="MN">Minnesota</option>
              <option value="MS">Mississippi</option>
              <option value="MO">Missouri</option>
              <option value="MT">Montana</option>
              <option value="NE">Nebraska</option>
              <option value="NV">Nevada</option>
              <option value="NH">New Hampshire</option>
              <option value="NJ">New Jersey</option>
              <option value="NM">New Mexico</option>
              <option value="NY">New York</option>
              <option value="NC">North Carolina</option>
              <option value="ND">North Dakota</option>
              <option value="OH">Ohio</option>
              <option value="OK">Oklahoma</option>
              <option value="OR">Oregon</option>
              <option value="PA">Pennsylvania</option>
              <option value="RI">Rhode Island</option>
              <option value="SC">South Carolina</option>
              <option value="SD">South Dakota</option>
              <option value="TN">Tennessee</option>
              <option value="TX">Texas</option>
              <option value="UT">Utah</option>
              <option value="VT">Vermont</option>
              <option value="VA">Virginia</option>
              <option value="WA">Washington</option>
              <option value="WV">West Virginia</option>
              <option value="WI">Wisconsin</option>
              <option value="WY">Wyoming</option>
            </select>
          </div>
        </div>
        <div className="col-sm-3">
          <div className="form-group">
            <label for="checkout-zip">ZIP Code</label>
            <input className="form-control" type="text" id="checkout-zip" />
          </div>
        </div>
      </div>
      <div className="custom-control custom-checkbox">
        <input className="custom-control-input" type="checkbox" checked="" id="save-address" />
        <label className="custom-control-label" for="save-address">
          Save this address
        </label>
      </div>
      <div className="custom-control custom-checkbox">
        <input className="custom-control-input" type="checkbox" id="blind-ship" />
        <label className="custom-control-label" for="blind-ship">
          Select for blind ship
        </label>
      </div>
      {/* <!-- Navigation (desktop)--> */}
      <div className="d-lg-flex pt-4 mt-3">
        <div className="w-50 pr-3">
          <a className="btn btn-secondary btn-block" href="##">
            <i className="far fa-chevron-left"></i> <span className="d-none d-sm-inline">Back</span>
            <span className="d-inline d-sm-none">Back</span>
          </a>
        </div>
        <div className="w-50 pl-2">
          <a className="btn btn-primary btn-block" href="##">
            <span className="d-none d-sm-inline">Save & Continue</span>
            <span className="d-inline d-sm-none">Next</span> <i className="far fa-chevron-right"></i>
          </a>
        </div>
      </div>
    </>
  )
}

const CheckoutSideBar = () => {
  return (
    <aside className="col-lg-4 pt-4 pt-lg-0">
      <div className="cz-sidebar-static rounded-lg box-shadow-lg ml-lg-auto">
        <div className="alert alert-success alert-wicon" role="alert">
          <i className="fal fa-usd-circle"></i>
          You're only $13.03 away from recieving <strong>free freight</strong> on your order!
        </div>
        <div className="widget mb-3">
          <h2 className="widget-title text-center">Order summary</h2>
        </div>
        <ul className="list-unstyled font-size-sm pb-2 border-bottom">
          <li className="d-flex justify-content-between align-items-center">
            <span className="mr-2">Subtotal:</span>
            <span className="text-right">$265.00</span>
          </li>
          <li className="d-flex justify-content-between align-items-center">
            <span className="mr-2">Shipping:</span>
            <span className="text-right">--</span>
          </li>
          <li className="d-flex justify-content-between align-items-center">
            <span className="mr-2">Taxes:</span>
            <span className="text-right">$9.00</span>
          </li>
          <li className="d-flex justify-content-between align-items-center">
            <span className="mr-2">Discount:</span>
            <span className="text-right">--</span>
          </li>
        </ul>
        <h3 className="font-weight-normal text-center my-4">
          $274.<small>50</small>
        </h3>
        <form className="needs-validation" method="post" novalidate="">
          <div className="form-group">
            <input className="form-control" type="text" placeholder="Promo code" required="" />
            <div className="invalid-feedback">Please provide promo code.</div>
          </div>
          <button className="btn btn-outline-primary btn-block" type="submit">
            Apply promo code
          </button>
        </form>
      </div>
    </aside>
  )
}
const Checkout = () => {
  let loc = useLocation()
  const path = loc.pathname.split('/').reverse()[0].toLowerCase()

  return (
    <Layout>
      <PageHead />
      <div className="container pb-5 mb-2 mb-md-4">
        <div className="row">
          <section className="col-lg-8">
            {/* <!-- Steps--> */}
            <Steps />
            <div className="row mb-3">
              <div className="col-sm-12">
                <div className="form-group">
                  <label className="w-100" for="checkout-recieve">
                    How do you want to recieve your items?
                  </label>
                  <div className="form-check form-check-inline custom-control custom-radio d-inline-flex">
                    <input className="custom-control-input" type="radio" name="inlineRadioOptions" id="ship" value="option1" checked />
                    <label className="custom-control-label" for="ship">
                      Ship my order
                    </label>
                  </div>
                  <div className="form-check form-check-inline custom-control custom-radio d-inline-flex">
                    <input className="custom-control-input" type="radio" name="inlineRadioOptions" id="pickup" value="option2" />
                    <label className="custom-control-label" for="pickup">
                      Pick up my order
                    </label>
                  </div>
                </div>
              </div>
            </div>
            <SlideBody />
          </section>
          {/* <!-- Sidebar--> */}
          <CheckoutSideBar />
        </div>
      </div>
    </Layout>
  )
}

export default Checkout
