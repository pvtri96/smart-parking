import * as Firebase from 'firebase';

export interface FirebaseBookingPrice {
  /**
   * @description in hours
   */
  duration: number;
  /**
   * @description default price for 4 seats car
   */
  price: number;
  /**
   * @description default price for 6 seats car
   */
  price6: number;
  /**
   * @description default price for 12 seats car
   */
  price12: number;
}

export interface BookingPrice extends FirebaseBookingPrice {
  id: string;
}

export async function findAllBookingPrices(): Promise<BookingPrice[]> {
  return new Promise<BookingPrice[]>((resolve, reject) => {
    getRef().once(
      'value',
      snapshot => {
        const rawData = snapshot.val();
        const entities = Object.keys(rawData)
          .map(key => ({
            id: key,
            ...rawData[key],
          }))
          .filter(isBookingPrice);
        resolve(entities);
      },
      reject,
    );
  });
}

export async function findBookingPriceByDuration(
  duration: number,
): Promise<BookingPrice> {
  const bookingPrices = await findAllBookingPrices();
  const bookingPrice = bookingPrices.find(price => price.duration === duration);
  if (!bookingPrice) {
    throw Error(`Can not find booking price with duration = ${duration}.`);
  }

  return bookingPrice;
}

/**
 * Get reference of the database
 */
function getRef() {
  return Firebase.database().ref('bookingPrices');
}

/**
 * Parking Lot object validation
 */
function isBookingPrice(object: any): object is BookingPrice {
  if (
    object &&
    object.duration &&
    object.price &&
    object.price6 &&
    object.price12
  ) {
    return true;
  }

  return false;
}
