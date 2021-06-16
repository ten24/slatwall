import { useTranslation } from 'react-i18next'
import { useFormatCurrency } from '../../hooks/'
import { isAuthenticated } from '../../utils'

const ProductPrice = ({ salePrice = 0, listPrice = 0, salePriceSuffixKey, accentSalePrice = true, listPriceSuffixKey = 'frontend.core.list' }) => {
  const [formatCurrency] = useFormatCurrency({})
  const isAuthed = isAuthenticated()
  const showList = salePrice !== listPrice
  const { t } = useTranslation()
  const showMissingPrice = salePrice === 0 && listPrice === 0
  const showNoPrice = salePrice === 0 || listPrice === 0
  return (
    <div className="product-price">
      {showMissingPrice && <small>{t('frontend.product.price.missing')}</small>}
      {isAuthed && !showMissingPrice && (
        <>
          <span className={accentSalePrice ? 'text-accent' : ''}>{formatCurrency(salePrice)}</span>
          <small>{salePriceSuffixKey && ` ${t(salePriceSuffixKey)}`}</small>
        </>
      )}
      {(showList || !isAuthed) && !showMissingPrice && !showNoPrice && (
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
