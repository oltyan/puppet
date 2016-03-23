Exec {
  path => "/bin:/usr/bin"
}

exec { "apt-get update": }

package { "nodejs": 
    ensure => present,
    require => Exec["apt-get update"]
}

package { "npm": 
    ensure => present,
    require => Exec["apt-get update"]
}

package { "git":
  ensure => present,
  require => Exec["apt-get update"]
}

package { "vim":
  ensure => present,
  require => Exec["apt-get update"]
}

package { "curl":
    ensure => present,
}

