# == Class: puppet-storm-build-deps
#
# Install building dependencies for all the StoRM packages.
#
# === Examples
#
#   include puppet-storm-build-deps



class puppet-storm-build-deps {

  include puppet-base-build-env
  require puppet-yum-utils
  require puppet-storm-repos
  require puppet-gpfs-repo

  /* StoRM XML rpc build requires svn */
  package { "install-svn":
    name   => 'svn',
    ensure => latest
  }

  /* And readline devel */
  package {'readline-devel':
    ensure => latest
  }

  $packages = [
    'storm-backend-server',
    'storm-dynamic-info-provider',
    'storm-frontend-server',
    'storm-globus-gridftp-server',
    'storm-gridhttps-server',
    'storm-native-libs',
    'storm-srm-client',
    'yaim-storm']

  puppet-yum-utils::builddep { $packages: }
}

