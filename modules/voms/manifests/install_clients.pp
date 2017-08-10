class voms::install_clients {
  require test_vos

  package { 'install-voms-clients3':
    ensure  => latest,
    name    => 'voms-clients3'
  }

}
