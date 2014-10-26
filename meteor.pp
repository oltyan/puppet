exec { "apt-get update":
  path => "/usr/bin",
}

package { "python":
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

package { "python-pip":
  ensure => present,
  require => Exec["apt-get update"]
}

package { "curl":
  ensure => present,
}

#This includes the python packages needed for the project 
package { "flask":
  ensure => present,
  provider => pip
  
}


