# == Class: puppet-jenkins-slave
#
# Set up a node as a Jenkins slave.
#
# === Parameters
#
#
# [*sample_parameter*]
#   It takes in  parameters to configure maven settings.
#   The default (empty list) produce a configuration file (settings.xml) without any "server" tag.
#   Parameters are passed in as a list of hashes.
#   "id" is the id of the maven repo where artifacts must be uploaded.
#   "login" and "pwd" needed for accessing the remote server.
#
#
# === Examples
#
#   include puppet-jenkins-slave
#
#   or with server params:
#
#   class { 'puppet-jenkins-slave':
#        maven_servers_data => [ { id => 'server1', login => 'login1', pwd => 'pwd1' } ]
#   }


class puppet-jenkins-slave ($maven_servers_data=[], $java_version=8) {

  include puppet-emi3-release
  require puppet-docker
  require puppet-maven-repo
  require puppet-java

  class { 'puppet-java':
    java_version => $java_version
  }

  if $lsbmajdistrelease == 6 {
    require puppet-openstack-havana-repo
  }

  class { 'maven-settings':
    servers_data => $maven_servers_data
  }

  User {
    managehome => true
  }

  case $lsbmajdistrelease {

    5: {
        user { 'jenkins':
          name => 'jenkins',
          ensure => 'present'
        }
      }

    6: {

        user { 'jenkins':
          name => 'jenkins',
          ensure => 'present',
          groups => ['docker']
        }
      }
  }

  ssh_authorized_key { 'jenkins-radiohead-key':
    ensure => 'present',
    user => 'jenkins',
    key => 'AAAAB3NzaC1yc2EAAAABIwAAAQEAs+blArs0q6G39nfcmakCsuuyAjQF/SM4igDY87Re9Q43TAz8JHiKZOBt2Dnh1Rjh3BpSDleFcfDND3fT6fZ+46g/iQqYbf1oB8WeHYnzt/kOC3KX/QmcG6zlhi3fhi6CE6pi24ApLABiaA2urDA7/793w1CaxdixDgXsZo2lyxExFVMLMiVybDrjyErJ83PIdnsJ9U/p//r4WocSs16CpLhKgohN7QzVlNqTsBrnHWGHnLDXLsRvbKaHgiQvd9YznPzg72AaQ+aB+tryw9b8H/u2xc+akL96DixSp1KnF82Bmk+rBFZOcnUAMNKUfdQdBPbQMYVvD/VM++ZLLuFFsQ==',
    type => 'ssh-rsa',
    require => User['jenkins']
  }

  file { "/home/jenkins/${fqdn}":
    ensure => "directory",
    owner  => "jenkins",
    group  => "jenkins",
    mode   => 750,
    require => User['jenkins']
  }

  package { 'apache-maven':
    ensure => present
  }

  if $lsbmajdistrelease == 6 {
    package { 'yum-cron':
      ensure => present
    }

    service { 'yum-cron':
      require => Package['yum-cron'],
      enable => true
    }
  }

  if $lsbmajdistrelease == 5 {

     package { 'yum-autoupdate':
       ensure => present
    }
    service { 'yum':
      require => Package['yum-autoupdate'],
      enable => true
    }
  }

  if $lsbmajdistrelease == 6 {
    package { 'python-novaclient':
      ensure => present
    }
  }
}

