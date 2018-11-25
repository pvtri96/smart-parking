
export interface Request<Payload = object, Response = object> {
  type: string;
  clientId: string;
  status: RequestStatus;
  payload: Payload;
  response?: Response;
  error?: Error;
}

export enum RequestStatus {
  REQUESTING = 'requesting',
  RESPONDED = 'responded',
}

export interface RequestControllerDescriptor<Payload = object, Response = object> {
  type: string;
  handle(request: Request<Payload, Response>): Promise<Response>;
}
