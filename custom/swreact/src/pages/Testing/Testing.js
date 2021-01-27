import React from 'react'
import { useTranslation } from 'react-i18next'
import i18next from 'i18next'
import { Layout } from '../../components'

const TranslationExmaple = () => {
  const { t } = useTranslation()

  return (
    <div>
      <h1>{t('Translation Exmaple')}</h1>
      <p>{t('admin.entity.brandTabs.vendors')}</p>
      <button
        type="button"
        className="btn btn-outline-primary"
        onClick={() => {
          i18next.changeLanguage('en')
          window.localStorage.setItem('i18nextLng', 'en')
        }}
      >
        Set English
      </button>
      <button
        type="button"
        className="btn btn-outline-primary"
        onClick={() => {
          i18next.changeLanguage('fr')
          window.localStorage.setItem('i18nextLng', 'fr')
        }}
      >
        Set French
      </button>
    </div>
  )
}

const CartTest = () => {
  return (
    <div>
      <h1>Cart Tools</h1>
      <p></p>
      <button
        className="btn btn-outline-primary"
        onClick={() => {
          console.log('Add to Cart')
        }}
      >
        Add To Cart
      </button>
    </div>
  )
}

const Testing = props => {
  return (
    <Layout>
      <div className="bg-light p-0">
        <div className="page-title-overlap bg-lightgray pt-4">
          <div className="container d-lg-flex justify-content-between py-2 py-lg-3">
            <div className="order-lg-1 pr-lg-4 text-center">
              <h1 className="h3 text-dark mb-0 font-accent">Kitchen Sink</h1>
            </div>
          </div>
        </div>

        <div className="container bg-light box-shadow-lg rounded-lg p-5">
          <div className="row">
            <div className="col-sm">
              <TranslationExmaple />
            </div>
            <div className="col-sm">
              <CartTest />
            </div>
          </div>
        </div>
      </div>
    </Layout>
  )
}

export default Testing
