import { Coordinate, findAllParkingLots, Location } from '../../../../entities';
import {
  getMatrixDistance,
  MatrixTextAndValue,
} from '../../../../services/googleMap';
import { RequestStatus } from '../../status';
import { requestTypeCreator } from '../../typing';

//////////////////////////////////////
//         FIND PARKING LOTS        //
//////////////////////////////////////
interface Payload {
  location: Coordinate;
}

interface Response {
  parkingLots: ParkingLotWithMatrix[];
}

interface ParkingLotWithMatrix {
  id: string;
  name: string;
  location: Location;
  capacity: number;
  distance: MatrixTextAndValue;
  duration: MatrixTextAndValue;
}

interface Boundary {
  southWest: Coordinate;
  northEast: Coordinate;
}

const defaultBoundary: Boundary = {
  // Góc tây nam Quốc lộ 1A, Đà Nẵng
  southWest: {
    lat: 16.018723,
    lng: 108.1924733,
  },
  // Chùa Linh Ứng, Đà Nẵng
  northEast: {
    lat: 16.1019823,
    lng: 108.2656786,
  },
};

export const FindParkingLotDescriptor = requestTypeCreator<Payload, Response>(
  RequestStatus.REQUEST_FIND_PARKING_LOT,
  async request => {
    const { location } = request.payload;

    let parkingLots = await findAllParkingLots();

    // Filter out the parking lots that which is inside the boundary
    parkingLots = parkingLots.filter(
      entity =>
        entity.location.lat > defaultBoundary.southWest.lat &&
        entity.location.lat < defaultBoundary.northEast.lat &&
        entity.location.lng > defaultBoundary.southWest.lng &&
        entity.location.lng < defaultBoundary.northEast.lng,
    );

    // Fetch matrix distance using Google Maps API
    const matrixDistance = await getMatrixDistance(
      location,
      parkingLots.map(a => a.location),
    );

    // Inject the matrix data to parking lots
    let matrixParkingLots = parkingLots.map<ParkingLotWithMatrix>(
      (lot, index) => ({
        id: lot.id,
        name: lot.name,
        location: lot.location,
        capacity: lot.capacity,
        distance: matrixDistance.rows[0].elements[index].distance,
        duration: matrixDistance.rows[0].elements[index].duration,
      }),
    );

    // Then filter 5 parking lots that have shortest duration to get there
    matrixParkingLots = matrixParkingLots
      .sort((a, b) => a.duration.value - b.duration.value)
      .filter((_, index) => index < 20);

    return {
      ...request,
      status: RequestStatus.RESPONSE_FIND_PARKING_LOT,
      response: {
        parkingLots: matrixParkingLots,
      },
    };
  },
  request => {
    if (request.payload.location.lat && request.payload.location.lng) {
      return true;
    }

    return false;
  },
);
