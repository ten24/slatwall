const PickupLocationDetails = ({ pickupLocation }) => {
  return (
    <>
      <h3 className="h6">Pickup Location:</h3>
      <p>{pickupLocation.locationName}</p>
    </>
  )
}

export { PickupLocationDetails }
