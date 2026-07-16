@AbapCatalog.sqlViewName: 'ZSSVBOOKINGR000'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Consumption view from /DMO/I_BOOKING_U'
@Metadata.allowExtensions: true
@Metadata.ignorePropagatedAnnotations: true
define view ZSS_I_BOOKING_R_000
  as select from /DMO/I_Booking_U as Booking
  association        to parent ZSS_I_TRAVEL_R_000 as _Travel     on $projection.TravelID = _Travel.TravelID
  /*+[hideWarning] { "IDS" : [ "CARDINALITY_CHECK" ] }*/
  association [1..1] to /DMO/I_Connection         as _Connection on $projection.ConnectionID = _Connection.ConnectionID
{
  key TravelID,
  key BookingID,
      BookingDate,
      CustomerID,
      AirlineID,
      ConnectionID,
      FlightDate,
      @Semantics.amount.currencyCode: 'Currency_Code'
      FlightPrice                                    as Flight_Price,

      @Semantics.currencyCode: true
      CurrencyCode                                   as Currency_Code,
      /* Associations */
      _BookSupplement,
      _Carrier,
      _Connection,
      _Customer,
      _Travel,

      @Semantics.quantity.unitOfMeasure: 'DistanceUnit'
      cast( _Connection.Distance as abap.dec(16,2) ) as Distance,

      @Semantics.unitOfMeasure: true
      _Connection.DistanceUnit                       as DistanceUnit,

      case
      when _Connection.Distance >= 2000 then 'long-haul flight'
      when _Connection.Distance >= 1000 and
         _Connection.Distance <  2000 then 'medium-haul flight'
      when _Connection.Distance <  1000 then 'short-haul flight'
                                      else 'error'
      end                                            as Flight_type
}
where
  _Connection.DistanceUnit = 'KM'
