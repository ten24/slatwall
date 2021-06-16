const SwSelect = ({ id, value, onChange, options, disabled }) => {
  return (
    <select disabled={disabled} className="form-control custom-select" id={id} name={`['${id}']`} value={value} onChange={onChange}>
      {options &&
        options.map(({ key, name, value }, index) => {
          return (
            <option key={index} value={value}>
              {key || name}
            </option>
          )
        })}
    </select>
  )
}

export { SwSelect }
