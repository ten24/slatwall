import React from 'react'
import { connect } from 'react-redux'
import { withRouter } from 'react-router'
import { addAuthorToFilter, removeAuthorFromFilter } from '../../actions'

class AuthorFilter extends React.Component {
  handleSelectBox = e => {
    if (e.target.checked) {
      this.props.dispatch(addAuthorToFilter(e.target.name))
    } else {
      this.props.dispatch(removeAuthorFromFilter(e.target.name))
    }
  }
  isChecked = (author, filters) => {
    if (author === '') return false
    return filters.includes(author)
  }
  render() {
    return (
      <div className="card ">
        <div className="card-header text-center">Filter</div>
        <div className="card-body">
          <ul className="list-group list-group-flush">
            {this.props.filters.map((item, index) => {
              const key = `input${index}`
              return (
                <li key={item} className="text-capitalize list-group-item">
                  <input
                    className="form-check-input"
                    type="checkbox"
                    id={key}
                    name={item}
                    defaultChecked={this.isChecked(this.props.filter, item)}
                    onChange={this.handleSelectBox}
                  ></input>
                  <label className="form-check-label" htmlFor={key}>
                    {item}
                  </label>
                </li>
              )
            })}
          </ul>
        </div>
      </div>
    )
  }
}
const mapStateToProps = state => {
  let list = ['Tom', 'Sumit', 'Miguel', 'Kevin']
  //     state.shop.products.forEach(element => {

  //   });
  return {
    filters: list,
    filter: state.filter,
  }
}

export default withRouter(connect(mapStateToProps, null)(AuthorFilter))
