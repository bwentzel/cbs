<?xml version="1.0"?>
<SOAP:Envelope xmlns:SOAP="http://www.cisco.com/eem.xsd">
<SOAP:Body>
<run_eemscript>
    <script_name>sms-out.tcl</script_name>
    <argc>3</argc>
    <arglist>
      <l>msisdn</l>
      <l>sms_msg</l>
      <l>cellif</l>
    </arglist>
 </run_eemscript>
 </SOAP:Body>
 </SOAP:Envelope>
 ]]>]]>
 
 
 Example:
 
<?xml version="1.0"?>
<SOAP:Envelope xmlns:SOAP="http://www.cisco.com/eem.xsd">
<SOAP:Body>
<run_eemscript>
    <script_name>sms-out.tcl</script_name>
    <argc>3</argc>
    <arglist>
      <l>4712345678</l>
      <l>Hello world</l>
      <l>0</l>
    </arglist>
 </run_eemscript>
 </SOAP:Body>
 </SOAP:Envelope>
 ]]>]]>
