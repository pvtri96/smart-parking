export interface Coordinate {
  lat: number;
  lng: number;
}

export interface Location extends Coordinate {
  address: string;
}
