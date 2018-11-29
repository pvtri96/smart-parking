import {
  Coordinate,
  findAllParkingLots,
  ParkingLot,
} from '../../../../entities';
import {
  getMatrixDistance,
  MatrixTextAndValue,
} from '../../../../services/googleMap';
import { RequestStatus } from '../../status';
import { requestTypeCreator } from '../../typing';

interface Payload {
  location: Coordinate;
}

interface Response {
  parkingLots: ParkingLotWithMatrix[];
}

interface ParkingLotWithMatrix extends ParkingLot {
  distance: MatrixTextAndValue;
  duration: MatrixTextAndValue;
}

interface Boundary {
  southWest: Coordinate;
  northEast: Coordinate;
}

const defaultBoundary: Boundary = {
  southWest: {
    lat: 16.018723,
    lng: 108.1924733,
  },
  northEast: {
    lat: 16.1019823,
    lng: 108.2656786,
  },
};

export const FindParkingLotRequestDescriptor = requestTypeCreator<
  Payload,
  Response
>(RequestStatus.REQUEST_FIND_PARKING_LOT, async request => {
  const { location } = request.payload;
  console.log('Client request with location', location);
  // TODO: Implement API call to determine

  let parkingLots = await findAllParkingLots();

  parkingLots = parkingLots.filter(
    entity =>
      entity.location.lat > defaultBoundary.southWest.lat &&
      entity.location.lat < defaultBoundary.northEast.lat &&
      entity.location.lng > defaultBoundary.southWest.lng &&
      entity.location.lng < defaultBoundary.northEast.lng,
  );

  const matrixDistance = await getMatrixDistance(
    location,
    parkingLots.map(a => a.location),
  );

  let matrixParkingLots = parkingLots.map<ParkingLotWithMatrix>(
    (lot, index) => ({
      ...lot,
      distance: matrixDistance.rows[0].elements[index].distance,
      duration: matrixDistance.rows[0].elements[index].duration,
    }),
  );

  matrixParkingLots = matrixParkingLots
    .sort((a, b) => a.duration.value - b.duration.value)
    .filter((_, index) => index < 5);

  return {
    ...request,
    status: RequestStatus.RESPONSE_FIND_PARKING_LOT,
    response: {
      parkingLots: matrixParkingLots,
    },
  };
});
