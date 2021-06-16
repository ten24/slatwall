import React from 'react'
// import PropTypes from 'prop-types'
import { useSelector } from 'react-redux'
import { AccountLayout, AccountContent, PaymentMethodItem } from '../../'
import { Link } from 'react-router-dom'
import { useTranslation } from 'react-i18next'

const AccountPaymentMethods = () => {
  const { primaryPaymentMethod, accountPaymentMethods } = useSelector(state => state.userReducer)
  const { t } = useTranslation()
  return (
    <AccountLayout>
      <AccountContent />
      {accountPaymentMethods.length === 0 && (
        <div className="alert alert-info" role="alert">
          {t('frontend.account.payment_methods.none')}
        </div>
      )}
      {accountPaymentMethods.length > 0 && (
        <div className="table-responsive font-size-md">
          <table className="table table-hover mb-0">
            <thead>
              <tr>
                <th>{t('frontend.account.payment_method.types')}</th>
                <th>{t('frontend.account.payment_method.name')}</th>
                <th>{t('frontend.account.payment_method.expires')}</th>
                <th></th>
              </tr>
            </thead>
            <tbody>
              {accountPaymentMethods &&
                accountPaymentMethods.map((card, index) => {
                  return <PaymentMethodItem key={index} {...card} isPrimary={card.accountPaymentMethodID === primaryPaymentMethod.accountPaymentMethodID} />
                })}
            </tbody>
          </table>
        </div>
      )}
      <hr className="pb-4" />
      <div className="text-sm-right">
        <Link className="btn btn-primary" to="/my-account/cards/new">
          {t('frontend.account.payment_method.add')}
        </Link>
      </div>
    </AccountLayout>
  )
}

AccountPaymentMethods.propTypes = {}
export { AccountPaymentMethods }
