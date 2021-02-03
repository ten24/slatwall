import { connect } from 'react-redux'
import SwSelect from '../../SwSelect/SwSelect'

const AccountAddressForm = ({ formik, states, countries }) => {
  return (
    <>
      <h2>Billing Address</h2>
      <div className="form-group">
        <label htmlFor="billingAddress.countryCode">Country</label>
        <SwSelect id="billingAddress.countryCode" name="['billingAddress.countryCode']" value={formik.values['billingAddress.countryCode']} onChange={formik.handleChange} options={countries} />
      </div>
      <div className="form-group">
        <label htmlFor="billingAddress.name">Name</label>
        <input className="form-control" name="['billingAddress.name']" type="text" id="billingAddress.name" value={formik.values['billingAddress.name']} onChange={formik.handleChange} />
      </div>
      <div className="form-group">
        <label htmlFor="billingAddress.company">Company</label>
        <input className="form-control" name="['billingAddress.company']" type="text" id="billingAddress.company" value={formik.values['billingAddress.company']} onChange={formik.handleChange} />
      </div>
      <div className="form-group">
        <label htmlFor="billingAddress.phoneNumber">Phone Number</label>
        <input className="form-control" name="['billingAddress.phoneNumber']" type="text" id="billingAddress.phoneNumber" value={formik.values['billingAddress.phoneNumber']} onChange={formik.handleChange} />
      </div>
      <div className="form-group">
        <label htmlFor="billingAddress.streetAddress">Street Address</label>
        <input className="form-control" name="['billingAddress.streetAddress']" type="text" id="billingAddress.streetAddress" value={formik.values['billingAddress.streetAddress']} onChange={formik.handleChange} />
      </div>
      <div className="form-group">
        <label htmlFor="billingAddress.street2Address">Street Address 2</label>
        <input className="form-control" name="['billingAddress.street2Address']" type="text" id="billingAddress.street2Address" value={formik.values['billingAddress.street2Address']} onChange={formik.handleChange} />
      </div>
      <div className="form-group">
        <label htmlFor="billingAddress.city">City</label>
        <input className="form-control" name="['billingAddress.city']" type="text" id="billingAddress.city" value={formik.values['billingAddress.city']} onChange={formik.handleChange} />
      </div>
      <div className="form-group">
        <label htmlFor="billingAddress.stateCode">State</label>
        <SwSelect id="billingAddress.stateCode" name="['billingAddress.stateCode']" value={formik.values['billingAddress.paymentMethod.stateCode']} onChange={formik.handleChange} options={states} />
      </div>
      <div className="form-group">
        <label htmlFor="billingAddress.postalCode">Postal Code</label>
        <input className="form-control" name="['billingAddress.postalCode']" type="text" id="billingAddress.postalCode" value={formik.values['billingAddress.postalCode']} onChange={formik.handleChange} />
      </div>
    </>
  )
}

const mapStateToProps = state => {
  return {
    states: state.preload.states,
    countries: state.preload.countries,
    isEdit: false,
  }
}
export default connect(mapStateToProps)(AccountAddressForm)
