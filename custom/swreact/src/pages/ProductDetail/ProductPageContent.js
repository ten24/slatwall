import ProductDetailGallery from './ProductDetailGallery'
import ProductPagePanels from './ProductPagePanels'
import { useEffect, useState } from 'react'
import { addToCart } from '../../actions/cartActions'
import { useDispatch, useSelector } from 'react-redux'
import { HeartButton, ProductPrice } from '../../components'
import { useTranslation } from 'react-i18next'
import queryString from 'query-string'
import { useHistory, useLocation } from 'react-router'
import ContentLoader from 'react-content-loader'
import { isAuthenticated } from '../../utils'

const OptionLoader = props => (
  <ContentLoader speed={2} width={400} height={150} viewBox="0 0 400 200" backgroundColor="#f3f3f3" foregroundColor="#ecebeb" {...props}>
    <rect x="25" y="15" rx="5" ry="5" width="350" height="20" />
    <rect x="25" y="45" rx="5" ry="5" width="350" height="10" />
    <rect x="25" y="60" rx="5" ry="5" width="350" height="10" />
    <rect x="26" y="75" rx="5" ry="5" width="350" height="10" />
    <rect x="27" y="107" rx="5" ry="5" width="350" height="20" />
    <rect x="26" y="135" rx="5" ry="5" width="350" height="10" />
    <rect x="26" y="150" rx="5" ry="5" width="350" height="10" />
    <rect x="27" y="165" rx="5" ry="5" width="350" height="10" />
  </ContentLoader>
)

const ProductPageContent = ({ product, skuID, sku, productOptions = [], availableSkuOptions = '', isFetching = false }) => {
  const dispatch = useDispatch()
  const { t } = useTranslation()
  const cart = useSelector(state => state.cart)
  const [quantity, setQuantity] = useState(1)
  return (
    <div className="container bg-light box-shadow-lg rounded-lg px-4 py-3 mb-5">
      <div className="px-lg-3">
        <div className="row">
          <ProductDetailGallery productID={product.productID} skuID={skuID} />
          {/* <!-- Product details--> */}
          <div className="col-lg-6 pt-0">
            <div className="product-details pb-3">
              <div className="d-flex justify-content-between align-items-center mb-2">
                <span className="d-inline-block font-size-sm align-middle px-2 bg-primary text-light"> {product.productClearance === true && ' On Special'}</span>
                {skuID && <HeartButton skuID={skuID} className={'btn-wishlist mr-0 mr-lg-n3'} />}
              </div>
              <h2 className="h4 mb-2">{product.productName}</h2>
              <div className="mb-2">
                <span className="text-small text-muted">{`SKU: `}</span>
                {sku && <span className="h4 font-weight-normal text-large text-accent mr-1">{sku.skuCode}</span>}
              </div>
              <div
                className="mb-3 font-weight-light font-size-small text-muted"
                dangerouslySetInnerHTML={{
                  __html: product.productDescription,
                }}
              />
              <form
                className="mb-grid-gutter"
                onSubmit={event => {
                  event.preventDefault()
                  dispatch(addToCart(sku.skuID, quantity))
                  window.scrollTo({
                    top: 0,
                    behavior: 'smooth',
                  })
                }}
              >
                {productOptions.length > 0 && !isFetching && <SkuOptions productID={product.productID} skuOptionDetails={productOptions} availableSkuOptions={availableSkuOptions} sku={sku} skuID={skuID} />}
                {isFetching && <OptionLoader />}
                <div className="mb-3">{sku && <ProductPrice salePrice={sku.price} listPrice={sku.listPrice} />}</div>
                <div className="form-group d-flex align-items-center">
                  <select
                    value={quantity}
                    onChange={event => {
                      setQuantity(event.target.value)
                    }}
                    className="custom-select mr-3"
                    style={{ width: '5rem' }}
                  >
                    {sku &&
                      sku.calculatedQATS > 0 &&
                      [...Array(sku.calculatedQATS > 20 ? 20 : sku.calculatedQATS).keys()].map((value, index) => (
                        <option key={index + 1} value={index + 1}>
                          {index + 1}
                        </option>
                      ))}
                  </select>

                  <button disabled={cart.isFetching || !skuID} className="btn btn-primary btn-block" type="submit">
                    <i className="far fa-shopping-cart font-size-lg mr-2"></i>
                    {t('frontend.product.add_to_cart')}
                  </button>
                </div>
              </form>
              {/* <!-- Product panels--> */}
              <ProductPagePanels product={product} />
            </div>
          </div>
        </div>
      </div>
    </div>
  )
}
const getOptionByCode = (filteredOptions, optionGroupCode, optionCode) => {
  return filteredOptions
    .filter(optionGroup => optionGroupCode === optionGroup.optionGroupCode)
    .map(optionGroup => optionGroup.options.filter(option => optionCode === option.optionCode))
    .flat()
    .shift()
}
const SkuOptions = ({ productID, skuOptionDetails, availableSkuOptions, sku, skuID }) => {
  const [lastOption, setLastOption] = useState({ optionCode: '', optionGroupCode: '' })
  const loc = useLocation()
  const history = useHistory()
  const { t } = useTranslation()

  let params = queryString.parse(loc.search, { arrayFormat: 'separator', arrayFormatSeparator: ',' })
  if (lastOption.optionGroupCode.length === 0 && Object.keys(params).length > 0) {
    setLastOption({ optionCode: Object.entries(params)[0][0], optionGroupCode: Object.entries(params)[0][1] })
  }
  const calculateOptions = () => {
    let filteredOptions = skuOptionDetails
    filteredOptions.forEach(filteredOption => {
      filteredOption.options = filteredOption.options.map(option => {
        option.active = true
        return option
      })
    })
    if (lastOption.optionGroupCode.length > 0) {
      filteredOptions.forEach(filteredOption => {
        filteredOption.options = filteredOption.options.map(option => {
          option.active = filteredOption.optionGroupCode === lastOption.optionGroupCode || availableSkuOptions.includes(option.optionID)
          return option
        })
      })
    }
    return filteredOptions
  }
  const setOption = (optionGroupCode, optionCode, active) => {
    delete params['skuid']
    setLastOption({ optionCode, optionGroupCode })
    if (!active) {
      params = {}
    }
    params[optionGroupCode] = optionCode
    history.push({
      pathname: loc.pathname,
      search: queryString.stringify(params, { arrayFormat: 'comma' }),
    })
  }
  let filteredOptions = calculateOptions()

  useEffect(() => {
    let forceSelcted = {}
    filteredOptions.forEach(optionGroup => {
      const selectedOptions = optionGroup.options.filter(({ active }) => {
        return active
      })
      if (selectedOptions.length === 1) {
        forceSelcted[optionGroup.optionGroupCode] = selectedOptions[0].optionCode
      }
    })
    // onkect sort order
    if (Object.keys(forceSelcted) && JSON.stringify({ ...forceSelcted, ...params }).length !== JSON.stringify(params).length) {
      console.log('Redirect because of foreced Selection')
      history.push({
        pathname: loc.pathname,
        search: queryString.stringify({ ...forceSelcted, ...params }, { arrayFormat: 'comma' }),
      })
    }
  }, [history, filteredOptions, loc, params])

  // searchForSelection(filteredOptions)
  return (
    <>
      {filteredOptions.length > 0 &&
        filteredOptions.map(({ optionGroupName, options, optionGroupID, optionGroupCode }) => {
          const selectedOptionCode = params[optionGroupCode] || options[0].optionCode
          return (
            <div className="form-group" key={optionGroupID}>
              <div className="d-flex justify-content-between align-items-center pb-1">
                <label className="font-weight-medium" htmlFor={optionGroupID}>
                  {optionGroupName}
                </label>
              </div>
              <select
                className="custom-select"
                required
                value={selectedOptionCode}
                id={optionGroupID}
                onChange={e => {
                  const selectedOption = getOptionByCode(filteredOptions, optionGroupCode, e.target.value)
                  setOption(optionGroupCode, selectedOption.optionCode, selectedOption.active)
                }}
              >
                {options &&
                  options.map(option => {
                    return (
                      <option className={`option ${option.active ? 'active' : 'nonactive'}`} key={option.optionID} value={option.optionCode}>
                        {option.active && option.optionName}
                        {!option.active && option.optionName + ' - ' + t('frontend.product.na')}
                      </option>
                    )
                  })}
              </select>
            </div>
          )
        })}
    </>
  )
}

export default ProductPageContent
