import nodeFetch from 'node-fetch';
import * as QueryString from 'querystring';
import { apiKey } from '../config/googleMap';
import { Coordinate } from '../entities';

export async function getMatrixDistance(origin: Coordinate, destinations: Coordinate[]): Promise<MatrixDistance> {
  const query = QueryString.stringify({
    origins: normalizeCoordinate(origin),
    destinations: destinations.map(normalizeCoordinate).join("|"),
    key: apiKey
  });

  return nodeFetch(`https://maps.googleapis.com/maps/api/distancematrix/json?${query}`).then(res => res.json());
}

interface MatrixDistance {
  destination_addresses: string[];
  origin_addresses: string[];
  rows: [{
    elements: {
      distance: MatrixTextAndValue;
      duration: MatrixTextAndValue;
    }[];
  }]
}

export interface MatrixTextAndValue {
  text: string;
  value: number;
}

export function normalizeCoordinate(source: Coordinate): string {
  return `${source.lat},${source.lng}`
}
