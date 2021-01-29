const SwSelect = ({ id, value, onChange, options }) => {
  return (
    <select className="form-control custom-select" id={id} name={`['${id}']`} value={value} onChange={onChange}>
      {options &&
        options.map(({ key, value }, index) => {
          return (
            <option key={index} value={value}>
              {key}
            </option>
          )
        })}
    </select>
  )
}

export default SwSelect
