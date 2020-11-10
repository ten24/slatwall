import React from "react"
import { connect } from "react-redux"
import { Link } from "react-router-dom"

const Product = props => {
  // We can use the `useParams` hook here to access
  // the dynamic pieces of the URL.

  const {
    id,
    title,
    description,
    author,
    datePublished,
    yearPublished,
    price,
    rating,
    reviews,
  } = props.product

  return (
    <div className="ProductWrapper">
      <h1> {title} </h1>
      <Link to={`/product/${id}`}>Product Details</Link>{" "}
      {/* <h1>This is a page for product with ID: {title} </h1>
      <p>{description}</p> */}
    </div>
  )
}

export default connect()(Product)
