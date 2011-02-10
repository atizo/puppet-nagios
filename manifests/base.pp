class nagios::base {
  package{$nagios::packagename:
    alias => 'nagios',
    ensure => present,   
  }
  service{'nagios':
    ensure => running,
    enable => true,
    hasstatus => false,
    require => Package['nagios'],
  }
  if $use_munin {
    include nagios::munin
  }
  file{'nagios_main_cfg':
    path => "$nagios::cfgdir/$nagios::packagename.cfg",
    source => [
      "puppet://$server/modules/site-nagios/configs/$fqdn/$nagios::packagename.cfg",
      "puppet://$server/modules/site-nagios/configs/$operatingsystem/$nagios::packagename.cfg",
      "puppet://$server/modules/site-nagios/configs/$nagios::packagename.cfg",
      "puppet://$server/modules/nagios/configs/$operatingsystem/$nagios::packagename.cfg",
      "puppet://$server/modules/nagios/configs/$nagios::packagename.cfg",
    ],
    notify => Service['nagios'],
    mode => 0644, owner => root, group => root;
  }    
  file{'nagios_cgi_cfg':
    path => "$nagios::cfgdir/cgi.cfg",
    source => [
      "puppet://$server/modules/site-nagios/configs/$fqdn/cgi.cfg",
      "puppet://$server/modules/site-nagios/configs/$operatingsystem/cgi.cfg",
      "puppet://$server/modules/site-nagios/configs/cgi.cfg",
      "puppet://$server/modules/nagios/configs/$operatingsystem/cgi.cfg",
      "puppet://$server/modules/nagios/configs/cgi.cfg",
    ],
    mode => '0644', owner => 'root', group => 0,
    notify => Service[$nagios::webserver],
  }
  file{'nagios_htpasswd':
    path => "$nagios::cfgdir/htpasswd.users",
    source => [
      "puppet://$server/modules/site-nagios/htpasswd.users",
      "puppet://$server/modules/nagios/htpasswd.users",
    ],
    mode => 0640, owner => root, group => $nagios::webserver;
  }
  file{'nagios_private':
    path => "$nagios::cfgdir/private/",
    source => "puppet://$server/modules/common/empty",
    ensure => directory,
    purge => true,
    recurse => true,
    notify => Service['nagios'],
    mode => '0750', owner => root, group => $nagios::packagename;
  }
  file{'nagios_private_resource_cfg':
    path => "$nagios::cfgdir/private/resource.cfg",
    source => "puppet://$server/nagios/configs/$operatingsystem/private/resource.cfg.$architecture",
    notify => Service['nagios'],
    owner => root, group => nagios, mode => '0640',
    links => follow;
  }
  file{'nagios_confd':
    path => "$nagios::cfgdir/conf.d/",
    source => "puppet://$server/modules/common/empty",
    ensure => directory,
    purge => true,
    recurse => true,
    notify => Service['nagios'],
    mode => '0750', owner => root, group => $nagios::packagename;
  }

  Nagios_command <<||>>
  Nagios_contact <<||>>
  Nagios_contactgroup <<||>>
  Nagios_host <<||>>
  Nagios_hostextinfo <<||>>
  Nagios_hostgroup <<||>>
  Nagios_hostgroupescalation <<||>>
  Nagios_service <<||>>
  Nagios_servicedependency <<||>>
  Nagios_serviceescalation <<||>>
  Nagios_serviceextinfo <<||>>
  Nagios_timeperiod <<||>>

  Nagios_command <||> {
      target => "$nagios::cfgdir/conf.d/nagios_command.cfg",
      notify => Service['nagios'],
  }
  Nagios_contact <||> {
      target => "$nagios::cfgdir/conf.d/nagios_contact.cfg",
      notify => Service['nagios'],
  }
  Nagios_contactgroup <||> {
      target => "$nagios::cfgdir/conf.d/nagios_contactgroup.cfg",
      notify => Service['nagios'],
  }
  Nagios_host <||> {
      target => "$nagios::cfgdir/conf.d/nagios_host.cfg",
      notify => Service['nagios'],
  }
  Nagios_hostextinfo <||> {
      target => "$nagios::cfgdir/conf.d/nagios_hostextinfo.cfg",
      notify => Service['nagios'],
  }
  Nagios_hostgroup <||> {
      target => "$nagios::cfgdir/conf.d/nagios_hostgroup.cfg",
      notify => Service['nagios'],
  }
  Nagios_hostgroupescalation <||> {
      target => "$nagios::cfgdir/conf.d/nagios_hostgroupescalation.cfg",
      notify => Service['nagios'],
  }
  Nagios_service <||> {
      target => "$nagios::cfgdir/conf.d/nagios_service.cfg",
      notify => Service['nagios'],
  }
  Nagios_servicedependency <||> {
      target => "$nagios::cfgdir/conf.d/nagios_servicedependency.cfg",
      notify => Service['nagios'],
  }
  Nagios_serviceescalation <||> {
      target => "$nagios::cfgdir/conf.d/nagios_serviceescalation.cfg",
      notify => Service['nagios'],
  }
  Nagios_serviceextinfo <||> {
      target => "$nagios::cfgdir/conf.d/nagios_serviceextinfo.cfg",
      notify => Service['nagios'],
  }
  Nagios_timeperiod <||> {
      target => "$nagios::cfgdir/conf.d/nagios_timeperiod.cfg",
      notify => Service['nagios'],
  }

  file{[
    "$nagios::cfgdir/conf.d/nagios_command.cfg", 
    "$nagios::cfgdir/conf.d/nagios_contact.cfg", 
    "$nagios::cfgdir/conf.d/nagios_contactgroup.cfg",
    "$nagios::cfgdir/conf.d/nagios_host.cfg",
    "$nagios::cfgdir/conf.d/nagios_hostextinfo.cfg",
    "$nagios::cfgdir/conf.d/nagios_hostgroup.cfg",
    "$nagios::cfgdir/conf.d/nagios_hostgroupescalation.cfg",
    "$nagios::cfgdir/conf.d/nagios_service.cfg",
    "$nagios::cfgdir/conf.d/nagios_servicedependency.cfg",
    "$nagios::cfgdir/conf.d/nagios_serviceescalation.cfg",
    "$nagios::cfgdir/conf.d/nagios_serviceextinfo.cfg",
    "$nagios::cfgdir/conf.d/nagios_timeperiod.cfg",
  ]:
    ensure => file,
    replace => false,
    notify => Service['nagios'],
    mode => 0644, owner => root, group => 0;
  }

  # manage nagios cfg files
  # must be defined after exported resource overrides and cfg file defs
  file{'nagios_cfgdir':
    path => "$nagios::cfgdir/",
    source => "puppet://$server/modules/common/empty",
    ensure => directory,
    recurse => true,
    purge => true,
    notify => Service['nagios'],
    mode => 0755, owner => root, group => root;
  }
}
