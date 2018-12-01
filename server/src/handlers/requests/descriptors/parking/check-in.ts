import { updateParkingLot } from '../../../../entities';
import { RequestStatus } from '../../status';
import { requestTypeCreator } from '../../typing';

//////////////////////////////////////
//         REQUEST CHECK-IN         //
//////////////////////////////////////
interface RequestCheckInPayload {}
interface RequestCheckInResponse {}
interface RequestCheckInData {
  parkingLotId: string;
}

export const RequestCheckInDescriptor = requestTypeCreator<
  RequestCheckInPayload,
  RequestCheckInResponse,
  RequestCheckInData,
  RequestCheckInData
>(
  RequestStatus.REQUEST_CHECK_IN_PARKING_LOT,
  async (request, requestId) => {
    console.log('Resolving check in request', request);

    await updateParkingLot(request.data.parkingLotId, parkingLot => {
      let pendingRequests = parkingLot.pendingRequests || [];
      pendingRequests = pendingRequests.map(req => {
        if (req.requestId === requestId) {
          return {
            ...req,
            status: RequestStatus.REQUEST_CHECK_IN_PARKING_LOT,
          };
        }

        return req;
      });

      return {
        ...parkingLot,
        pendingRequests,
      };
    });

    return request;
  },
  request => {
    if (!request.data || !request.data.parkingLotId) {
      return false;
    }

    return true;
  },
);

//////////////////////////////////////
//         ACCEPT CHECK-IN          //
//////////////////////////////////////
interface AcceptCheckInPayload {}
interface AcceptCheckInResponse {}
interface BeforeAcceptCheckInData extends RequestCheckInData {}
interface AfterAcceptCheckInData extends BeforeAcceptCheckInData {
  checkedInAt: number;
}

export const AcceptCheckInDescriptor = requestTypeCreator<
  AcceptCheckInPayload,
  AcceptCheckInResponse,
  AfterAcceptCheckInData,
  BeforeAcceptCheckInData
>(
  RequestStatus.ACCEPT_CHECK_IN_PARKING_LOT,
  async (request, requestId) => {
    await updateParkingLot(request.data.parkingLotId, parkingLot => {
      let pendingRequests = parkingLot.pendingRequests || [];
      let parkingRequests = parkingLot.parkingRequests || [];
      const updatedRequest = pendingRequests.find(
        req => req.requestId === requestId,
      );
      if (!updatedRequest) {
        throw Error('Can not find request in parking pending list');
      }

      updatedRequest.status = RequestStatus.PARKING_IN_PARKING_LOT;
      pendingRequests = pendingRequests.filter(
        req => req.requestId !== requestId,
      );
      parkingRequests = [
        ...parkingRequests,
        {
          ...updatedRequest,
          status: RequestStatus.PARKING_IN_PARKING_LOT,
          checkInAt: Date.now(),
        },
      ];

      return {
        ...parkingLot,
        pendingRequests,
        parkingRequests,
      };
    });

    return {
      ...request,
      status: RequestStatus.PARKING_IN_PARKING_LOT,
      data: {
        ...request.data,
        checkedInAt: Date.now(),
      },
    };
  },
  request => {
    if (!request.data || !request.data.parkingLotId) {
      return false;
    }

    return true;
  },
);

//////////////////////////////////////
//         REJECT CHECK-IN          //
//////////////////////////////////////
interface RejectCheckInPayload {}
interface RejectCheckInResponse {}
interface RejectCheckInData extends RequestCheckInData {}

export const RejectCheckInDescriptor = requestTypeCreator<
  RejectCheckInPayload,
  RejectCheckInResponse,
  RejectCheckInData,
  RejectCheckInData
>(
  RequestStatus.REJECT_CHECK_IN_PARKING_LOT,
  async request => {
    return {
      ...request,
      status: RequestStatus.FORBIDDEN,
      response: {},
      data: {
        parkingLotId: request.data.parkingLotId,
      },
    };
  },
  request => {
    if (request.data.parkingLotId) {
      return true;
    }

    return false;
  },
);
