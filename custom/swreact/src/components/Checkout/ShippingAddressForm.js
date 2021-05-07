import SwSelect from '../../components/SwSelect/SwSelect'
import { useDispatch } from 'react-redux'
import { getStateCodeOptionsByCountryCode } from '../../actions/contentActions'

const ShippingAddressForm = ({ formik, isEdit, countryCodeOptions, stateCodeOptions = [] }) => {
  const dispatch = useDispatch()
  return (
    <>
      <div className="row">
        <div className="col-sm-6">
          <div className="form-group">
            <label htmlFor="accountAddressName">Nickname</label>
            <input disabled={!isEdit} className="form-control" type="text" id="accountAddressName" value={formik.values.accountAddressName} onChange={formik.handleChange} />
          </div>
        </div>
        <div className="col-sm-6">
          <div className="form-group">
            <label htmlFor="name">Name</label>
            <input disabled={!isEdit} className="form-control" type="text" id="name" value={formik.values.name} onChange={formik.handleChange} />
          </div>
        </div>
      </div>
      <div className="row">
        <div className="col-sm-6">
          <div className="form-group">
            <label htmlFor="streetAddress">Address 1</label>
            <input disabled={!isEdit} className="form-control" type="text" id="streetAddress" value={formik.values.streetAddress} onChange={formik.handleChange} />
          </div>
        </div>
        <div className="col-sm-6">
          <div className="form-group">
            <label htmlFor="street2Address">Address 2</label>
            <input disabled={!isEdit} className="form-control" type="text" id="street2Address" value={formik.values.street2Address} onChange={formik.handleChange} />
          </div>
        </div>
      </div>
      <div className="row">
        <div className="col-sm-4">
          <div className="form-group">
            <label htmlFor="city">City</label>
            <input disabled={!isEdit} className="form-control" type="text" id="city" value={formik.values.city} onChange={formik.handleChange} />
          </div>
        </div>
        <div className="col-sm-3">
          <div className="form-group">
            <label htmlFor="checkout-country">Country</label>
            <SwSelect
              id="countryCode"
              disabled={!isEdit}
              value={formik.values.countryCode}
              onChange={e => {
                e.preventDefault()
                dispatch(getStateCodeOptionsByCountryCode(e.target.value))
                formik.handleChange(e)
              }}
              options={countryCodeOptions}
            />
          </div>
        </div>
        {stateCodeOptions.length > 0 && (
          <div className="col-sm-3">
            <div className="form-group">
              <label htmlFor="stateCode">State</label>
              <SwSelect
                id="stateCode"
                disabled={!isEdit}
                value={formik.values.stateCode}
                onChange={e => {
                  e.preventDefault()
                  formik.handleChange(e)
                }}
                options={stateCodeOptions}
              />
            </div>
          </div>
        )}

        <div className="col-sm-2">
          <div className="form-group">
            <label htmlFor="postalCode">ZIP Code</label>
            <input disabled={!isEdit} className="form-control" type="text" id="postalCode" value={formik.values.postalCode} onChange={formik.handleChange} />
          </div>
        </div>
      </div>
    </>
  )
}
export { ShippingAddressForm }
