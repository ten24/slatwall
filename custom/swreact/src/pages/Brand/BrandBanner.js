import { SWImage } from '../../components'
const BrandBanner = ({ brandName = '', imageFile, brandDescription, subHeading }) => {
  return (
    <div className="container pt-3 justify-content-between">
      <div className="row align-items-center">
        {/* Checking 'imageFile' length so that empty string does not get passed */}
        {imageFile && imageFile.length > 5 && <SWImage style={{ maxHeight: '150px', marginRight: '30px' }} customPath="/custom/assets/images/brand/logo/" src={imageFile} alt={brandName} type="brand" />}
        <div className="col text-left">
          <h1>{brandName}</h1>
          {!!subHeading && <h3>{subHeading}</h3>}
        </div>

        {/* <span dangerouslySetInnerHTML={{ __html: brandDescription }} /> */}
        <div className="col text-right ">
          <span dangerouslySetInnerHTML={{ __html: brandDescription }} />
        </div>
      </div>
    </div>
  )
}

export default BrandBanner
