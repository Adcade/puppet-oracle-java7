define addaptrepo ($ppa = $title) {
  package {'python-software-properties':
    ensure => present,
  }

  exec {'add-apt-repository':
    command => "add-apt-repository -y ${ppa}",
    require => Package['python-software-properties'],
  } ->
  exec{'always apt-get update':
    command => 'apt-get update',
  }
}


class java7 {
  $java_preseed = '/tmp/java.preseed'

  file {$java_preseed:
    content => "oracle-java7-installer shared/accepted-oracle-license-v1-1 select true"
  }

  addaptrepo{'ppa:webupd8team/java':} ->

  package {'debconf-utils':
    ensure  => present,
    require => Addaptrepo['ppa:webupd8team/java'],
  }

  exec { "accept_license":
    command => "debconf-set-selections ${java_preseed}",
    path    => "/usr/bin",
    require => [Package['debconf-utils'] -> File[$java_preseed]],
  } 

  package {["oracle-java7-installer", "oracle-java7-set-default"]:
    ensure  => present,
    require => Exec['accept_license'],
  }
}
