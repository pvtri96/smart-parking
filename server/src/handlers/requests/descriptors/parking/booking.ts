
import { updateParkingLot } from '../../../../entities';
import { RequestStatus } from '../../status';
import { requestTypeCreator } from '../../typing';

//////////////////////////////////////
//         REQUEST BOOKING          //
//////////////////////////////////////
interface RequestBookingPayload {
  parkingLotId: string;
}
interface RequestBookingResponse {}

export const RequestBookingDescriptor = requestTypeCreator<
  RequestBookingPayload,
  RequestBookingResponse
>(RequestStatus.REQUEST_BOOKING_PARKING_LOT, async (request, requestId) => {
  console.log("Resolving request booking", request);
  // FIXME: Skip booking confirmation
  // await updateParkingLot(request.payload.parkingLotId, parkingLot => ({
  //   ...parkingLot,
  //   bookingRequest: [
  //     ...parkingLot.bookingRequest || [],
  //     {
  //       requestId,
  //       clientId: request.clientId,
  //       updatedAt: Date.now()
  //     }
  //   ]
  // }));

  // return {
  //   ...request,
  //   status: RequestStatus.REQUEST_BOOKING_PARKING_LOT,
  //   response: {},
  //   data: {},
  // };
  return AcceptBookingDescriptor.handle(request, requestId);
}, request => {
  if(request.payload.parkingLotId) {
    return true;
  }

  return false;
});

//////////////////////////////////////
//         ACCEPT BOOKING           //
//////////////////////////////////////
interface AcceptBookingPayload {
  parkingLotId: string;
}
interface AcceptBookingResponse {}
interface AcceptBookingData {
  parkingLotId: string;
}

export const AcceptBookingDescriptor = requestTypeCreator<
  AcceptBookingPayload,
  AcceptBookingResponse,
  AcceptBookingData
>(RequestStatus.ACCEPT_BOOKING_PARKING_LOT, async (request, requestId) => {

  await updateParkingLot(request.payload.parkingLotId, parkingLot => ({
    ...parkingLot,
    pendingRequests: [
      ...parkingLot.pendingRequests || [],
      {
        requestId,
        clientId: request.clientId,
        updatedAt: Date.now(),
        status: RequestStatus.MOVING_TO_PARKING_LOT
      }
    ]
  }));

  return {
    ...request,
    status: RequestStatus.MOVING_TO_PARKING_LOT,
    response: {},
    data: {
      parkingLotId: request.payload.parkingLotId
    },
  };
}, request => {
  if(request.payload.parkingLotId) {
    return true;
  }

  return false;
});

//////////////////////////////////////
//         REJECT BOOKING           //
//////////////////////////////////////
interface RejectBookingPayload {
  parkingLotId: string;
}
interface RejectBookingResponse {}
interface RejectBookingData {
  parkingLotId: string;
}

export const RejectBookingDescriptor = requestTypeCreator<
  RejectBookingPayload,
  RejectBookingResponse,
  RejectBookingData
>(RequestStatus.REJECT_BOOKING_PARKING_LOT, async request => {
  return {
    ...request,
    status: RequestStatus.FORBIDDEN,
    response: {},
    data: {
      parkingLotId: request.payload.parkingLotId
    },
  };
}, request => {
  if(request.payload.parkingLotId) {
    return true;
  }

  return false;
});
