import { useDispatch, useSelector } from 'react-redux'
import { Layout } from '../../components'

import { Redirect, useLocation } from 'react-router'
import { useTranslation } from 'react-i18next'
import { useGetAllOrders } from '../../hooks/useAPI'
import { useEffect } from 'react'
import { confirmOrder } from '../../actions/cartActions'
import { isAuthenticated } from '../../utils'

const OrderConfirmation = () => {
  let [orders, setRequest] = useGetAllOrders()
  const { t, i18n } = useTranslation()
  let dispatch = useDispatch()
  let loc = useLocation()
  const { customBody = '' } = useSelector(state => state.content[loc.pathname.substring(1)]) || {}

  useEffect(() => {
    let didCancel = false

    if (!orders.isFetching && !orders.isLoaded && !didCancel) {
      setRequest({ ...orders, isFetching: true, isLoaded: false, params: { pageRecordsShow: 1, currentPage: 1 }, makeRequest: true })
    }
    dispatch(confirmOrder(false))
    return () => {
      didCancel = true
    }
  }, [orders, setRequest])

  if (!isAuthenticated()) {
    return <Redirect to={'/my-account'} />
  }
  return (
    <Layout>
      <div className="bg-light p-0">
        <div className="page-title-overlap bg-lightgray pt-4">
          <div className="container d-lg-flex justify-content-between py-2 py-lg-3">
            <div className="order-lg-1 pr-lg-4 text-center"></div>
          </div>
        </div>
        {orders.isLoaded && orders.data.ordersOnAccount[0] && (
          <div className="container bg-light box-shadow-lg rounded-lg p-5 text-center">
            <h1>{t('frontend.order.thank_you')}</h1>
            <p>{`${t('frontend.order.key')} #${orders.data.ordersOnAccount[0].orderNumber}`}</p>
            <div
              dangerouslySetInnerHTML={{
                __html: customBody,
              }}
            />
            <div className="container">
              <div className="row justify-content-center">
                <div className="col col-md-4">
                  <button
                    className="btn btn-primary btn-block"
                    onClick={e => {
                      e.preventDefault()
                      //   history.push('/my-account')
                    }}
                  >
                    {t('frontend.account.my')}
                  </button>
                </div>
              </div>
            </div>
          </div>
        )}
      </div>
    </Layout>
  )
}

export default OrderConfirmation
