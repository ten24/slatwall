import { SWImage } from '../../components'
const BrandBanner = ({ brandName, imageFile, brandDescription }) => {
  return (
    <div className="container">
      {/* Checking 'imageFile' length so that empty string does not get passed */}
      {imageFile && imageFile.length > 5 ? <SWImage style={{ maxHeight: '150px', marginRight: '50px' }} customPath="/custom/assets/images/brand/logo/" src={imageFile} alt={brandName} type="brand" /> : <h1>{brandName}</h1>}
      <p dangerouslySetInnerHTML={{ __html: brandDescription }} />
    </div>
  )
}

export default BrandBanner
