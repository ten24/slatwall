import React, { useState, useEffect } from 'react'
import { connect, useDispatch } from 'react-redux'
import { search, setCurrentPage } from '../../actions/productSearchActions'
const LEFT_PAGE = 'LEFT'
const RIGHT_PAGE = 'RIGHT'

// Built from here: https://www.digitalocean.com/community/tutorials/how-to-build-custom-pagination-with-react

/**
 * Helper method for creating a range of numbers
 * range(1, 5) => [1, 2, 3, 4, 5]
 */
const range = (from, to, step = 1) => {
  let i = from
  const range = []

  while (i <= to) {
    range.push(i)
    i += step
  }

  return range
}

const ProductListingPagination = ({ recordsCount, pageNeighbours = 2, currentPage, totalPages = 1 }) => {
  const dispatch = useDispatch()

  const calculatePageNumbers = () => {
    /**
     * totalNumbers: the total page numbers to show on the control
     * totalBlocks: totalNumbers + 2 to cover for the left(<) and right(>) controls
     */
    const totalNumbers = pageNeighbours * 2 + 3
    const totalBlocks = totalNumbers + 2

    if (totalPages > totalBlocks) {
      const startPage = Math.max(2, currentPage - pageNeighbours)
      const endPage = Math.min(totalPages - 1, currentPage + pageNeighbours)
      let pages = range(startPage, endPage)

      /**
       * hasLeftSpill: has hidden pages to the left
       * hasRightSpill: has hidden pages to the right
       * spillOffset: number of hidden pages either to the left or to the right
       */
      const hasLeftSpill = startPage > 2
      const hasRightSpill = totalPages - endPage > 1
      const spillOffset = totalNumbers - (pages.length + 1)

      switch (true) {
        // handle: (1) < {5 6} [7] {8 9} (10)
        case hasLeftSpill && !hasRightSpill: {
          const extraPages = range(startPage - spillOffset, startPage - 1)
          pages = [LEFT_PAGE, ...extraPages, ...pages]
          break
        }

        // handle: (1) {2 3} [4] {5 6} > (10)
        case !hasLeftSpill && hasRightSpill: {
          const extraPages = range(endPage + 1, endPage + spillOffset)
          pages = [...pages, ...extraPages, RIGHT_PAGE]
          break
        }

        // handle: (1) < {4 5} [6] {7 8} > (10)
        case hasLeftSpill && hasRightSpill:
        default: {
          pages = [LEFT_PAGE, ...pages, RIGHT_PAGE]
          break
        }
      }

      return [1, ...pages, totalPages]
    }
    return range(1, totalPages)
  }
  const gotoPage = pageTo => {
    const newPage = Math.max(0, Math.min(pageTo, totalPages))
    dispatch(setCurrentPage(newPage))
    dispatch(search())
  }

  const pages = calculatePageNumbers()
  if (!recordsCount || totalPages === 1) return null
  return (
    <nav className="d-flex justify-content-between pt-2" aria-label="Page navigation">
      <ul className="pagination">
        {pages.map((page, index) => {
          if (page === LEFT_PAGE)
            return (
              <li key={index} className="page-item">
                <a
                  className="page-link"
                  href="#"
                  aria-label="Previous"
                  onClick={evt => {
                    evt.preventDefault()
                    gotoPage(currentPage - pageNeighbours * 2 - 1)
                  }}
                >
                  <span aria-hidden="true">&laquo;</span>
                  <span className="sr-only">Previous</span>
                </a>
              </li>
            )

          if (page === RIGHT_PAGE)
            return (
              <li key={index} className="page-item">
                <a
                  className="page-link"
                  href="#"
                  aria-label="Next"
                  onClick={evt => {
                    evt.preventDefault()
                    gotoPage(currentPage + pageNeighbours * 2 + 1)
                  }}
                >
                  <span aria-hidden="true">&raquo;</span>
                  <span className="sr-only">Next</span>
                </a>
              </li>
            )

          return (
            <li key={index} className={`page-item${currentPage === page ? ' active' : ''}`}>
              <a
                className="page-link"
                href="#"
                onClick={evt => {
                  evt.preventDefault()
                  const newPage = Math.max(0, Math.min(page, totalPages))
                  dispatch(setCurrentPage(newPage))
                  dispatch(search())
                }}
              >
                {page}
              </a>
            </li>
          )
        })}
        {/* <li className="page-item">
          <a className="page-link" href="#">
            <i className="far fa-chevron-left mr-2"></i> Prev
          </a>
        </li>
      </ul>
      <ul className="pagination">
        <li className="page-item d-sm-none">
          <span className="page-link page-link-static">1 / 5</span>
        </li>
        <li className="page-item active d-none d-sm-block" aria-current="page">
          <span className="page-link">
            1<span className="sr-only">(current)</span>
          </span>
        </li>
        <li className="page-item d-none d-sm-block">
          <a className="page-link" href="#">
            2
          </a>
        </li>
        <li className="page-item d-none d-sm-block">
          <a className="page-link" href="#">
            3
          </a>
        </li>
        <li className="page-item d-none d-sm-block">
          <a className="page-link" href="#">
            4
          </a>
        </li>
        <li className="page-item d-none d-sm-block">
          <a className="page-link" href="#">
            5
          </a>
        </li>
      </ul>
      <ul className="pagination">
        <li className="page-item">
          <a className="page-link" href="#" aria-label="Next">
            Next <i className="far fa-chevron-right ml-2"></i>
          </a>
        </li> */}
      </ul>
    </nav>
  )
}
function mapStateToProps(state) {
  return state.productSearchReducer
}

export default connect(mapStateToProps)(ProductListingPagination)
