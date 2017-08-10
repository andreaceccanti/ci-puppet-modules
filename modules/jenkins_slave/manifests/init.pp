class jenkins_slave ($maven_servers_data = [], $java_version = 8,) {
  require maven_repo

  if $lsbmajdistrelease == 6 {
    require openstack_havana_repo
  }

  $jenkins_user = 'jenkins'

  User {
    managehome => true, }

  class { 'maven_settings': servers_data => $maven_servers_data, }

  case $lsbmajdistrelease {
    5       : {
      user { $jenkins_user:
        ensure => present,
        name   => $jenkins_user,
      }
    }

    6       : {
      user { $jenkins_user:
        ensure => present,
        name   => $jenkins_user,
      }
    }
    default : {
      fail('Unsupported OS release')
    }
  }

  ssh_authorized_key { 'jenkins-radiohead-key':
    ensure  => present,
    user    => $jenkins_user,
    key     => 'AAAAB3NzaC1yc2EAAAABIwAAAQEAs+blArs0q6G39nfcmakCsuuyAjQF/SM4igDY87Re9Q43TAz8JHiKZOBt2Dnh1Rjh3BpSDleFcfDND3fT6fZ+46g/iQqYbf1oB8WeHYnzt/kOC3KX/QmcG6zlhi3fhi6CE6pi24ApLABiaA2urDA7/793w1CaxdixDgXsZo2lyxExFVMLMiVybDrjyErJ83PIdnsJ9U/p//r4WocSs16CpLhKgohN7QzVlNqTsBrnHWGHnLDXLsRvbKaHgiQvd9YznPzg72AaQ+aB+tryw9b8H/u2xc+akL96DixSp1KnF82Bmk+rBFZOcnUAMNKUfdQdBPbQMYVvD/VM++ZLLuFFsQ==',
    type    => ssh-rsa,
    require => User[$jenkins_user],
  }

  file { "/home/jenkins/${fqdn}":
    ensure  => directory,
    owner   => $jenkins_user,
    group   => $jenkins_user,
    mode    => '0750',
    require => User[$jenkins_user],
  }

  package { 'apache-maven': ensure => present, }

  if $lsbmajdistrelease == 6 {
    package { 'yum-cron': ensure => present, }

    service { 'yum-cron':
      require => Package['yum-cron'],
      enable  => true,
    }
  }

  if $lsbmajdistrelease == 5 {
    package { 'yum-autoupdate': ensure => present, }

    service { 'yum':
      require => Package['yum-autoupdate'],
      enable  => true,
    }
  }

  if $lsbmajdistrelease == 6 {
    package { 'python-novaclient': ensure => present, }
  }
}
