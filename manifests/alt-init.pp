class java7 {
  $java_preseed = '/tmp/java.preseed'

  file { '/etc/apt/sources.list.d':
    ensure => directory,
  } -> Apt::Ppa<||>

  apt::ppa { 'ppa:webupd8team/java':
    before  => Package['debconf-utils'],
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
