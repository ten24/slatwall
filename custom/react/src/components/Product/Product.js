import React from 'react'
import { connect } from 'react-redux'
import { Link } from 'react-router-dom'

const Product = props => {
  // We can use the `useParams` hook here to access
  // the dynamic pieces of the URL.

  const { id, title, author } = props.product

  return (
    <div className="ProductWrapper">
      <h1> {title} </h1>
      <p>Author: {author}</p>
      <Link to={`/product/${id}`}>Product Details</Link>
    </div>
  )
}

export default connect()(Product)
