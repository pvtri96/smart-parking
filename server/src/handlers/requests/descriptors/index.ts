import { RequestDescriptor } from '../typing';
import { HelloWorldRequestDescriptor } from './hello-world';
import { FindParkingLotDescriptor } from './parking/findParkingLots';
import {
  AcceptBookingDescriptor,
  RejectBookingDescriptor,
  RequestBookingDescriptor,
} from './parking/requestBooking';

export const requestDescriptors: RequestDescriptor[] = [
  HelloWorldRequestDescriptor,
  FindParkingLotDescriptor,
  RequestBookingDescriptor,
  AcceptBookingDescriptor,
  RejectBookingDescriptor,
];
