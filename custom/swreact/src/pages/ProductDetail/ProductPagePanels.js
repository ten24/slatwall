import { useTranslation } from 'react-i18next'
import { Link } from 'react-router-dom'
import { isBoolean, booleanToString } from '../../utils'

const propertyBlackList = ['productID', 'productName', 'productCode', 'productFeatured', 'productDisplay']

// TODO: Migrate to reactstrap accordion
const ProductPagePanels = ({ product = {}, attributeSets = [] }) => {
  const { t } = useTranslation()

  const filteredAttributeSets = attributeSets
    .map(set => {
      return { ...set, attributes: set.attributes.filter(attr => attr.attributeCode in product && !propertyBlackList.includes(attr.attributeCode) && product[attr.attributeCode] !== ' ').sort((a, b) => a.sortOrder - b.sortOrder) }
    })
    .filter(set => set.attributes.length)

  return (
    <div className="accordion mb-4" id="productPanels">
      {filteredAttributeSets.map(set => {
        return (
          <div key={set.attributeSetCode} className="card">
            <div className="card-header">
              <h3 className="accordion-heading">
                <a href={`#${set.attributeSetCode}`} role="button" data-toggle="collapse" aria-expanded="true" aria-controls={set.attributeSetCode}>
                  <i className="far fa-key font-size-lg align-middle mt-n1 mr-2"></i>
                  {set.attributeSetName}
                  <span className="accordion-indicator"></span>
                </a>
              </h3>
            </div>
            <div className="collapse show" id={set.attributeSetCode} data-parent="#productPanels">
              <div className="card-body font-size-sm">
                {set.attributes.map(({ attributeName, attributeCode }) => {
                  return (
                    <div className="font-size-sm row">
                      <div className="col-6">
                        <ul style={{ margin: 0, padding: 0 }}>{attributeName}</ul>
                      </div>
                      <div className="col-6 text-muted">
                        <ul style={{ margin: 0, padding: 0 }}>{isBoolean(product[attributeCode]) ? booleanToString(product[attributeCode]) : product[attributeCode]}</ul>
                      </div>
                    </div>
                  )
                })}
              </div>
            </div>
          </div>
        )
      })}
      {/* <div className="card">
        <div className="card-header">
          <h3 className="accordion-heading">
            <a className="collapsed" href="#technicalinfo" role="button" data-toggle="collapse" aria-expanded="true" aria-controls="technicalinfo">
              <i className="far fa-drafting-compass align-middle mt-n1 mr-2"></i>
              Technical Info<span className="accordion-indicator"></span>
            </a>
          </h3>
        </div>
        <div className="collapse" id="technicalinfo" data-parent="#productPanels">
          <div className="card-body font-size-sm">
            <div className="d-flex justify-content-between border-bottom py-2">
              <div className="font-weight-semibold text-dark">Document Title</div>
              <a href="?=doc">Download</a>
            </div>
            <div className="d-flex justify-content-between border-bottom py-2">
              <div className="font-weight-semibold text-dark">Document Title</div>
              <a href="?=doc">Download</a>
            </div>
          </div>
        </div>
      </div> */}

      <div className="card">
        <div className="card-header">
          <h3 className="accordion-heading">
            <a className="collapsed" href="#questions" role="button" data-toggle="collapse" aria-expanded="true" aria-controls="questions">
              <i className="far fa-question-circle font-size-lg align-middle mt-n1 mr-2"></i>
              {t('frontend.product.questions.heading')}
              <span className="accordion-indicator"></span>
            </a>
          </h3>
        </div>
        <div className="collapse" id="questions" data-parent="#productPanels">
          <div className="card-body">
            <p>{t('frontend.product.questions.detail')}</p>
            <Link to="/contact">{t('frontend.nav.contact')}</Link>
          </div>
        </div>
      </div>
    </div>
  )
}

export default ProductPagePanels
