const HeartButton = ({ isSaved }) => {
  if (isSaved) {
    return (
      <button className="btn-wishlist btn-sm" type="button" data-toggle="tooltip" data-placement="left" title="" data-original-title="Add to wishlist">
        <i className="far fa-heart" style={{ color: '#5f1018' }}></i>
      </button>
    )
  } else {
    return (
      <button className="btn-wishlist btn-sm" type="button" data-toggle="tooltip" data-placement="left" title="" data-original-title="Add to wishlist">
        <i className="far fa-heart"></i>
      </button>
    )
  }
}
export default HeartButton
