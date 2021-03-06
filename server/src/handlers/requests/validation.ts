import { Request } from './typing';

// tslint:disable no-any curly
export function isValidRequest(object: any): object is Request {
  if (!object.clientId) return false;
  if (!object.status) return false;
  if (!object.payload) return false;

  return true;
}

export function isValidResponse(request: Request): boolean {
  if (!request.response && !request.error) {
    return false;
  }

  return true;
}
