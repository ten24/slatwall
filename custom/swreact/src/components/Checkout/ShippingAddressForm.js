import SwSelect from '../../components/SwSelect/SwSelect'
import { useDispatch } from 'react-redux'
import { getStateCodeOptionsByCountryCode } from '../../actions/contentActions'
import { useTranslation } from 'react-i18next'

const ShippingAddressForm = ({ formik, isEdit, countryCodeOptions, stateCodeOptions = [], isShipping = true }) => {
  const { t } = useTranslation()
  const dispatch = useDispatch()
  return (
    <>
      <div className="row">
        <div className="col-sm-6">
          <div className="form-group">
            <label htmlFor="checkout-country">{t('frontend.account.countryCode')}</label>
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
        <div className="col-sm-6">
          <div className="form-group">
            <label htmlFor="name">{t('frontend.account.name')}</label>
            <input disabled={!isEdit} className="form-control" type="text" id="name" value={formik.values.name} onChange={formik.handleChange} />
          </div>
        </div>
      </div>
      <div className="row">
        <div className="col-sm-6">
          <div className="form-group">
            <label htmlFor="emailAddress">{t('frontend.account.emailAddress')}</label>
            <input disabled={!isEdit} className="form-control" type="text" id="emailAddress" value={formik.values.emailAddress} onChange={formik.handleChange} />
            {isShipping && (
              <span>
                <small>{t('frontend.account.emailAddress_note')}</small>
              </span>
            )}
          </div>
        </div>
        <div className="col-sm-6">
          <div className="form-group"></div>
        </div>
      </div>
      <div className="row">
        <div className="col-sm-6">
          <div className="form-group">
            <label htmlFor="streetAddress">{t('frontend.account.streetAddress')}</label>
            <input disabled={!isEdit} className="form-control" type="text" id="streetAddress" value={formik.values.streetAddress} onChange={formik.handleChange} />
          </div>
        </div>
        <div className="col-sm-6">
          <div className="form-group">
            <label htmlFor="street2Address">{t('frontend.account.street2Address')}</label>
            <input disabled={!isEdit} className="form-control" type="text" id="street2Address" value={formik.values.street2Address} onChange={formik.handleChange} />
          </div>
        </div>
      </div>
      <div className="row">
        <div className="col-sm-6">
          <div className="form-group">
            <label htmlFor="city">{t('frontend.account.city')}</label>
            <input disabled={!isEdit} className="form-control" type="text" id="city" value={formik.values.city} onChange={formik.handleChange} />
          </div>
        </div>
        {stateCodeOptions.length > 0 && (
          <div className="col-sm-3">
            <div className="form-group">
              <label htmlFor="stateCode">{t('frontend.account.stateCode')}</label>
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
            <label htmlFor="postalCode">{t('frontend.account.postalCode')}</label>
            <input disabled={!isEdit} className="form-control" type="text" id="postalCode" value={formik.values.postalCode} onChange={formik.handleChange} />
          </div>
        </div>
      </div>
    </>
  )
}
export { ShippingAddressForm }
