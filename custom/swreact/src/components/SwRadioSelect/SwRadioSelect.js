const SwRadioSelect = ({ label, onChange, options = [], selectedValue, newLabel = '', displayNew = false }) => {
  if (displayNew) {
    options = [...options, { name: newLabel, value: 'new' }]
  }
  return (
    <div className="form-group">
      <label className="w-100">{label}</label>
      {options.length > 0 &&
        options.map(({ value, name, code }) => {
          return (
            <div key={value} className="form-check form-check-inline custom-control custom-radio d-inline-flex" style={{ zIndex: 0 }}>
              <input className="custom-control-input" type="radio" id={code || value} value={value} onChange={e => {}} checked={selectedValue === value} />
              <label
                className="custom-control-label"
                htmlFor={code || value}
                onClick={() => {
                  onChange(value)
                }}
              >
                {name}
              </label>
            </div>
          )
        })}
    </div>
  )
}

export default SwRadioSelect
