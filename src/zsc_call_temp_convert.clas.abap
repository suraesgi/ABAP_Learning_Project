CLASS zsc_call_temp_convert DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.
ENDCLASS.

CLASS zsc_call_temp_convert IMPLEMENTATION.

  METHOD if_oo_adt_classrun~main.

    DATA: lo_web_client TYPE REF TO if_web_http_client.

    TRY.

        " Celsius değeri
        DATA(lv_celsius) = '100'.

        " Destination oluştur
        DATA(lo_destination) =
          cl_http_destination_provider=>create_by_url(
            'https://www.w3schools.com/xml/tempconvert.asmx'
          ).

        " HTTP Client oluştur
        lo_web_client =
          cl_web_http_client_manager=>create_by_http_destination(
            lo_destination
          ).

        " Request nesnesi
        DATA(lo_request) = lo_web_client->get_http_request( ).

        " Header'lar
        lo_request->set_header_field(
          i_name  = 'SOAPAction'
          i_value = 'https://www.w3schools.com/xml/CelsiusToFahrenheit'
        ).

        lo_request->set_header_field(
          i_name  = 'Content-Type'
          i_value = 'text/xml; charset=utf-8'
        ).

        " SOAP Envelope
        DATA(lv_xml) =
          |<?xml version="1.0" encoding="utf-8"?>| &&
          |<soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" | &&
          |xmlns:xsd="http://www.w3.org/2001/XMLSchema" | &&
          |xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">| &&
          |<soap:Body>| &&
          |<CelsiusToFahrenheit xmlns="https://www.w3schools.com/xml/">| &&
          |<Celsius>{ lv_celsius }</Celsius>| &&
          |</CelsiusToFahrenheit>| &&
          |</soap:Body>| &&
          |</soap:Envelope>|.

        lo_request->set_text( lv_xml ).

        " POST isteği gönder
        DATA(lo_response) =
          lo_web_client->execute(
            if_web_http_client=>post
          ).

        " HTTP Status kontrolü
        DATA(ls_status) = lo_response->get_status( ).

        IF ls_status-code <> 200.
          out->write( |HTTP Hatası: { ls_status-code }| ).
          RETURN.
        ENDIF.

        " Gelen XML
        DATA(lv_response_text) = lo_response->get_text( ).

        " Sonucu XML'den çıkar
        DATA(lv_start_tag) = '<CelsiusToFahrenheitResult>'.
        DATA(lv_end_tag)   = '</CelsiusToFahrenheitResult>'.

        FIND lv_start_tag IN lv_response_text MATCH OFFSET DATA(lv_offset).

        IF sy-subrc = 0.

          DATA(lv_val_start) = lv_offset + strlen( lv_start_tag ).

          FIND lv_end_tag IN lv_response_text
            MATCH OFFSET DATA(lv_end_offset).

          IF sy-subrc = 0.

            DATA(lv_length) = lv_end_offset - lv_val_start.

            DATA(lv_result) =
              lv_response_text+lv_val_start(lv_length).

            out->write( '--- W3Schools Servis Testi Başarılı ---' ).
            out->write( |Gönderilen Değer : { lv_celsius } Celsius| ).
            out->write(
              |W3Schools'tan Gelen Sonuç : { lv_result } Fahrenheit|
            ).

          ENDIF.

        ELSE.

          out->write( 'Beklenen XML etiketi bulunamadı.' ).
          out->write( lv_response_text ).

        ENDIF.


      CATCH cx_root INTO DATA(lx_exception).

        out->write( 'Bir hata oluştu:' ).
        out->write( lx_exception->get_text( ) ).

        IF lo_web_client IS BOUND.
          lo_web_client->close( ).
        ENDIF.

    ENDTRY.

  ENDMETHOD.

ENDCLASS.
