

interface RequestFindParkingPayload {
  currentLocation: {
    lat: string;
    lng: string;
  }
}

interface RequestFindParkingResponse {
  parkingLots: ParkingLot[]
}

interface RequestBookParkingPayload {
  parkingLotsId: string;
}

interface ResponseBookParkingAcceptedResponse {}

interface ResponseBookParkingRejectedResponse {}

interface RequestCheckInParkingPayload {
}

interface ResponseCheckingAcceptedResponse {}

interface ResponseCheckingRejectedResponse {}

interface RequestCheckOutParkingPayload {}

interface ResponseCheckOutAcceptedResponse {}

interface ResponseCheckOutRejectedResponse {}

interface ParkingLot {
  name: string;
  location: Location
}

interface Location {
  lat: number;
  lnt: number;
  address: string;
}
