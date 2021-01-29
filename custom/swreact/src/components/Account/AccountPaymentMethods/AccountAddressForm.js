import { connect } from 'react-redux'
import SwSelect from './SwSelect'

const AccountAddressForm = ({ formik, states, countries }) => {
  return (
    <>
      <h2>Billing Address</h2>
      <div className="form-group">
        <label htmlFor="billingAccountAddress.countryCode">Country</label>
        <SwSelect id="billingAccountAddress.countryCode" value={formik.values['countryCode']} onChange={formik.handleChange} options={countries} />
      </div>
      <div className="form-group">
        <label htmlFor="billingAccountAddress.name">Name</label>
        <input className="form-control" type="text" id="billingAccountAddress.name" value={formik.values['name']} onChange={formik.handleChange} />
      </div>
      <div className="form-group">
        <label htmlFor="billingAccountAddress.company">Company</label>
        <input className="form-control" type="text" id="billingAccountAddress.company" value={formik.values['company']} onChange={formik.handleChange} />
      </div>
      <div className="form-group">
        <label htmlFor="billingAccountAddress.phoneNumber">Phone Number</label>
        <input className="form-control" type="text" id="billingAccountAddress.phoneNumber" value={formik.values['phoneNumber']} onChange={formik.handleChange} />
      </div>
      <div className="form-group">
        <label htmlFor="billingAccountAddress.streetAddress">Street Address</label>
        <input className="form-control" type="text" id="billingAccountAddress.streetAddress" value={formik.values['streetAddress']} onChange={formik.handleChange} />
      </div>
      <div className="form-group">
        <label htmlFor="billingAccountAddress.street2Address">Street Address 2</label>
        <input className="form-control" type="text" id="billingAccountAddress.street2Address" value={formik.values['street2Address']} onChange={formik.handleChange} />
      </div>
      <div className="form-group">
        <label htmlFor="billingAccountAddress.city">City</label>
        <input className="form-control" type="text" id="billingAccountAddress.city" value={formik.values['city']} onChange={formik.handleChange} />
      </div>
      <div className="form-group">
        <label htmlFor="billingAccountAddress.stateCode">State</label>
        <SwSelect id="billingAccountAddress.stateCode" value={formik.values['paymentMethod.stateCode']} onChange={formik.handleChange} options={states} />
      </div>
      <div className="form-group">
        <label htmlFor="billingAccountAddress.postalCode">Postal Code</label>
        <input className="form-control" type="text" id="billingAccountAddress.postalCode" value={formik.values['billingAccountAddress.postalCode']} onChange={formik.handleChange} />
      </div>
    </>
  )
}

const mapStateToProps = state => {
  return {
    states: state.preload.states,
    countries: state.preload.countries,
  }
}
export default connect(mapStateToProps)(AccountAddressForm)
