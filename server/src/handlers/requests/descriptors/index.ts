import { RequestDescriptor } from '../typing';
import { HelloWorldRequestDescriptor } from './hello-world';
import {
  AcceptBookingDescriptor,
  RejectBookingDescriptor,
  RequestBookingDescriptor,
} from './parking/booking';
import {
  AcceptCheckInDescriptor,
  RejectCheckInDescriptor,
  RequestCheckInDescriptor,
} from './parking/check-in';
import { FindParkingLotDescriptor } from './parking/findParkingLots';

export const requestDescriptors: RequestDescriptor[] = [
  HelloWorldRequestDescriptor,
  FindParkingLotDescriptor,
  RequestBookingDescriptor,
  AcceptBookingDescriptor,
  RejectBookingDescriptor,
  AcceptCheckInDescriptor,
  RejectCheckInDescriptor,
  RequestCheckInDescriptor,
];
