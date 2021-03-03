const ShippingSlide = () => {
  return (
    <>
      {/* <!-- Shipping address--> */}
      <div className="row mb-3">
        <div className="col-sm-12">
          <div className="form-group">
            <label className="w-100" htmlFor="checkout-recieve">
              How do you want to recieve your items?
            </label>
            <div className="form-check form-check-inline custom-control custom-radio d-inline-flex">
              <input className="custom-control-input" type="radio" name="inlineRadioOptions" id="ship" value="option1" defaultChecked />
              <label className="custom-control-label" htmlFor="ship">
                Ship my order
              </label>
            </div>
            <div className="form-check form-check-inline custom-control custom-radio d-inline-flex">
              <input className="custom-control-input" type="radio" name="inlineRadioOptions" id="pickup" value="option2" />
              <label className="custom-control-label" htmlFor="pickup">
                Pick up my order
              </label>
            </div>
          </div>
        </div>
      </div>
      <h2 className="h6 pt-1 pb-3 mb-3 border-bottom">Shipping address</h2>
      <div className="row">
        <div className="col-sm-6">
          <div className="form-group">
            <label htmlFor="checkout-country">Country</label>
            <select defaultValue="US" className="form-control custom-select" id="checkout-country">
              <option value="">Choose country</option>
              <option value="CA">Canada</option>
              <option value="US">USA</option>
            </select>
          </div>
        </div>
        <div className="col-sm-6">
          <div className="form-group">
            <label htmlFor="checkout-n">Name</label>
            <input className="form-control" type="text" id="checkout-n" />
          </div>
        </div>
      </div>
      <div className="row">
        <div className="col-sm-6">
          <div className="form-group">
            <label htmlFor="checkout-address-1">Address 1</label>
            <input className="form-control" type="text" id="checkout-address-1" />
          </div>
        </div>
        <div className="col-sm-6">
          <div className="form-group">
            <label htmlFor="checkout-address-2">Address 2</label>
            <input className="form-control" type="text" id="checkout-address-2" />
          </div>
        </div>
      </div>
      <div className="row">
        <div className="col-sm-6">
          <div className="form-group">
            <label htmlFor="checkout-address-1">City</label>
            <input className="form-control" type="text" id="checkout-city" />
          </div>
        </div>
        <div className="col-sm-3">
          <div className="form-group">
            <label htmlFor="checkout-country">State</label>
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
            <label htmlFor="checkout-zip">ZIP Code</label>
            <input className="form-control" type="text" id="checkout-zip" />
          </div>
        </div>
      </div>
      <div className="custom-control custom-checkbox">
        <input className="custom-control-input" type="checkbox" id="save-address" />
        <label className="custom-control-label" htmlFor="save-address">
          Save this address
        </label>
      </div>
      <div className="custom-control custom-checkbox">
        <input className="custom-control-input" type="checkbox" id="blind-ship" />
        <label className="custom-control-label" htmlFor="blind-ship">
          Select for blind ship
        </label>
      </div>
    </>
  )
}

export default ShippingSlide
