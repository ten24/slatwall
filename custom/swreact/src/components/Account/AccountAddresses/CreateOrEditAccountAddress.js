import { connect, useDispatch, useSelector } from 'react-redux'
import SwSelect from '../../SwSelect/SwSelect'
import { useFormik } from 'formik'
import useRedirect from '../../../hooks/useRedirect'
import { AccountLayout } from '../AccountLayout/AccountLayout'
import AccountContent from '../AccountContent/AccountContent'
import { addNewAccountAddress, updateAccountAddress } from '../../../actions/userActions'
// TODO: Make this component reusable
import { useTranslation } from 'react-i18next'
import { useEffect } from 'react'
import { getCountries, getStateCodeOptionsByCountryCode } from '../../../actions/contentActions'

const CreateOrEditAccountAddress = ({ isEdit, heading, accountAddress, redirectLocation = '/my-account/addresses', customBody, contentTitle, action = 'Account Address' }) => {
  const [redirect, setRedirect] = useRedirect({ location: redirectLocation })
  const dispatch = useDispatch()
  const countryCodeOptions = useSelector(state => state.content.countryCodeOptions)
  const stateCodeOptions = useSelector(state => state.content.stateCodeOptions)
  const isFetching = useSelector(state => state.content.isFetching)

  const { t } = useTranslation()

  const formik = useFormik({
    enableReinitialize: true,
    initialValues: {
      accountAddressID: accountAddress ? accountAddress.accountAddressID : '',
      accountAddressName: accountAddress ? accountAddress.accountAddressName : '',
      countryCode: accountAddress ? accountAddress.address.countryCode : 'US',
      name: accountAddress ? accountAddress.address.name : '',
      company: accountAddress ? accountAddress.address.company : '',
      phoneNumber: accountAddress ? accountAddress.address.phoneNumber : '',
      streetAddress: accountAddress ? accountAddress.address.streetAddress : '',
      street2Address: accountAddress ? accountAddress.address.street2Address : '',
      city: accountAddress ? accountAddress.address.city : '',
      stateCode: accountAddress ? accountAddress.address.stateCode : '',
      postalCode: accountAddress ? accountAddress.address.postalCode : '',
    },
    onSubmit: values => {
      // TODO: Dispatch Actions
      if (isEdit) {
        dispatch(updateAccountAddress(values))
      } else {
        dispatch(addNewAccountAddress(values))
      }
      setRedirect({ ...redirect, shouldRedirect: true })
    },
  })

  useEffect(() => {
    if (countryCodeOptions.length === 0 && !isFetching) {
      dispatch(getCountries())
    }
    if (!stateCodeOptions[formik.values.countryCode] && !isFetching) {
      dispatch(getStateCodeOptionsByCountryCode(formik.values.countryCode))
    }
  }, [dispatch, formik, stateCodeOptions, countryCodeOptions, isFetching])
  console.log('formik.values.countryCode', formik.values.countryCode)
  console.log('stateCodeOptions[formik.values.countryCode]', stateCodeOptions[formik.values.countryCode])
  console.log('stateCodeOptions', stateCodeOptions)

  return (
    <AccountLayout title={`Add ${action}`}>
      <AccountContent customBody={customBody} contentTitle={contentTitle} />
      <form onSubmit={formik.handleSubmit}>
        <div className="row"></div>
        <h2>{heading}</h2>
        <div className="form-group">
          <label htmlFor="countryCode">{t('frontend.account.countryCode')}</label>
          <SwSelect
            id="countryCode"
            value={formik.values.countryCode}
            onChange={e => {
              e.preventDefault()
              dispatch(getStateCodeOptionsByCountryCode(e.target.value))
              formik.handleChange(e)
            }}
            options={countryCodeOptions}
          />
        </div>
        <div className="form-group">
          <label htmlFor="accountAddressName">{t('frontend.account.nickname')}</label>
          <input className="form-control" type="text" id="accountAddressName" value={formik.values['accountAddressName']} onChange={formik.handleChange} />
        </div>
        <div className="form-group">
          <label htmlFor="name">{t('frontend.account.name')}</label>
          <input className="form-control" type="text" id="name" value={formik.values['name']} onChange={formik.handleChange} />
        </div>
        <div className="form-group">
          <label htmlFor="company">{t('frontend.account.company')}</label>
          <input className="form-control" type="text" id="company" value={formik.values['company']} onChange={formik.handleChange} />
        </div>
        <div className="form-group">
          <label htmlFor="phoneNumber">{t('frontend.account.phoneNumber')} </label>
          <input className="form-control" type="text" id="phoneNumber" value={formik.values['phoneNumber']} onChange={formik.handleChange} />
        </div>
        <div className="form-group">
          <label htmlFor="streetAddress">{t('frontend.account.streetAddress')}</label>
          <input className="form-control" type="text" id="streetAddress" value={formik.values['streetAddress']} onChange={formik.handleChange} />
        </div>
        <div className="form-group">
          <label htmlFor="street2Address">{t('frontend.account.street2Address')}</label>
          <input className="form-control" type="text" id="street2Address" value={formik.values['street2Address']} onChange={formik.handleChange} />
        </div>
        <div className="form-group">
          <label htmlFor="city">{t('frontend.account.city')}</label>
          <input className="form-control" type="text" id="city" value={formik.values['city']} onChange={formik.handleChange} />
        </div>
        {stateCodeOptions[formik.values.countryCode] && stateCodeOptions[formik.values.countryCode].length > 0 && (
          <div className="form-group">
            <label htmlFor="stateCode">{t('frontend.account.stateCode')}</label>
            <SwSelect
              id="stateCode"
              value={formik.values['stateCode']}
              onChange={e => {
                e.preventDefault()
                formik.handleChange(e)
              }}
              options={stateCodeOptions[formik.values.countryCode]}
            />
          </div>
        )}

        <div className="form-group">
          <label htmlFor="postalCode">{t('frontend.account.postalCode')}</label>
          <input className="form-control" type="text" id="postalCode" value={formik.values['postalCode']} onChange={formik.handleChange} />
        </div>
        <div className="col-12">
          <hr className="mt-2 mb-3" />
          <div className="d-flex flex-wrap justify-content-end">
            <button type="submit" className="btn btn-primary mt-3 mt-sm-0">
              {isEdit ? `${t('frontend.core.save')} ${action}` : `${t('frontend.core.saveNew')} ${action}`}
            </button>
          </div>
        </div>
      </form>
    </AccountLayout>
  )
}

const mapStateToProps = (state, ownProps) => {
  let { accountAddresses } = state.userReducer

  accountAddresses = accountAddresses.filter(({ address }) => {
    return address.addressID === ownProps.path
  })
  return {
    isEdit: accountAddresses.length ? true : false,
    accountAddress: accountAddresses.length ? accountAddresses[0] : null,
  }
}
export default connect(mapStateToProps)(CreateOrEditAccountAddress)
