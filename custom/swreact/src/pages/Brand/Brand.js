import { useTranslation } from 'react-i18next'
const CategoryList = props => {
  const products = []
  const { t, i18n } = useTranslation()

  return (
    <div className="container">
      <div className="row">
        <div className="span12">
          <h2>#$.slatwall.getBrand().getBrandName()#</h2>
        </div>
      </div>
      <div className="row">
        <div className="span12">
          <ul className="thumbnails">
            {/* <!--- Primary Loop that displays all of the products for this brand in the grid format ---> */}
            {products &&
              products.map((item, index) => {
                return (
                  <li key={index} className="span3">
                    {/* <!--- Individual Product ---> */}
                    <div className="thumbnail">
                      {/* <!--- Product Image ---> */}
                      <img src="#product.getResizedImagePath(size='m')#" alt="#product.getCalculatedTitle()#" />

                      {/* <!--- The Calculated Title allows you to setup a title string as a dynamic setting.  When you call getTitle() it generates the title based on that title string setting. To be more perfomant this value is cached as getCalculatedTitle() --->  */}
                      <h5>#product.getCalculatedTitle()#</h5>

                      {/* <!--- Check to see if the products price is > the sale price.  If so, then display the original price with a line through it ---> */}
                      {/* <cfif product.getPrice() gt product.getCalculatedSalePrice()>
                                                  <p><span style="text-decoration:line-through;">#product.getPrice()#</span> <span className="text-error">#product.getFormattedValue('calculatedSalePrice')#</span></p>
                                              <cfelse>
                                                  <p>#product.getFormattedValue('calculatedSalePrice')#</p>	
                                              </cfif> */}

                      {/* <!--- This is the link to the product detail page.  By using the getListingProductURL() instead of getProductURL() it will append to the end of the URL string so that the breadcrumbs on the detail page can know what listing page you came from.  This is also good for SEO purposes as long as you remember to add a canonical url meta information to the detail page ---> */}
                      <a href="#product.getListingProductURL()#">{t('frontend.brand.link')}</a>
                    </div>
                  </li>
                )
              })}
          </ul>
        </div>
      </div>
    </div>
  )
}

export default CategoryList
