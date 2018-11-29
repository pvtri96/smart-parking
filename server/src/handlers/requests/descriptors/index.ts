import { RequestDescriptor } from '../typing';
import { HelloWorldRequestDescriptor } from './hello-world';
import { FindParkingLotRequestDescriptor } from './parking/findParkingLots';

export const requestDescriptors: RequestDescriptor[] = [
  HelloWorldRequestDescriptor,
  FindParkingLotRequestDescriptor
]
