::cisco::eem::event_register_rpc maxrun 30

namespace import ::cisco::eem::*
namespace import ::cisco::lib::*

array set arr_einfo [event_reqinfo]

set msisdn $arr_einfo(arg0)
set sms_msg $arr_einfo(arg1)
set cellif $arr_einfo(arg2)

# switch validates whether arg2 is referring to either cellular 0 or 1. if not EXIT 1 generating

switch -regexp $cellif {

    0
      {
      puts "selecting interface cell0"
      }

    1
      {
      puts "selecting interface cell1"
      }

    default
      {
      exit 1
      }

    }

# Open the CLI
  if [catch {cli_open} result] {
    error $result $errorInfo

  } else {
    array set cli1 $result
  }
# Go into enable mode
  if [catch {cli_exec $cli1(fd) "enable"} result] {
    error $result $errorInfo
  }

  if [catch {cli_exec $cli1(fd) "cellular $cellif lte sms send $msisdn $sms_msg" } result ] {
    error $result $errorInfo
  }

exit 0
