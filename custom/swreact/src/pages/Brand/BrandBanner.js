import { SWImage } from '../../components'
const BrandBanner = ({ brandName = '', imageFile, brandDescription, subHeading }) => {
  return (
    <div className="row align-items-center">
      {/* Checking 'imageFile' length so that empty string does not get passed */}
      {imageFile && imageFile.length > 5 && <SWImage style={{ maxHeight: '150px' }} customPath="/custom/assets/images/brand/logo/" src={imageFile} alt={brandName} type="brand" className="bg-white mr-2 ml-3" />}
      <div className="col text-left">
        <h2 className="m-0 font-weight-normal">{brandName}</h2>
        {!!subHeading && <h3 className="h5 m-0">{subHeading}</h3>}
      </div>

      {/* <span dangerouslySetInnerHTML={{ __html: brandDescription }} /> */}
      <div className="col text-right ">
        <span dangerouslySetInnerHTML={{ __html: brandDescription }} />
      </div>
    </div>
  )
}

export default BrandBanner
