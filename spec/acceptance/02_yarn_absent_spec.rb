require 'spec_helper_acceptance'

describe 'removing yarn' do

  describe 'running puppet code' do
    pp = <<-EOS
      class { 'nodejs':
        repo_url_suffix => '6.x',
      }

      if $::osfamily == 'Debian' and $::operatingsystemrelease == '7.3' {
        class { 'yarn':
          manage_repo    => false,
          install_method => 'npm',
          require        => Class['nodejs'],
          package_ensure => 'absent',
        }
      }
      elsif $::osfamily == 'Debian' and $::operatingsystemrelease == '7.8' {
        class { 'yarn':
          manage_repo    => false,
          install_method => 'source',
          require        => Package['nodejs'],
          package_ensure => 'absent',
        }
      }
      else {
        class { 'yarn':
          package_ensure => 'absent',
        }

        if $::osfamily == 'RedHat' and $::operatingsystemrelease =~ /^5\.(\d+)/ {
          class { 'epel': }
          Class['epel'] -> Class['nodejs'] -> Class['yarn']
        }
      }
    EOS
    let(:manifest) { pp }

    it 'should work with no errors' do
      apply_manifest(manifest, :catch_failures => true)
    end

    it 'should be idempotent' do
      apply_manifest(manifest, :catch_changes => true)
    end

    describe command('yarn -h') do
      its(:exit_status) { should eq 127 }
    end

  end

end
