import { useTranslation } from 'react-i18next'
import { useFormatCurrency } from '../../hooks/'
import { isAuthenticated, isString } from '../../utils'

const ProductPrice = ({ salePrice = 0, listPrice = 0, salePriceSuffixKey, accentSalePrice = true, listPriceSuffixKey = 'frontend.core.list' }) => {
  const [formatCurrency] = useFormatCurrency({})
  const isAuthed = isAuthenticated()
  const showList = salePrice !== listPrice
  const { t } = useTranslation()

  if (isString(salePrice)) {
    salePrice = salePrice.trim().length > 0 ? parseInt(salePrice) : 0
  }
  if (isString(listPrice)) {
    listPrice = listPrice.trim().length > 0 ? parseInt(listPrice) : 0
  }

  const showMissingPrice = salePrice === 0 && listPrice === 0
  const showNoPrice = salePrice === 0 || listPrice === 0
  const showListPrice = (showList || !isAuthed) && !showMissingPrice && !showNoPrice && listPrice !== 0
  const showSalePrice = isAuthed && !showMissingPrice && salePrice !== 0

  return (
    <div className="product-price">
      {showMissingPrice && <small>{t('frontend.product.price.missing')}</small>}
      {showSalePrice && (
        <>
          <span className={accentSalePrice ? 'text-accent' : ''}>{formatCurrency(salePrice)}</span>
          <small>{salePriceSuffixKey && ` ${t(salePriceSuffixKey)}`}</small>
        </>
      )}
      {showListPrice && (
        <span style={{ marginLeft: '5px' }}>
          <small>
            {`${formatCurrency(listPrice)}`} {t(listPriceSuffixKey)}
          </small>
        </span>
      )}
    </div>
  )
}

export { ProductPrice }
