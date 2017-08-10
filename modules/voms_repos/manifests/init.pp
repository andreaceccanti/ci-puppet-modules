class voms_repos ($repo_scope = 'develop',) {
  include egi_trust_anchors
  include test_ca

  case $operatingsystem {
    centos, Scientific : { $is_redhat = true }
    default            : { fail('Unrecognized operating system for voms_repos.') }
  }

  case $lsbmajdistrelease {
    5       : {
      $voms_repo_file = "puppet:///modules/voms_repos/voms-${repo_scope}_sl5.repo"
      $voms_repo_file_src = "puppet:///modules/voms_repos/voms-${repo_scope}_sl5_src.repo"
    }
    6       : {
      $voms_repo_file = "puppet:///modules/voms_repos/voms-${repo_scope}_sl6.repo"
      $voms_repo_file_src = "puppet:///modules/voms_repos/voms-${repo_scope}_sl6_src.repo"
    }

    default : {
      fail("Unrecognized scientific linux major version: ${lsbmajdistrelease}")
    }
  }

  file { 'voms-devel.repo':
    ensure => file,
    path   => '/etc/yum.repos.d/voms-devel.repo',
    source => $voms_repo_file,
  }

  file { 'voms-devel_src.repo':
    ensure => file,
    path   => '/etc/yum.repos.d/voms-devel_src.repo',
    source => $voms_repo_file_src,
  }
}
