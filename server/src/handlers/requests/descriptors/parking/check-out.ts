import { updateParkingLot } from '../../../../entities';
import { RequestStatus } from '../../status';
import { requestTypeCreator } from '../../typing';

//////////////////////////////////////
//         REQUEST CHECK-OUT         //
//////////////////////////////////////
interface RequestCheckOutPayload {}
interface RequestCheckOutResponse {}
interface RequestCheckOutData {
  parkingLotId: string;
  checkedInAt: number;
}

export const RequestCheckOutDescriptor = requestTypeCreator<
  RequestCheckOutPayload,
  RequestCheckOutResponse,
  RequestCheckOutData,
  RequestCheckOutData
>(
  RequestStatus.REQUEST_CHECK_OUT_PARKING_LOT,
  async (request, requestId) => {
    console.log('Resolving check out request', request);

    await updateParkingLot(request.data.parkingLotId, parkingLot => {
      let parkingRequests = parkingLot.parkingRequests || [];
      parkingRequests = parkingRequests.map(req => {
        if (req.requestId === requestId) {
          return {
            ...req,
            status: RequestStatus.REQUEST_CHECK_OUT_PARKING_LOT,
          };
        }

        return req;
      });

      return {
        ...parkingLot,
        parkingRequests,
      };
    });

    return request;
  },
  request => {
    if (!request.data || !request.data.parkingLotId || !request.data.checkedInAt) {
      return false;
    }

    return true;
  },
);

//////////////////////////////////////
//         ACCEPT CHECK-OUT          //
//////////////////////////////////////
interface AcceptCheckOutPayload {}
interface AcceptCheckOutResponse {}
interface BeforeAcceptCheckOutData extends RequestCheckOutData {}
interface AfterAcceptCheckOutData extends BeforeAcceptCheckOutData {
  checkedInAt: number;
  checkedOutAt: number;
}

export const AcceptCheckOutDescriptor = requestTypeCreator<
  AcceptCheckOutPayload,
  AcceptCheckOutResponse,
  AfterAcceptCheckOutData,
  BeforeAcceptCheckOutData
>(
  RequestStatus.ACCEPT_CHECK_OUT_PARKING_LOT,
  async (request, requestId) => {
    await updateParkingLot(request.data.parkingLotId, parkingLot => {
      let parkingRequests = parkingLot.parkingRequests || [];
      let parkedRequests = parkingLot.parkedRequests || [];
      const updatedRequest = parkingRequests.find(
        req => req.requestId === requestId,
      );
      if (!updatedRequest) {
        throw Error('Can not find request in parking pending list');
      }

      updatedRequest.status = RequestStatus.CHECKED_OUT_OF_PARKING_LOT;
      parkingRequests = parkingRequests.filter(
        req => req.requestId !== requestId,
      );
      parkedRequests = [
        ...parkedRequests,
        {
          ...updatedRequest,
          checkOutAt: Date.now(),
        },
      ];

      return {
        ...parkingLot,
        parkingRequests,
        parkedRequests,
      };
    });

    return {
      ...request,
      status: RequestStatus.CHECKED_OUT_OF_PARKING_LOT,
      data: {
        ...request.data,
        checkedOutAt: Date.now(),
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
//         REJECT CHECK-OUT          //
//////////////////////////////////////
interface RejectCheckOutPayload {}
interface RejectCheckOutResponse {}
interface RejectCheckOutData extends RequestCheckOutData {}

export const RejectCheckOutDescriptor = requestTypeCreator<
  RejectCheckOutPayload,
  RejectCheckOutResponse,
  RejectCheckOutData,
  RejectCheckOutData
>(
  RequestStatus.REJECT_CHECK_OUT_PARKING_LOT,
  async request => {
    return {
      ...request,
      status: RequestStatus.FORBIDDEN,
      response: {},
    };
  },
  request => {
    if (request.data.parkingLotId) {
      return true;
    }

    return false;
  },
);
