#
# nagios module
# nagios.pp - everything nagios related
#
# Copyright (C) 2007 David Schmitt <david@schmitt.edv-bus.at>
# Copyright 2008, admin(at)immerda.ch
# Copyright 2008, Puzzle ITC GmbH
# Marcel Härry haerry+puppet(at)puzzle.ch
# Simon Josi josi+puppet(at)puzzle.ch
#
# This program is free software; you can redistribute 
# it and/or modify it under the terms of the GNU 
# General Public License version 3 as published by 
# the Free Software Foundation.
#

class nagios(
  $webserver = 'apache',
  $cfgdir = false,
  $use_icinga = false
) {
  case $webserver {
    'lighttpd': { include lighttpd }
    'apache': { include apache }
  }
  case $operatingsystem {
    'centos': {
      $packagename = $use_icinga ? {
        true => 'icinga',
        default => 'nagios',
      }
      if ! $cfgdir {
        $cfgdir = "/etc/$packagename"
      }
      include nagios::centos
    }
    'debian': {
      $packagename = $use_icinga ? {
        true => 'icinga',
        default => 'nagios3',
      }
      if ! $cfgdir {
        $cfgdir = "/etc/$packagename"
      }
      include nagios::debian
    }
    default: { fail("Operatingsystem '$operatingsystem' not supported") }
  }
}
