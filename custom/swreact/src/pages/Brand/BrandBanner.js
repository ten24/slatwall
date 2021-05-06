import { SWImage } from '../../components'
const BrandBanner = ({ brandName, imageFile, brandDescription }) => {
  return (
    <div className="container d-lg-flex justify-content-between py-2 py-lg-3">
      <SWImage style={{ maxHeight: '150px', marginRight: '50px' }} customPath="/custom/assets/images/brand/logo/" src={imageFile} alt={brandName} />
      <p dangerouslySetInnerHTML={{ __html: brandDescription }} />
    </div>
  )
}

export default BrandBanner
