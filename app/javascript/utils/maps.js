export default {
  offsetCenter(map, latlng, offsetx, offsety = 0) {
    // latlng is the apparent centre-point
    // offsetx is the distance you want that point to move to the right, in pixels
    // offsety is the distance you want that point to move upwards, in pixels
    // offset can be negative
    // offsetx and offsety are both optional

    const scale = Math.pow(2, map.getZoom());

    const worldCoordinateCenter = map.getProjection().fromLatLngToPoint(latlng);
    const pixelOffset = new google.maps.Point(
      (offsetx / scale) || 0, (offsety / scale) || 0
    );

    const worldCoordinateNewCenter = new google.maps.Point(
        worldCoordinateCenter.x - pixelOffset.x,
        worldCoordinateCenter.y + pixelOffset.y
    );

    const newCenter = map.getProjection().fromPointToLatLng(
      worldCoordinateNewCenter
    );

    map.setCenter(newCenter);
  },
  geocode(address, successCallback, failureCallback) {
    const geocoder = new google.maps.Geocoder();

    geocoder.geocode({ 'address': address }, (results, status) => {
      if (status !== google.maps.GeocoderStatus.OK) {
        if (failureCallback) failureCallback(status);
        return;
      }

      successCallback(results);
    });
  },
};
