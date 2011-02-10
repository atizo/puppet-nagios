class nagios::defaults {
  include nagios::defaults::commands
  include nagios::defaults::contactgroups
  include nagios::defaults::contacts
  include nagios::defaults::hostgroups
  include nagios::defaults::templates
  include nagios::defaults::timeperiods
}
