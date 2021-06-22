import { SwSelect } from '../../'
import { useTranslation } from 'react-i18next'
import { useEffect } from 'react'
import { useDispatch, useSelector } from 'react-redux'
import { getCountries, getStateCodeOptionsByCountryCode } from '../../../actions/contentActions'

const AccountAddressForm = ({ formik }) => {
  const { t } = useTranslation()
  const dispatch = useDispatch()
  const countryCodeOptions = useSelector(state => state.content.countryCodeOptions)
  const stateCodeOptions = useSelector(state => state.content.stateCodeOptions)
  const isFetching = useSelector(state => state.content.isFetching)

  useEffect(() => {
    if (countryCodeOptions.length === 0 && !isFetching) {
      dispatch(getCountries())
    }
    if (!stateCodeOptions[formik.values['billingAddress.countryCode']] && !isFetching) {
      dispatch(getStateCodeOptionsByCountryCode(formik.values['billingAddress.countryCode']))
    }
  }, [dispatch, formik, stateCodeOptions, countryCodeOptions, isFetching])
  return (
    <>
      <div className="col-12">
        <h5 className="mt-4 mb-2">Billing Address</h5>
      </div>

      <div className="col-md-6">
        <div className="form-group">
          <label htmlFor="billingAddress.countryCode">{t('frontend.account.countryCode')}</label>
          <SwSelect
            id="billingAddress.countryCode"
            name="['billingAddress.countryCode']"
            value={formik.values['billingAddress.countryCode']}
            onChange={e => {
              e.preventDefault()
              dispatch(getStateCodeOptionsByCountryCode(e.target.value))
              formik.handleChange(e)
            }}
            options={countryCodeOptions}
          />
        </div>
      </div>
      <div className="col-md-6">
        <div className="form-group">
          <label htmlFor="billingAddress.name">{t('frontend.account.fullname')}</label>
          <input className="form-control" name="['billingAddress.name']" type="text" id="billingAddress.name" value={formik.values['billingAddress.name']} onChange={formik.handleChange} />
        </div>
      </div>
      <div className="col-md-6">
        <div className="form-group">
          <label htmlFor="billingAddress.company">{t('frontend.account.company')}</label>
          <input className="form-control" name="['billingAddress.company']" type="text" id="billingAddress.company" value={formik.values['billingAddress.company']} onChange={formik.handleChange} />
        </div>
      </div>
      <div className="col-md-6">
        <div className="form-group">
          <label htmlFor="billingAddress.phoneNumber">{t('frontend.account.phoneNumber')}</label>
          <input className="form-control" name="['billingAddress.phoneNumber']" type="text" id="billingAddress.phoneNumber" value={formik.values['billingAddress.phoneNumber']} onChange={formik.handleChange} />
        </div>
      </div>
      <div className="col-md-6">
        <div className="form-group">
          <label htmlFor="billingAddress.emailAddress">{t('frontend.account.emailAddress')}</label>
          <input className="form-control" name="['billingAddress.emailAddress']" type="email" id="billingAddress.emailAddress" value={formik.values['billingAddress.emailAddress']} onChange={formik.handleChange} />
        </div>
      </div>
      <div className="col-md-6">
        <div className="form-group">
          <label htmlFor="billingAddress.streetAddress">{t('frontend.account.streetAddress')}</label>
          <input className="form-control" name="['billingAddress.streetAddress']" type="text" id="billingAddress.streetAddress" value={formik.values['billingAddress.streetAddress']} onChange={formik.handleChange} />
        </div>
      </div>
      <div className="col-md-6">
        <div className="form-group">
          <label htmlFor="billingAddress.street2Address">{t('frontend.account.street2Address')}</label>
          <input className="form-control" name="['billingAddress.street2Address']" type="text" id="billingAddress.street2Address" value={formik.values['billingAddress.street2Address']} onChange={formik.handleChange} />
        </div>
      </div>
      <div className="col-md-6">
        <div className="form-group">
          <label htmlFor="billingAddress.city">{t('frontend.account.city')}</label>
          <input className="form-control" name="['billingAddress.city']" type="text" id="billingAddress.city" value={formik.values['billingAddress.city']} onChange={formik.handleChange} />
        </div>
      </div>
      <div className="col-md-3">
        {stateCodeOptions[formik.values['billingAddress.countryCode']] && stateCodeOptions[formik.values['billingAddress.countryCode']].length > 0 && (
          <div className="form-group">
            <label htmlFor="billingAddress.stateCode">{t('frontend.account.stateCode')}</label>
            <SwSelect
              id="billingAddress.stateCode"
              name="['billingAddress.stateCode']"
              value={formik.values['billingAddress.paymentMethod.stateCode']}
              onChange={e => {
                e.preventDefault()
                formik.handleChange(e)
              }}
              options={stateCodeOptions[formik.values['billingAddress.countryCode']]}
            />
          </div>
        )}
      </div>
      <div className="col-md-3">
        <div className="form-group">
          <label htmlFor="billingAddress.postalCode">{t('frontend.account.postalCode')}</label>
          <input className="form-control" name="['billingAddress.postalCode']" type="text" id="billingAddress.postalCode" value={formik.values['billingAddress.postalCode']} onChange={formik.handleChange} />
        </div>
      </div>
    </>
  )
}

export { AccountAddressForm }
