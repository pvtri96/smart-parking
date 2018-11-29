import { RequestStatus } from './status';

export interface Request<TPayload = any, TResponse = any, TData = any> {
  clientId: string;
  status: RequestStatus;
  payload: TPayload;
  response?: TResponse;
  error?: Error;
  data?: TData;
}


export function requestTypeCreator<OldPayload = any, NewResponse = any, NewData = any, OldResponse = any, OldData = any, NewPayload = any>(
  statusType: string,
  handle: RequestHandlerFunction<OldPayload, OldResponse, OldData, NewPayload, NewResponse, NewData>,
  isValidRequest: IsValidRequestFunction<OldPayload, OldResponse, OldData> = defaultIsValidOldRequest
): RequestDescriptor<OldPayload, OldResponse, OldData, NewPayload, NewResponse, NewData> {
  return {
    statusType,
    handle,
    isValidRequest
  };
}

export interface RequestDescriptor<OldPayload = any, OldResponse = any, OldData = any, NewPayload = any, NewResponse = any, NewData = any> {
  statusType: string;
  handle: RequestHandlerFunction<OldPayload, OldResponse, OldData, NewPayload, NewResponse, NewData>;
  isValidRequest: IsValidRequestFunction<OldPayload, OldResponse, OldData>
}

export type RequestHandlerFunction< OldPayload = any, OldResponse = any, OldData = any, NewPayload = any, NewResponse = any, NewData = any> = (
  request: Request<OldPayload, OldResponse, OldData>,
) => Promise<Request<NewPayload, NewResponse, NewData>>;

export type IsValidRequestFunction<TPayload = any, TResponse = any, TData = any> =
  (request: Request<any, any, any>) => request is Request<TPayload, TResponse, TData>;

function defaultIsValidOldRequest(_: Request<any, any, any>): _ is Request<any, any, any> {
  return true
}
