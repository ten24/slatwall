import React from 'react'
import { HomeBanner } from '../components'

export default {
  title: 'StoneAndBerg/HomeBanner',
  component: HomeBanner,
  argTypes: {},
}

const Template = args => {
  return <HomeBanner {...args} />
}
export const Primary = Template.bind({})
Primary.args = {
  homeMainBanner:
    '[{"excludeFromSearch":" ","contentBody":" ","activeFlag":" ","contentIDPath":" ","urlTitle":"stone-bergs-commitment-to-you","disableProductAssignmentFlag":" ","productSortDefaultDirection":" ","site_siteCode":"stoneAndBerg","associatedImage":" ","contentID":"2c91808a74bb14de0174c061fe6e0066","titlePath":" ","cmsContentIDPath":" ","allowPurchaseFlag":" ","customBody":"<p>We are a Security Hardware Wholesale Company based out of Worcester, MA, dedicated to helping you and your company do business on a day-to-day basis. We offer a wide range of high-quality products and services at competitive prices. There is no minimum order requirement, and we ship to most locations in New England next-day delivery.</p>\\r\\n","templateFlag":" ","urlTitlePath":" ","productListingPageFlag":" ","linkUrl":"/shop","productSortProperty":" ","displayInNavigation":" ","title":"Stone & Berg’s Commitment to You","linkLabel":"Shop","customSummary":" ","sortOrder":43}]',
  featuredSlider:
    '[{"brand": "Brand A", "productTile": "Title 1", "price": "$209.24", "displayPrice": "$156.99", "linkUrl": "/shop-single-v1.html" },{"brand": "Brand A", "productTile": "Title 1", "price": "$209.24", "displayPrice": "$156.99", "linkUrl": "/shop-single-v1.html" },{"brand": "Brand A", "productTile": "Title 1", "price": "$209.24", "displayPrice": "$156.99", "linkUrl": "/shop-single-v1.html" },{"brand": "Brand A", "productTile": "Title 1", "price": "$209.24", "displayPrice": "$156.99", "linkUrl": "/shop-single-v1.html" },{"brand": "Brand A", "productTile": "Title 1", "price": "$209.24", "displayPrice": "$156.99", "linkUrl": "/shop-single-v1.html" },{"brand": "Brand A", "productTile": "Title 1", "price": "$209.24", "displayPrice": "$156.99", "linkUrl": "/shop-single-v1.html" }]',
}
