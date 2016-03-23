Exec {
  path => "/bin:/usr/bin"
}

exec { "apt-get update": }

class { '::nodejs':
        manage_package_repo       => false,
        nodejs_dev_package_ensure => 'present',
        npm_package_ensure        => 'present',
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

package { 'express':
          ensure   => 'present',
          provider => 'npm',
        }

package { 'mime':
          ensure   => '1.2.4',
          provider => 'npm',
        }
