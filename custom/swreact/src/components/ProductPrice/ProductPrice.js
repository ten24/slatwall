import { useTranslation } from 'react-i18next'
import useFormatCurrency from '../../hooks/useFormatCurrency'
import { isAuthenticated } from '../../utils'

const ProductPrice = ({ salePrice = 0, listPrice = 0, salePriceSuffixKey, accentSalePrice = true, listPriceSuffixKey = 'frontend.core.list' }) => {
  const [formatCurrency] = useFormatCurrency({})
  const isAuthed = isAuthenticated()
  const showList = salePrice !== listPrice
  const { t } = useTranslation()

  return (
    <div className="product-price">
      {isAuthed && (
        <>
          <span className={accentSalePrice ? 'text-accent' : ''}>{formatCurrency(salePrice)}</span>
          <small>{salePriceSuffixKey && ` ${t(salePriceSuffixKey)}`}</small>
        </>
      )}
      {(showList || !isAuthed) && (
        <span style={{ marginLeft: '5px' }}>
          <small>
            {`${formatCurrency(listPrice)}`} {t(listPriceSuffixKey)}
          </small>
        </span>
      )}
    </div>
  )
}

export default ProductPrice
