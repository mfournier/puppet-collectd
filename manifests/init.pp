# Class: collectd
#
# Base class, which will install collectd for you, configure the minimum
# needed to run it and start the daemon.
#
# Parameters:
#  [*confdir*]: - See collectd::config
#
#  [*rootdir*]: - See collectd::config
#
#  [*interval*]: - See collectd::config
#
#  [*version*]: - See collectd::package
#
# Sample Usage:
#
#    class { 'collectd':
#      interval => {
#        'cpu'    => 5,
#        'memory' => 20,
#      }
#    }
#
#
class collectd (
  $confdir  = '/etc/collectd',
  $rootdir  = undef,
  $interval = {},
  $version  = 'present',
  $manage_package = true
) {

  anchor {'collectd::begin': }
  anchor {'collectd::end': }

  class { '::collectd::package':
    version        => $version,
    manage_package => $manage_package,
    notify         => Class['::collectd::service'],
  }

  class { '::collectd::config':
    confdir  => $confdir,
    rootdir  => $rootdir,
    interval => $interval,
    notify   => Class['::collectd::service'],
  }

  class { '::collectd::service': }

  Anchor['collectd::begin']
  -> Class['collectd::package']
  -> Class['collectd::config']
  -> Collectd::Setup::Loadplugin <| |>
  -> Collectd::Config::Plugin <| |>
  -> Collectd::Config::Chain <| |>
  -> Collectd::Config::Global <| |>
  -> Class['collectd::service']

}
