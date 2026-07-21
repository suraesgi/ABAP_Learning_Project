class ZSC_CO_TEMP_CONVERT_SOAP definition
  public
  inheriting from CL_PROXY_CLIENT
  create public .

public section.

  methods CELSIUS_TO_FAHRENHEIT
    importing
      !INPUT type ZSC_CELSIUS_TO_FAHRENHEIT_SOA1
    exporting
      !OUTPUT type ZSC_CELSIUS_TO_FAHRENHEIT_SOAP
    raising
      CX_AI_SYSTEM_FAULT .
  methods CONSTRUCTOR
    importing
      !DESTINATION type ref to IF_PROXY_DESTINATION optional
      !LOGICAL_PORT_NAME type PRX_LOGICAL_PORT_NAME optional
    preferred parameter LOGICAL_PORT_NAME
    raising
      CX_AI_SYSTEM_FAULT .
  methods FAHRENHEIT_TO_CELSIUS
    importing
      !INPUT type ZSC_FAHRENHEIT_TO_CELSIUS_SOA1
    exporting
      !OUTPUT type ZSC_FAHRENHEIT_TO_CELSIUS_SOAP
    raising
      CX_AI_SYSTEM_FAULT .
protected section.
private section.
ENDCLASS.



CLASS ZSC_CO_TEMP_CONVERT_SOAP IMPLEMENTATION.


  method CELSIUS_TO_FAHRENHEIT.

  data(lt_parmbind) = value abap_parmbind_tab(
    ( name = 'INPUT' kind = '0' value = ref #( INPUT ) )
    ( name = 'OUTPUT' kind = '1' value = ref #( OUTPUT ) )
  ).
  if_proxy_client~execute(
    exporting
      method_name = 'CELSIUS_TO_FAHRENHEIT'
    changing
      parmbind_tab = lt_parmbind
  ).

  endmethod.


  method CONSTRUCTOR.

  super->constructor(
    class_name          = 'ZSC_CO_TEMP_CONVERT_SOAP'
    logical_port_name   = logical_port_name
    destination         = destination
  ).

  endmethod.


  method FAHRENHEIT_TO_CELSIUS.

  data(lt_parmbind) = value abap_parmbind_tab(
    ( name = 'INPUT' kind = '0' value = ref #( INPUT ) )
    ( name = 'OUTPUT' kind = '1' value = ref #( OUTPUT ) )
  ).
  if_proxy_client~execute(
    exporting
      method_name = 'FAHRENHEIT_TO_CELSIUS'
    changing
      parmbind_tab = lt_parmbind
  ).

  endmethod.
ENDCLASS.
