import { RequestControllerDescriptor } from '../handlers/requests/type';
import { controllers as HelloControllers } from './hello.controller';

export const controllers: RequestControllerDescriptor[] = [
 ...HelloControllers,
]
