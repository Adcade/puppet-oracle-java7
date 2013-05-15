Exec{ path => '/usr/bin:/bin:/usr/sbin:/sbin' }

define addaptrepo ($ppa = $title) {
  exec {'add-apt-repository':
    command => "add-apt-repository -y ${ppa}",
  }
  exec{'apt-get update':}

  Exec['add-apt-repository'] ~> Exec['apt-get update']
}


class java7 {
  $java_preseed = '/tmp/java.preseed'

  package {'python-software-properties':
    ensure => present,
  }

  addaptrepo{'ppa:webupd8team/java':}

  package {'debconf-utils':
    ensure => present,
  }

  file {$java_preseed:
    content => "oracle-java7-installer shared/accepted-oracle-license-v1-1 select true"
  }

  exec {"set_java_preseed":
    command => "debconf-set-selections ${java_preseed}",
    path    => "/usr/bin",
  }

  package {["oracle-java7-installer", "oracle-java7-set-default"]:
    ensure => present,
  }

  Package['python-software-properties'] -> Addaptrepo['ppa:webupd8team/java'] -> 
  Package['debconf-utils'] -> File[$java_preseed] -> Exec['set_java_preseed'] ->
  Package["oracle-java7-installer", "oracle-java7-set-default"]
}
