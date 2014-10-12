exec { "apt-get update":
  path => "/usr/bin",
}

package { "python":
  ensure => present,
  require => Exec["apt-get update"],
}

