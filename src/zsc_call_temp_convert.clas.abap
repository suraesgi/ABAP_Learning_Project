CLASS zsc_call_temp_convert DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun .
ENDCLASS.

CLASS zsc_call_temp_convert IMPLEMENTATION.
  METHOD if_oo_adt_classrun~main.
   TRY.
        DATA(destination) = cl_soap_destination_provider=>create_by_url( i_url = 'https://www.w3schools.com/xml/tempconvert.asmx' ).

        DATA(proxy) = NEW zsc_co_temp_convert_soap( destination = destination ).

        DATA request TYPE zsc_celsius_to_fahrenheit_soa1.
        request-celsius = '100'.

        proxy->celsius_to_fahrenheit(
          EXPORTING
            input = request
          IMPORTING
            output = DATA(response)
        ).

        out->write( '--- W3Schools Servis Testi Başarılı ---' ).
        out->write( |Gönderilen Değer : 100 Celsius| ).
        out->write( |Gelen Sonuç      : { response-celsius_to_fahrenheit_result } Fahrenheit| ).

      CATCH cx_root INTO DATA(lx_exception).
        out->write( 'Bir hata oluştu:' ).
        out->write( lx_exception->get_text( ) ).
    ENDTRY.
  ENDMETHOD.

ENDCLASS.
