class yum_utils {

  package { 'yum-utils':
    ensure  => present,
  }

  define builddep {
    Exec {
      path => '/bin:/sbin:/usr/bin:/usr/sbin', }

    exec { "yum-builddep-${title}": command => "yum-builddep -y ${title}", }
  }
}

