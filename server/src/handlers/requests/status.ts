export enum RequestStatus {
  REQUEST_HELLO_WORLD = 'REQUEST_HELLO_WORLD',
  RESPONSE_HELLO_WORLD = 'RESPONSE_HELLO_WORLD',

  REQUEST_FIND_PARKING_LOT = 'REQUEST_FIND_PARKING_LOT',
  RESPONSE_FIND_PARKING_LOT = 'RESPONSE_FIND_PARKING_LOT',

  REQUEST_BOOKING_PARKING_LOT = 'REQUEST_BOOKING_PARKING_LOT',
  ACCEPT_BOOKING_PARKING_LOT = 'ACCEPT_BOOKING_PARKING_LOT',
  REJECT_BOOKING_PARKING_LOT = 'REJECT_BOOKING_PARKING_LOT',
  MOVING_TO_PARKING_LOT = 'MOVING_TO_PARKING_LOT',

  REQUEST_CHECK_IN_PARKING_LOT = 'REQUEST_CHECK_IN_PARKING_LOT',
  ACCEPT_CHECK_IN_PARKING_LOT = 'ACCEPT_CHECK_IN_PARKING_LOT',
  REJECT_CHECK_IN_PARKING_LOT = 'REJECT_CHECK_IN_PARKING_LOT',
  PARKING_IN_PARKING_LOT = 'PARKING_IN_PARKING_LOT',

  REQUEST_CHECK_OUT_PARKING_LOT = 'REQUEST_CHECK_OUT_PARKING_LOT',
  ACCEPT_CHECK_OUT_PARKING_LOT = 'ACCEPT_CHECK_OUT_PARKING_LOT',
  REJECT_CHECK_OUT_PARKING_LOT = 'REJECT_CHECK_OUT_PARKING_LOT',
  CHECKED_OUT_OF_PARKING_LOT = 'CHECKED_OUT_OF_PARKING_LOT',

  FORBIDDEN = 'FORBIDDEN',
}
