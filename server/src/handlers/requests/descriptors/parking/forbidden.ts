import { findAllParkingLots, updateParkingLot } from '../../../../entities';
import { RequestStatus } from '../../status';
import { requestTypeCreator } from '../../typing';

export const ForbiddenRequestDescriptor = requestTypeCreator(
  RequestStatus.FORBIDDEN,
  async (request, requestId) => {
    const lots = await findAllParkingLots();
    await Promise.all(
      lots.map(async lot => {
        if (lot.pendingRequests) {
          lot.pendingRequests = lot.pendingRequests.filter(pendingRequest => {
            if (pendingRequest.requestId === requestId) {
              return false;
            }

            return true;
          });
        }
        if (lot.parkingRequests) {
          lot.parkingRequests = lot.parkingRequests.filter(parkingRequest => {
            if (parkingRequest.requestId === requestId) {
              return false;
            }

            return true;
          });
        }

        await updateParkingLot(lot.id, () => lot);
      }),
    );

    return request;
  },
);
