Exec{ path => '/usr/bin:/bin:/usr/sbin:/sbin' }

#file { '/etc/apt/sources.list.d':
#  ensure => directory,
#} ~> Apt::Ppa<||>

class { 'apt':
  always_apt_update    => false,
  disable_keys         => undef,
  proxy_host           => false,
  proxy_port           => '8080',
  purge_sources_list   => false,
  purge_sources_list_d => false,
  purge_preferences_d  => false
}

class java7 {
  $java_preseed = '/tmp/java.preseed'

  #package {'python-software-properties':
  #  ensure => present,
  #}

  apt::ppa{'ppa:webupd8team/java':
    before  => Package['debconf-utils'],
    require => Class['apt']
  }

  package {'debconf-utils':
    ensure => present,
  }

  file {$java_preseed:
    content => "oracle-java7-installer shared/accepted-oracle-license-v1-1 select true"
  }

  exec {'accept_license':
    command => "debconf-set-selections ${java_preseed}",
    path    => "/usr/bin",
    require => [Package['debconf-utils'], File[$java_preseed]],
  }

  package {["oracle-java7-installer", "oracle-java7-set-default"]:
    ensure   => present,
    require  => Exec['accept_license']
  }
}
