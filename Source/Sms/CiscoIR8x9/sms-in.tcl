::cisco::eem::event_register_syslog pattern " New SMS received on index .*" maxrun 20


namespace import ::cisco::eem::*
namespace import ::cisco::lib::*
array set arr_einfo [event_reqinfo]
set runthis 0
set msg "$arr_einfo(msg)"
if { ! [regexp {: ([^:]+)$} $msg -> info] } {2
  action_syslog msg "Failed to parse syslog message"
}
array set _sinfo [sys_reqinfo_routername]
set host $_sinfo(routername)
regsub -all {\n+} $msg "" msg

if [ regexp {([A-Za-z\/0-9]+): New SMS received on index ([0-9]+).} $msg match intf ] {
  set cellintf $intf
  regsub -all {r} $intf "r " intf
}

proc deletesms {} {
  variable index
  variable errorInfo
  variable intf

  catch {cli_close $cli1(fd) $cli1(tty_id)}
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

  if [catch {cli_exec $cli1(fd) "$intf lte sms delete $index\r" } result ] {
    error $result $errorInfo
  }

  action_syslog msg "Successfully deleted SMS message $index from SIM\n"

  catch {cli_close $cli1(fd) $cli1(tty_id)}
  exit 1
}

# Trigger EEM from a SMS message
if [regexp {New SMS received on index ([0-9]+).} $info match index ] {

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
  if [catch {cli_exec $cli1(fd) "$intf lte sms view $index"} result] {
    error $result $errorInfo
  }

# send entire output via TCP socket to NotificationGateway app running on device.

set chan [socket x.x.x.x 8000]
puts $result
flush $chan

# simulating feedback from far end.
set feedback 200

if { $feedback == 200 } {
  deletesms
  close $chan
  exit
  } else {
  close $chan
  exit 1
  }

}
