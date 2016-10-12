require 'spec_helper'

describe 'yarn', :type => :class do

  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) do
        facts
      end

      context 'with default params' do

        it { is_expected.to contain_class('stdlib') }

        it { is_expected.to contain_class('yarn::params') }

        case facts[:osfamily]
        when 'Debian'
          it { is_expected.to contain_class('yarn::repo')
                  .with_manage_repo(true)
          }
        when 'RedHat'
          it { is_expected.to contain_class('yarn::repo')
                  .with_manage_repo(true)
          }
        else
          it { is_expected.to contain_class('yarn::repo')
                  .with_manage_repo(false)
          }
        end

        case facts[:osfamily]
        when 'Debian'
          it { is_expected.to contain_class('yarn::install')
                  .with_package_ensure('present')
                  .with_package_name('yarn')
                  .with_install_method('package')
                  .with_source_install_dir('/opt')
                  .with_symbolic_link('/usr/local/bin/yarn')
                  .with_user('root')
                  .with_source_url('https://yarnpkg.com/latest.tar.gz')
          }
        when 'RedHat'
          it { is_expected.to contain_class('yarn::install')
                  .with_package_ensure('present')
                  .with_package_name('yarn')
                  .with_install_method('package')
                  .with_source_install_dir('/opt')
                  .with_symbolic_link('/usr/local/bin/yarn')
                  .with_user('root')
                  .with_source_url('https://yarnpkg.com/latest.tar.gz')
          }
        else
          it { is_expected.to contain_class('yarn::install')
                  .with_package_ensure('present')
                  .with_package_name('yarn')
                  .with_install_method('source')
                  .with_source_install_dir('/opt')
                  .with_symbolic_link('/usr/local/bin/yarn')
                  .with_user('root')
                  .with_source_url('https://yarnpkg.com/latest.tar.gz')
          }
        end

      end

      context 'with manage_repo => true' do
        let :params do {
          :manage_repo => true,
        }
        end

        case facts[:osfamily]
        when 'Debian'
          it { is_expected.to contain_class('yarn::repo')
                  .with_manage_repo(true)
          }
        when 'RedHat'
          it { is_expected.to contain_class('yarn::repo')
                  .with_manage_repo(true)
          }
        else
          it { is_expected.to raise_error(Puppet::Error, /can not manage repo on/) }
        end

      end

      context 'with manage_repo => false' do
        let :params do {
          :manage_repo => false,
        }
        end

        it { is_expected.to contain_class('yarn::repo')
                .with_manage_repo(false)
        }
      end

      context 'with install_method => npm' do
        let :params do {
          :install_method => 'npm',
          :manage_repo => false,
        }
        end

        it { is_expected.to contain_class('yarn::install')
                .with_install_method('npm')
        }
      end

      context 'with package_ensure => dummy' do
        let :params do {
          :package_ensure => 'dummy',
        }
        end

        it { is_expected.to contain_class('yarn::install')
                .with_package_ensure('dummy')
        }
      end

      context 'with package_name => dummy' do
        let :params do {
          :package_name => 'dummy',
        }
        end

        it { is_expected.to contain_class('yarn::install')
                .with_package_name('dummy')
        }
      end

      context 'with source_install_dir => dummy' do
        let :params do {
          :source_install_dir => 'dummy',
        }
        end

        it { is_expected.to contain_class('yarn::install')
                .with_source_install_dir('dummy')
        }
      end

      context 'with symbolic_link => dummy' do
        let :params do {
          :symbolic_link => 'dummy',
        }
        end

        it { is_expected.to contain_class('yarn::install')
                .with_symbolic_link('dummy')
        }
      end

      context 'with user => dummy' do
        let :params do {
          :user => 'dummy',
        }
        end

        it { is_expected.to contain_class('yarn::install')
                .with_user('dummy')
        }
      end

      context 'with source_url => dummy' do
        let :params do {
          :source_url => 'dummy',
        }
        end

        it { is_expected.to contain_class('yarn::install')
                .with_source_url('dummy')
        }
      end
    end
  end

end
