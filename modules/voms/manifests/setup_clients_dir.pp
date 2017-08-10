#
# == Class: voms::setup-clients-dir
# Install voms-clients package.
#
class voms::setup_clients_dir {
  require egi_trust_anchors

  file { '/etc/grid-security/vomsdir':
    ensure  => directory,
    owner   => root,
    group   => root,
    mode    => '0755',
    purge   => true,
    recurse => true,
  }

  file { '/etc/vomses':
    ensure  => directory,
    owner   => root,
    group   => root,
    mode    => '0755',
    purge   => true,
    recurse => true,
  }

}
