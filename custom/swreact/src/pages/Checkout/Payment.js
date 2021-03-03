const PaymentSlide = () => {
  return (
    <>
      {/* <!-- Payment Method --> */}
      <div className="row mb-3">
        <div className="col-sm-12">
          <div className="form-group">
            <label className="w-100" htmlFor="checkout-recieve">
              Select Your Method of Payment
            </label>
            <div className="form-check form-check-inline custom-control custom-radio d-inline-flex">
              <input className="custom-control-input" type="radio" name="inlineRadioOptions" id="card" value="option1" />
              <label className="custom-control-label" htmlFor="card">
                Credit Card
              </label>
            </div>
            <div className="form-check form-check-inline custom-control custom-radio d-inline-flex">
              <input className="custom-control-input" type="radio" name="inlineRadioOptions" id="cod" value="option2" />
              <label className="custom-control-label" htmlFor="cod">
                Cash on Delivery
              </label>
            </div>
            <div className="form-check form-check-inline custom-control custom-radio d-inline-flex">
              <input className="custom-control-input" type="radio" name="inlineRadioOptions" id="po" value="option2" />
              <label className="custom-control-label" htmlFor="po">
                Purchase Order
              </label>
            </div>
          </div>
        </div>
      </div>

      {/* <!-- Credit Card --> */}
      <h2 className="h6 pt-1 pb-3 mb-3 border-bottom">Credit Card Information</h2>

      <div className="row">
        <div className="col-sm-6">
          <div className="form-group">
            <label htmlFor="checkout-nc">Name on Card</label>
            <input className="form-control" type="text" id="checkout-nc" />
          </div>
        </div>
        <div className="col-sm-6">
          <div className="form-group">
            <label htmlFor="checkout-cn">Card Number</label>
            <input className="form-control" type="text" id="checkout-cn" />
          </div>
        </div>
      </div>

      <div className="row">
        <div className="col-sm-6">
          <div className="form-group">
            <label htmlFor="checkout-cvv">CVV</label>
            <input className="form-control" type="text" id="checkout-cvv" />
          </div>
        </div>
        <div className="col-sm-3">
          <div className="form-group">
            <label htmlFor="checkout-expiration-m">Expiration Month</label>
            <select className="form-control custom-select" id="checkout-expiration-m">
              <option value="">Select Month</option>
              <option value="01">01 - JAN</option>
              <option value="02">02 - FEB</option>
              <option value="03">03 - MAR</option>
              <option value="04">04 - APR</option>
              <option value="05">05 - MAY</option>
              <option value="06">06 - JUN</option>
              <option value="07">07 - JUL</option>
              <option value="08">08 - AUG</option>
              <option value="09">09 - SEP</option>
              <option value="10">10 - OCT</option>
              <option value="11">11 - NOV</option>
              <option value="12">12 - DEC</option>
            </select>
          </div>
        </div>
        <div className="col-sm-3">
          <div className="form-group">
            <label htmlFor="checkout-expiration-y">Expiration Year</label>
            <select className="form-control custom-select" id="checkout-expiration-y">
              <option value="">Select Year</option>
              <option value="2020">2020</option>
              <option value="2021">2021</option>
              <option value="2022">2022</option>
              <option value="2023">2023</option>
              <option value="2024">2024</option>
              <option value="2025">2025</option>
              <option value="2026">2026</option>
              <option value="2027">2027</option>
              <option value="2028">2028</option>
              <option value="2029">2029</option>
              <option value="2030">2030</option>
            </select>
          </div>
        </div>
      </div>

      {/* <!-- Billing Address --> */}
      <h2 className="h6 pt-1 pb-3 mb-3 border-bottom">Billing Address</h2>

      <div className="custom-control custom-checkbox">
        <input className="custom-control-input" type="checkbox" defaultChecked id="same-address" />
        <label className="custom-control-label" htmlFor="same-address">
          Same as shipping address
        </label>
      </div>
    </>
  )
}

export default PaymentSlide
