class test_ca {
  file { 'test-ca.repo':
    path   => '/etc/yum.repos.d/test-ca.repo',
    ensure => file,
    source => 'puppet:///modules/test_ca/test-ca.repo'
  }

  package { 'igi-test-ca':
    ensure  => latest,
    require => File['test-ca.repo']
  }

  package { 'igi-test-ca-2':
    ensure  => latest,
    require => File['test-ca.repo']
  }

  package { 'igi-test-ca-256':
    ensure  => latest,
    require => File['test-ca.repo']
  }
}
