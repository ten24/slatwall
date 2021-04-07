const PickupLocationDetails = ({ pickupLocation }) => {
  return (
    <div className="col-md-4">
      <h3 className="h6">Pickup Location:</h3>
      <p>{pickupLocation.locationName}</p>
    </div>
  )
}

export { PickupLocationDetails }
