import { BreadCrumb } from '../../components'
import React, { useEffect } from 'react'
import { connect, useDispatch } from 'react-redux'
import { getContent } from '../../actions/contentActions'

const ProductListingHeader = ({ title, crumbs }) => {
  const dispatch = useDispatch()

  useEffect(() => {
    dispatch(
      getContent({
        content: {
          products: ['customBody', 'customSummary', 'title'],
        },
      })
    )
  }, [dispatch])
  return (
    <div className="page-title-overlap bg-lightgray pt-4">
      <div className="container d-lg-flex justify-content-between py-2 py-lg-3">
        <div className="order-lg-2 mb-3 mb-lg-0 pt-lg-2">
          <BreadCrumb crumbs={crumbs} />
        </div>
        <div className="order-lg-1 pr-lg-4 text-center text-lg-left">
          <h1 className="h3 text-dark mb-0">{title}</h1>
        </div>
      </div>
    </div>
  )
}

function mapStateToProps(state) {
  return { ...state.content.products }
}
export default connect(mapStateToProps)(ProductListingHeader)
